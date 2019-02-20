<p align="center">
  <img src="https://i.imgur.com/aljsEUU.png" width="160" alt="eddystone">
</p>

# react-native-eddystone

A simple implementation of the Eddystone protocol for react-native. The library also aims to includes a manager class that allows simple beacon telemetry linking, caching and expiration in the future.

## Installation

`$ npm install react-native-eddystone --save`

`$ react-native link react-native-eddystone`

### Manual installation

#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-eddystone` and add `Eddystone.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libEddystone.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)

Alternatively, you can use Cocoapods like so:

`pod 'Eddystone', :path => '../node_modules/react-native-eddystone'`

#### Android

1. Open up `android/app/src/main/java/[...]/MainActivity.java`

- Add `import com.lg2.eddystone;` to the imports at the top of the file
- Add `new EddystonePackage()` to the list returned by the `getPackages()` method

2. Append the following lines to `android/settings.gradle`:

   ```
   include ':react-native-eddystone'
   project(':react-native-eddystone').projectDir = new File(rootProject.projectDir, 	'../node_modules/react-native-eddystone/android')
   ```

3. Insert the following lines inside the dependencies block in `android/app/build.gradle`:
   ```
   compile project(':react-native-eddystone')
   ```

## Usage

This is a very simple example of how to listen to UID broadcasting Eddystone beacons. For more examples, refer to the `examples` folder.

```javascript
import Eddystone from "react-native-eddystone";

// bind a callback when detecting a uid frame
Eddystone.addListener("onUIDFrame", function(beacon) {
  console.log(beacon);
});

// start listening for beacons
Eddystone.startScanning();

// stop listening for beacons
Eddystone.stopScanning();
```

### API

| Method         | Arguments                                 | Description                                                               |
| -------------- | ----------------------------------------- | ------------------------------------------------------------------------- |
| startScanning  | None                                      | Starts the device's bluetooth manager and looks for Eddystone beacons.    |
| stopScanning() | none                                      | Stop the device's bluetooth manager from listening for Eddystone beacons. |
| addListener    | `event: string`<br />`callback: Function` | Registers a callback function to an event.                                |

### Events

There are many events that can be subscribed to using the library's `addListener` method.

| Name             | Parameters          | Description                                                          |
| ---------------- | ------------------- | -------------------------------------------------------------------- |
| onUIDFrame       | `beacon: Beacon`    | The device received information from a beacon broadcasting UID data. |
| onEIDFrame       | `beacon: Beacon`    | The device received information from a beacon broadcasting EID data. |
| onUrlFrame       | `url: string`       | The device received a Url broadcasted by a beacon.                   |
| onTelemetryFrame | `telemetry: string` | The device received telemetry information from a beacon.             |
| onStateChanged   | `state: string`     | The device's bluetooth manager state has changed. (iOS only)         |

### Objects

#### Beacon

```js
{
  id: string,
  uuid: string,
  type: number,
  txPower: number,
  rssi: number
}
```