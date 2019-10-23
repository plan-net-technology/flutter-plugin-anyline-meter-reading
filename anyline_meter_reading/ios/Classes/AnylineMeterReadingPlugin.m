#import "AnylineMeterReadingPlugin.h"
#import <anyline_meter_reading/anyline_meter_reading-Swift.h>

@implementation AnylineMeterReadingPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAnylineMeterReadingPlugin registerWithRegistrar:registrar];
}
@end
