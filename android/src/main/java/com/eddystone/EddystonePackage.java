/**
 * React Native Eddystone
 *
 * A simple Eddystone implementation in React Native for both iOS and Android.
 *
 * 
 * @package original   @lg2/react-native-eddystone
 * @package    react-native-eddystone
 * @link       https://github.com/lg2/react-native-eddystone
 * @copyright  2025 Skura
 * @license    MIT
 */

package com.eddystone;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;
import com.facebook.react.bridge.JavaScriptModule;

public class EddystonePackage implements ReactPackage {

  public EddystonePackage(){
  }
  @Override
      public List<NativeModule> createNativeModules(ReactApplicationContext reactApplicationContext) {
          List<NativeModule> modules = new ArrayList<>();
  
          modules.add(new EddystoneModule(reactApplicationContext));
          return modules;
      }
  
      public List<Class<? extends JavaScriptModule>> createJSModules() {
          return new ArrayList<>();
      }
  
      @Override
      public List<ViewManager> createViewManagers(ReactApplicationContext reactApplicationContext) {
          return Collections.emptyList();
      }
}