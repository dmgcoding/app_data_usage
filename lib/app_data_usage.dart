// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/to/pubspec-plugin-platforms.

import 'package:app_data_usage/src/models/usage_details.dart';

import 'app_data_usage_platform_interface.dart';

class AppDataUsage {
  static final AppDataUsage _instance = AppDataUsage();

  static AppDataUsage get instance => _instance;

  /// Checks if data usage stats permission granted
  Future<bool?> checkPermission() async {
    try {
      return await AppDataUsagePlatform.instance.checkIfPermissionGranted();
    } catch (e) {
      rethrow;
    }
  }

  /// Requests permission for app usage stats
  /// This will open settings
  /// User have to manually enable permission
  Future<bool?> requestPermission() async {
    try {
      return await AppDataUsagePlatform.instance.requestPermission();
    } catch (e) {
      rethrow;
    }
  }

  /// Retrieves the daily data usage for the current app.
  ///
  /// This method returns a `UsageDetails` containing:
  /// - `rxBytes`: The number of bytes received.
  /// - `txBytes`: The number of bytes transmitted.
  ///
  /// Check for `isSuccess` property to check if query was success
  /// if true use the `rxBytes`, `txBytes` values
  ///
  /// use 'error' property to get the error message
  Future<UsageDetails> getDailyDataUsageForApp() async {
    try {
      final dataMap =
          await AppDataUsagePlatform.instance.getDailyDataUsageForApp();
      return UsageDetails.fromJson(dataMap);
    } catch (e) {
      rethrow;
    }
  }
}
