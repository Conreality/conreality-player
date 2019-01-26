/* This is free and unencumbered software released into the public domain. */

package org.conreality.player;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugins.androidalarmmanager.AlarmService;

import com.transistorsoft.flutter.backgroundfetch.BackgroundFetchPlugin;
import com.transistorsoft.flutter.backgroundgeolocation.FLTBackgroundGeolocationPlugin;
//import com.transistorsoft.flutter.backgroundgeolocation.HeadlessTask;

public class Application extends FlutterApplication implements PluginRegistrantCallback {
  @Override
  public void onCreate() {
    super.onCreate();
    //AlarmService.setPluginRegistrant(this); // FIXME
    BackgroundFetchPlugin.setPluginRegistrant(this);
    FLTBackgroundGeolocationPlugin.setPluginRegistrant(this);
    //HeadlessTask.setPluginRegistrant(this); // FIXME
  }

  @Override
  public void registerWith(final PluginRegistry registry) {
    GeneratedPluginRegistrant.registerWith(registry);
  }
}
