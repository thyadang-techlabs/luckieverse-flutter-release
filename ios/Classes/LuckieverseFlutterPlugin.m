#import <Flutter/Flutter.h>

#if __has_include(<luckieverse_flutter/luckieverse_flutter-Swift.h>)
#import <luckieverse_flutter/luckieverse_flutter-Swift.h>
#else
#import "luckieverse_flutter-Swift.h"
#endif

@interface LuckieverseFlutterPlugin : NSObject<FlutterPlugin>
@end

@implementation LuckieverseFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftLuckieverseFlutterPlugin registerWithRegistrar:registrar];
}
@end
