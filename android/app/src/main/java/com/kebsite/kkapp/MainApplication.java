package com.kebsite.kkapp;

import io.flutter.app.FlutterApplication;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.PluginRegistry;

public class MainApplication extends FlutterApplication implements PluginRegistry.PluginRegistrantCallback {
    @Override
    public void onCreate() {
      super.onCreate();
      //AudioServicePlugin.setPluginRegistrantCallback(this);
    }
  
    @Override
    public void registerWith(PluginRegistry registry) {
      GeneratedPluginRegistrant.registerWith(registry);
    }
}