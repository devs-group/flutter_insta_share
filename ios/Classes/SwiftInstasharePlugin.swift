import Flutter
import UIKit

public class SwiftInstasharePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "instashare", binaryMessenger: registrar.messenger())
    let instance = SwiftInstasharePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard call.method == "shareToFeedInstagram" else {
        result(FlutterMethodNotImplemented)
        return
    }
    guard let args = call.arguments else {
        result("iOS could not recognize flutter arguments in method: (sendParams)")
        return
    }
    if let myArgs = args as? [String: Any],
    let path = myArgs["path"] as? String {
        self.shareToInstagram(result: result, path: path)
    }
  }

  private func shareToInstagram(result: @escaping FlutterResult, path: String) {
    let image = UIImage(contentsOfFile: path)
    let manager = InstagramManager(result: result)
    manager.postImageToInstagram(imageInstagram: image!, result: result)
  }
}
