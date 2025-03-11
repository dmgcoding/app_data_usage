import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'app_data_usage_platform_interface.dart';

/// An implementation of [AppDataUsagePlatform] that uses method channels.
class MethodChannelAppDataUsage extends AppDataUsagePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('app_data_usage');

  @override
  Future<bool?> checkIfPermissionGranted() async {
    try {
      return await methodChannel.invokeMethod<bool>('checkPermission');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool?> requestPermission() async {
    try {
      return await methodChannel.invokeMethod<bool>('requestPermission');
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<Map<dynamic, dynamic>?> getDailyDataUsageForApp() async {
    try {
      return await methodChannel
          .invokeMethod<Map<dynamic, dynamic>?>('getDailyDataUsageForApp');
    } catch (e) {
      rethrow;
    }
  }
}
