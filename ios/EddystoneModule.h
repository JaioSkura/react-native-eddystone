#import <CoreBluetooth/CoreBluetooth.h>
#import <Foundation/Foundation.h>

#ifdef RCT_NEW_ARCH_ENABLED

#import <EddystoneModuleSpec/EddystoneModuleSpec.h>
@class Eddystone;

@interface EddystoneModule : NativeEddystoneModuleSpecBase <NativeEddystoneModuleSpec>
- (void)emitOnUIDFrame:(NSDictionary *)value;
- (void)emitOnURLFrame:(NSDictionary *)value;
- (void)emitOnEIDFrame:(NSDictionary *)value;
- (void)emitOnTelemetryData:(NSDictionary *)value;
- (void)emitOnEmptyFrame:(NSDictionary *)value;
- (void)emitOnStateChanged:(NSDictionary *)value;
//+ (nullable CBCentralManager *)getCentralManager;
//+ (nullable SwiftBleManager *)getInstance;
@end

#else

@interface EddystoneModule : NSObject
- (void)emitOnUIDFrame:(NSDictionary *)value;
- (void)emitOnURLFrame:(NSDictionary *)value;
- (void)emitOnEIDFrame:(NSDictionary *)value;
- (void)emitOnTelemetryData:(NSDictionary *)value;
- (void)emitOnEmptyFrame:(NSDictionary *)value;
- (void)emitOnStateChanged:(NSDictionary *)value;
//+ (nullable CBCentralManager *)getCentralManager;
//+ (nullable SwiftBleManager *)getInstance;
@end

#endif

@interface SpecChecker : NSObject
+ (BOOL)isSpecAvailable;
@end
