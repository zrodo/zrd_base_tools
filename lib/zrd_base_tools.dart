import 'dart:async';

import 'package:flutter/services.dart';

class ZrdBaseTools {
  static const MethodChannel _channel = const MethodChannel('zrd_base_tools');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<String> get camera async {
    final String version = await _channel.invokeMethod('cameraPermission');
    return version;
  }

  static Future<String> get photo async {
    final String version =
        await _channel.invokeMethod('photoAlibumpermissions');
    return version;
  }

  static Future showVideo(String string) async {
    await _channel.invokeMethod('showFileKey', {'path': string});
  }
}
