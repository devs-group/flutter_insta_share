#import "InstasharePlugin.h"
#if __has_include(<instashare/instashare-Swift.h>)
#import <instashare/instashare-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "instashare-Swift.h"
#endif

@implementation InstasharePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftInstasharePlugin registerWithRegistrar:registrar];
}
@end
