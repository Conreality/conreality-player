/* This is free and unencumbered software released into the public domain. */

package org.conreality.player;

import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL_FOR_START = "app.conreality.org/start";
  private static final String CHANNEL_FOR_GAME  = "app.conreality.org/game";
  private static final String CHANNEL_FOR_CHAT  = "app.conreality.org/chat";
  private static final String CHANNEL_FOR_MAP   = "app.conreality.org/map";

  @Override
  protected void onCreate(final Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), CHANNEL_FOR_START).setMethodCallHandler(
      new MethodCallHandler() {
        @Override
        public void onMethodCall(final MethodCall call, final Result result) {
          result.notImplemented(); // TODO
        }
      });

    new MethodChannel(getFlutterView(), CHANNEL_FOR_GAME).setMethodCallHandler(
      new MethodCallHandler() {
        @Override
        public void onMethodCall(final MethodCall call, final Result result) {
          result.notImplemented(); // TODO
        }
      });

    new MethodChannel(getFlutterView(), CHANNEL_FOR_CHAT).setMethodCallHandler(
      new MethodCallHandler() {
        @Override
        public void onMethodCall(final MethodCall call, final Result result) {
          result.notImplemented(); // TODO
        }
      });

    new MethodChannel(getFlutterView(), CHANNEL_FOR_MAP).setMethodCallHandler(
      new MethodCallHandler() {
        @Override
        public void onMethodCall(final MethodCall call, final Result result) {
          result.notImplemented(); // TODO
        }
      });
  }
}
