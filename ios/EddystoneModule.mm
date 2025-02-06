#import "EddystoneModule.h"
#import "Eddystone.h"

#ifdef RCT_NEW_ARCH_ENABLED
#import "EddystoneModuleSpec.h"
#endif

@implementation SpecChecker  

+ (BOOL)isSpecAvailable {
#ifdef RCT_NEW_ARCH_ENABLED
    return YES;
#else
    return NO;
#endif
}

@end

@implementation EddystoneModule     {
    Eddystone *_eddystone;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _eddystone = [[Eddystone alloc] init];
    }
    return self;
}

- (Eddystone *)eddystone {
    return _eddystone;
}

RCT_EXPORT_MODULE()

#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
    (const facebook::react::ObjCTurboModule::InitParams &)params {
    return std::make_shared<facebook::react::NativeEddystoneSpecJSI>(params);
}
#endif

- (void)startScanning {
    [_eddystone startScanning];
}


- (void)stopScannig {
    [_eddystone stopScanning];
}


- (void)setName:(NSString *)name {
    [_eddystone setName:name];
}



@end
