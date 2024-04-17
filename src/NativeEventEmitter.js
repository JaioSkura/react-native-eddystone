/**
 * React Native Eddystone
 *
 * A simple Eddystone implementation in React Native for both iOS and Android.
 * Changed by JaioSkura
 *
 * @package    @lg2/react-native-eddystone
 * @link       https://github.com/lg2/react-native-eddystone
 * @copyright  2019 lg2
 * @license    MIT
 */

import { NativeModules, NativeEventEmitter } from "react-native";

const { Eddystone } = NativeModules;
const EddystoneEventEmitter = new NativeEventEmitter(Eddystone);

const addListener = EddystoneEventEmitter.addListener.bind(
EddystoneEventEmitter);

export { addListener};

