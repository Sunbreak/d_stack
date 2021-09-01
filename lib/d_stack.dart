
import 'dart:async';

import 'package:flutter/services.dart';

class DStack {
  static const MethodChannel _channel =
      const MethodChannel('d_stack');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
