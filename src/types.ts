export interface BeaconData {
    id: string,
    uid: string,
    rssi: number,
    txPower: number
}

export interface TelemetryData {
    uid: string,
    voltage: number,
    temp: number
}

export interface URLData {
    uid: string,
    url: string
}




