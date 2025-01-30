#import "EddystoneModule.h"
#import "Eddystone.h"

@implementation SpecChecker  

+ (BOOL)isSpecAvailable {
#ifdef RCT_NEW_ARCH_ENABLED
    return YES;
#else
    return NO;
#endif
}

@end

@implementation EddystoneModule   {
    Eddystone *_eddystone;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _eddystone = [[Eddystone alloc] init:self];
    }
    return self;
}

- (Eddystone *)eddystone {
    return _eddystone;
}

RCT_EXPORT_MODULE()

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params {
    return std::make_shared<facebook::react::NativeEddystoneSpecJSI>(params);
}

- (void)startScanning:() {
    [_eddystone startScanning];
}


- (void)stopScannig:() {
    [_eddystone stopScannig];
}


- (void)setName:(NSString *)name {
    [_eddystone setName:name];
}

@end
