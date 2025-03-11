# app_data_usage

A Flutter plugin to check daily data usage(both wifi and mobile) for the installed app. Only support for android currently as iOS doesn't allow to query this.

## Install

Add `app_data_usage` as a dependency in `pubspec.yaml`.

## Android

_Requires API level 23 as a minimum!_

Add the following permission to the manifest namespace in `AndroidManifest.xml`:

```xml
    <uses-permission
        android:name="android.permission.PACKAGE_USAGE_STATS"
        tools:ignore="ProtectedPermissions" />
```

Your project manifest should look like this.

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.example.app_data_usage_example">
    <uses-permission
        android:name="android.permission.PACKAGE_USAGE_STATS"
        tools:ignore="ProtectedPermissions" />
```

## Usage

```dart
import 'package:app_data_usage/app_data_usage.dart';

Future<void> checkPermission() async {
    try {
      final granted = await AppDataUsage.instance.checkPermission();
    } catch (e) {
      //get error if thrown
    }
}

Future<bool?> requestPermission() async {
    final granted = await checkPermission();
    if (granted) return null;
    return await AppDataUsage.instance.requestPermission();
}

Future<void> checkDailyDataUsage() async {
    final details = await AppDataUsage.instance.getDailyDataUsageForApp();
    print('details: ${details.toJson()}');
    if (!details.isSuccess) return; //check details.error for error message
    var rxTotalBytes = details.rxBytes;
    var txTotalBytes = details.txBytes;
}
```

Check example project in repo if you have any concerns. [Repo](https://github.com/dmgcoding/app_data_usage)

For issues > [Issues](https://github.com/dmgcoding/app_data_usage/issues)
