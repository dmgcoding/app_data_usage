// import 'package:flutter_test/flutter_test.dart';
// import 'package:app_data_usage/app_data_usage.dart';
// import 'package:app_data_usage/app_data_usage_platform_interface.dart';
// import 'package:app_data_usage/app_data_usage_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockAppDataUsagePlatform
//     with MockPlatformInterfaceMixin
//     implements AppDataUsagePlatform {

//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final AppDataUsagePlatform initialPlatform = AppDataUsagePlatform.instance;

//   test('$MethodChannelAppDataUsage is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelAppDataUsage>());
//   });

//   test('getPlatformVersion', () async {
//     AppDataUsage appDataUsagePlugin = AppDataUsage();
//     MockAppDataUsagePlatform fakePlatform = MockAppDataUsagePlatform();
//     AppDataUsagePlatform.instance = fakePlatform;

//     expect(await appDataUsagePlugin.getPlatformVersion(), '42');
//   });
// }
