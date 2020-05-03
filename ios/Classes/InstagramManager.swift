//
//  InstagramManager.swift
//  InstagramSDK
//
//  Created by Attila Roy on 23/02/15.
//  share image with caption to instagram

import Foundation
import UIKit
import Photos

//let documentInteractionController = UIDocumentInteractionController()

class InstagramManager: NSObject, UIDocumentInteractionControllerDelegate {
    
    private let documentInteractionController = UIDocumentInteractionController()
    private let kInstagramURL = "instagram://app"
    private let kUTI = "com.instagram.photo" //"com.instagram.exclusivegram"
    private let kfileNameExtension = "instagram.igo"//"instagram.igo"
    private let kAlertViewTitle = "Error"
    private let kAlertViewMessage = "Please install the Instagram application"
    var result: FlutterResult
    
    init(result: @escaping FlutterResult) {
        self.result = result
    }
    
    public func postImageToInstagram(imageInstagram: UIImage, result: @escaping FlutterResult) {
        // called to post image with caption to the instagram application
        self.result = result
        
        let instagramURL = NSURL(string: kInstagramURL)
        if UIApplication.shared.canOpenURL(instagramURL! as URL) {
            let jpgPath = (NSTemporaryDirectory() as NSString).appendingPathComponent(kfileNameExtension)
            
            do {
                try imageInstagram.jpegData(compressionQuality: 1)?.write(to: URL(fileURLWithPath: jpgPath), options: .atomic)
            } catch {
                self.result(1)
                return
            }
            
            PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                UIImageWriteToSavedPhotosAlbum(imageInstagram, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
            } else { self.result(2) } }
        }
        else {
            
            // alert displayed when the instagram application is not available in the device
            UIAlertView(title: kAlertViewTitle, message: kAlertViewMessage, delegate:nil, cancelButtonTitle:"Ok").show()
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            self.result(3)
            return
        }
        let fetchOptions = PHFetchOptions()
        // add sorting to take correct element from fetchResult
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        // taking our image local Identifier in photo library to share it
        let fetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        if let lastAsset = fetchResult.firstObject {
            let url = URL(string: "instagram://library?LocalIdentifier=\(lastAsset.localIdentifier)")!
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
                self.result(0)
             }
            else { self.result(4) }
        }
    }
}


