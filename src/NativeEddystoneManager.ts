import { TurboModule, TurboModuleRegistry } from 'react-native';
// @ts-ignore Ignore since it comes from codegen types.
import type { EventEmitter } from 'react-native/Libraries/Types/CodegenTypes';

/**
 * This represents the Turbo Module version of react-native-ble-manager.
 * This adds the codegen definition to react-native generate the c++ bindings on compile time.
 * That should work only on 0.75 and higher.
 * Don't remove it! and please modify with caution! Knowing that can create wrong bindings into jsi and break at compile or execution time.
 *  - Knowing that also every type needs to match the current Objective C++ and Java callbacks types and callbacks type definitions and be aware of the current differences between implementation in both platforms.
 */

export interface Spec extends TurboModule {

    startScanning(): void;

    stopScanning(): void;

    /**
   * Supported events.
   */

    readonly onUIDFrame: EventEmitter<BeaconData>;
    readonly onEIDFrame: EventEmitter<BeaconData>;
    readonly onURLFrame: EventEmitter<URLData>;
    readonly onTelemetryData: EventEmitter<TelemetryData>;
    readonly onEmptyFrame: EventEmitter<string>;
    readonly onStateChanged: EventEmitter<string>;
    

}

export default TurboModuleRegistry.get<Spec>('EddystoneModule') as Spec;
 
export type BeaconData ={
    id: string;
    uid: string;
    rssi: number;
    txPower: number;
}


export type TelemetryData ={
    uid: string;
    voltaje: number;
    temp: number;
}


export type URLData ={
    uid: string;
    url: string;
}