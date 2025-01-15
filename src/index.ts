import {
  EventSubscription,
  NativeModules,
} from 'react-native';

import {
  URLData,
  BeaconData,
  TelemetryData,
} from './types';
export * from './types';


// @ts-expect-error This applies the turbo module version only when turbo is enabled for backwards compatibility.
const isTurboModuleEnabled = global?.__turboModuleProxy != null;

const EddystoneModule = isTurboModuleEnabled
  ? require('./NativeEddystoneManager').default
  : NativeModules.EddystoneModule;

class EddystoneManager {
  constructor() {
    if (!EddystoneModule) {
      throw new Error('EddystoneManagerModule not found');
    }
  }

  startScanning() {
    EddystoneModule.startScanning();
  };

  stopScanning() {
    EddystoneModule.stopScanning();
  };


  onUIDFrame(callback: any): EventSubscription {
    return EddystoneModule.onUIDFrame(callback);
  }

  onEIDFrame(callback: any): EventSubscription {
    return EddystoneModule.onEIDFrame(callback);
  }
  onURLFrame(callback: any): EventSubscription {
    return EddystoneModule.onURLFrame(callback);
  }
  onTelemetryData(callback: any): EventSubscription {
    return EddystoneModule.onTelemetryData(callback);
  }
  onEmptyFrame(callback: any): EventSubscription {
    return EddystoneModule.onEmptyFrame(callback);
  }
  onStateChanged(callback: any): EventSubscription {
    return EddystoneModule.onStateChanged(callback);
  }
}

export default new EddystoneManager();
