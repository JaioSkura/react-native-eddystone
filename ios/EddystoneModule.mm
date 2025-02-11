#import "EddystoneModule.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "Beacon.h"

#ifdef RCT_NEW_ARCH_ENABLED
#import "EddystoneModuleSpec.h"
#endif


@interface EddystoneModule () <CBCentralManagerDelegate> {
@private
  /** @property BOOL Whether we should be scanning for devices or not */
  BOOL _shouldBeScanning;
  
  // core bluetooth central manager
  CBCentralManager *_centralManager;
  
  // our beacon dispatch queue
  dispatch_queue_t _beaconOperationsQueue;
}
@end

@implementation EddystoneModule

- (instancetype)init {
    if ((self = [super init]) != nil) {
        _beaconOperationsQueue = dispatch_queue_create("EddystoneBeaconOperationsQueue", NULL);
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:_beaconOperationsQueue];
    }
    return self;
}


RCT_EXPORT_MODULE()

- (void)startScanning {
    dispatch_async(_beaconOperationsQueue, ^{
        if (self->_centralManager.state != CBCentralManagerStatePoweredOn) {
            self->_shouldBeScanning = YES;
        } else {
            NSArray *services = @[[CBUUID UUIDWithString:SERVICE_ID]];
            NSDictionary *options = @{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES };
            [self->_centralManager scanForPeripheralsWithServices:services options:options];
        }
    });
}


- (void)stopScannig {
    _shouldBeScanning = NO;
    [_centralManager stopScan];
}


//- (void)setName:(NSString *)name {
//    [_eddystone setName:name];
//}

/**
 * Executes when the Core Bluetooth Central Manager discovered a peripheral
 * @param CBCentralManager * central Core Bluetooth Central Manager instance
 * @param CBPeripheral * peripheral Core Bluetooth peripheral instance
 * @param NSDictionary * advertisementData Peripheral advertised data
 * @param NSNumber * RSSI The received signal strength indication
 * @return void
 */
- (void)centralManager:(CBCentralManager *)central
 didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData
                  RSSI:(NSNumber *)RSSI {
    if(hasListeners){
        // retrieve the beacon data from the advertised data
        NSDictionary *serviceData = advertisementData[CBAdvertisementDataServiceDataKey];
        
        // retrieve the frame type
        FrameType frameType = [Beacon getFrameType:serviceData];
        
        // handle basic beacon broadcasts
        if (frameType == FrameTypeUID || frameType == FrameTypeEID) {
            // create our beacon object based on the frame type
            Beacon *beacon;
            NSString *eventName;
            if (frameType == FrameTypeUID) {
                eventName = @"onUIDFrame";
                beacon = [Beacon initWithUIDFrameType:serviceData rssi:RSSI];
            } else if(frameType == FrameTypeEID) {
                eventName = @"onEIDFrame";
                beacon = [Beacon initWithEIDFrameType:serviceData rssi:RSSI];
            }
            //dispatch device event with beacon information
            [_eddystoneModule emitOnUIDFrame:@{
                @"id": [NSString stringWithFormat:@"%@", beacon.id],
                @"uid": [peripheral.identifier UUIDString],
                @"txPower": beacon.txPower,
                @"rssi": beacon.rssi
            }];
            //               dispatch device event with beacon information
            //              [self sendEventWithName:eventName
            //                                 body:@{
            //                @"id": [NSString stringWithFormat:@"%@", beacon.id],
            //                @"uid": [peripheral.identifier UUIDString],
            //                @"txPower": beacon.txPower,
            //                @"rssi": beacon.rssi
            //              }];
        } else if(frameType == FrameTypeURL) {
            // retrive the URL from the beacon broadcast & dispatch
            NSURL *url = [Beacon getUrl:serviceData];
            [self emitOnURLFrame:@{
                @"uid": [peripheral.identifier UUIDString],
                @"url": url.absoluteString
            }];
            //              [self sendEventWithName:@"onURLFrame" body:@{
            //                @"uid": [peripheral.identifier UUIDString],
            //                @"url": url.absoluteString
            //              }];
        } else if (frameType == FrameTypeTelemetry) {
            // retrieve the beacon data
            NSData *beaconData = [Beacon getData:serviceData];
            uint8_t *bytes = (uint8_t *)[beaconData bytes];
            
            // attempt to match a frame type
            if (beaconData) {
                if ([beaconData length] > 1) {
                    int voltage = (bytes[2] & 0xFF) << 8;
                    voltage += (bytes[3] & 0xFF);
                    
                    int temp = (bytes[4] << 8);
                    temp += (bytes[5] & 0xFF);
                    temp /= 256.f;
                    [self emitOnTelemetryData:@{
                        @"uid": [peripheral.identifier UUIDString],
                        @"voltage": [NSNumber numberWithInt: voltage],
                        @"temp": [NSNumber numberWithInt: temp]
                    }];
                    //                      // dispatch telemetry information
                    //                      [self sendEventWithName:@"onTelemetryFrame" body:@{
                    //                        @"uid": [peripheral.identifier UUIDString],
                    //                        @"voltage": [NSNumber numberWithInt: voltage],
                    //                        @"temp": [NSNumber numberWithInt: temp]
                    //                      }];
                }
            }
            
        } else if (frameType == FrameTypeEmpty){
            [self emitOnEmptyFrame:@{}];
            // dispatch empty frame
            // [self sendEventWithName:@"onEmptyFrame" body:nil];
        }
    }
}

/**
 * Executes when the Core Bluetooth Central Manager's state changes
 * @param CBCentralManager manager The Central Manager instance
 * @return void
 */
- (void)centralManagerDidUpdateState:(nonnull CBCentralManager *)manager {
    switch(manager.state) {
        case CBManagerStatePoweredOn:
            // [self sendEventWithName:@"onStateChanged" body:@"on"];
            [self emitOnStateChanged:@{@"value":@"on"}];
            if(_shouldBeScanning) {
                [self startScanning];
            }
            break;
            
        case CBManagerStatePoweredOff:
            [self emitOnStateChanged:@{@"value":@"off"}];
            break;
            
        case CBManagerStateResetting:
            [self emitOnStateChanged:@{@"value":@"resseting"}];
            break;
            
        case CBManagerStateUnsupported:
            //[self sendEventWithName:@"onStateChanged" body:@"unsupported"];
            [self emitOnStateChanged:@{@"value":@"unsupported"}];
            
            break;
            
        case CBManagerStateUnauthorized:
            //[self sendEventWithName:@"onStateChanged" body:@"unauthorized"];
            [self emitOnStateChanged:@{@"value":@"unauthorized"}];
            
            break;
            
        default:
            // [self sendEventWithName:@"onStateChanged" body:@"unknown"];
            [self emitOnStateChanged:@{@"value":@"unknown"}];
            
    }
}
#ifdef RCT_NEW_ARCH_ENABLED
- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:
(const facebook::react::ObjCTurboModule::InitParams &)params
{
    return std::make_shared<facebook::react::NativeEddystoneManagerSpecJSI>(params);
}
#endif
@end
