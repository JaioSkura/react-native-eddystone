#import <CoreBluetooth/CoreBluetooth.h>
#import <Foundation/Foundation.h>



#import <EddystoneModuleSpec/EddystoneModuleSpec.h>
@class Eddystone;

@interface EddystoneModule : NativeEddystoneModuleSpecBase <NativeEddystoneModuleSpec>
- (void)emitOnUIDFrame:(NSDictionary *)value;
- (void)emitOnURLFrame:(NSDictionary *)value;
- (void)emitOnEIDFrame:(NSDictionary *)value;
- (void)emitOnURLFrame:(NSDictionary *)value;
- (void)emitOnTelemetryData:(NSDictionary *)value;
- (void)emitOnEmptyFrame:(NSDictionary *)value;
- (void)emitOnStateChanged:(NSDictionary *)value;
//+ (nullable CBCentralManager *)getCentralManager;
//+ (nullable SwiftBleManager *)getInstance;
@end


@interface SpecChecker : NSObject
+ (BOOL)isSpecAvailable;
@end
