import 'dart:async';

import 'package:flutter/services.dart';

class Instashare {
  static const MethodChannel _channel =
      const MethodChannel('instashare');

  static Future<void> shareToFeedInstagram(String type, String path) async {
    return _channel.invokeMethod('shareToFeedInstagram', <String, dynamic>{
      'type': type,
      'path': path,
    });
  }
}
