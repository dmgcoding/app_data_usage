import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'app_data_usage_method_channel.dart';

abstract class AppDataUsagePlatform extends PlatformInterface {
  /// Constructs a AppDataUsagePlatform.
  AppDataUsagePlatform() : super(token: _token);

  static final Object _token = Object();

  static AppDataUsagePlatform _instance = MethodChannelAppDataUsage();

  /// The default instance of [AppDataUsagePlatform] to use.
  ///
  /// Defaults to [MethodChannelAppDataUsage].
  static AppDataUsagePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AppDataUsagePlatform] when
  /// they register themselves.
  static set instance(AppDataUsagePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> checkIfPermissionGranted() {
    throw UnimplementedError(
        'checkIfPermissionGranted() has not been implemented.');
  }

  Future<bool?> requestPermission() {
    throw UnimplementedError('requestPermission() has not been implemented.');
  }

  Future<Map<dynamic, dynamic>?> getDailyDataUsageForApp() {
    throw UnimplementedError(
        'getDailyDataUsageForApp() has not been implemented.');
  }
}
