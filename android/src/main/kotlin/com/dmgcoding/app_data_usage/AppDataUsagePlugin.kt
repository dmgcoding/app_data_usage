package com.dmgcoding.app_data_usage

import androidx.annotation.NonNull

import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.Binder
import android.app.AppOpsManager
import android.app.usage.NetworkStatsManager
import android.app.usage.NetworkStats
import android.telephony.TelephonyManager
import android.net.NetworkCapabilities

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import java.util.Calendar

/** AppDataUsagePlugin */
class AppDataUsagePlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context : Context

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "app_data_usage")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (call.method == "checkPermission") {
      result.success(checkPermissionGranted())
    } else if(call.method == "requestPermission"){
      result.success(requestPermission())
    } else if(call.method == "getDailyDataUsageForApp"){
      result.success(getDailyDataUsageForApp())
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun checkPermissionGranted(): Boolean {
    val appOps = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
    val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            appOps.unsafeCheckOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, Binder.getCallingUid(), context.packageName)
        } else {
            appOps.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, android.os.Process.myUid(), context.packageName)
        }
    return mode == AppOpsManager.MODE_ALLOWED
  }

  //return true if no error
  //return false if something goes wrong requesting permission
  private fun requestPermission(): String? {
    try {
      val intent = Intent(android.provider.Settings.ACTION_USAGE_ACCESS_SETTINGS)
      intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
      context.startActivity(intent)
      return null
    } catch(e: Exception) {
      return e.message ?: "Unknown error occured"
    }
  }

  private fun getDailyDataUsageForApp(): Map<String,Any> {
    try {
      val uid = android.os.Process.myUid()
      val networkStatsManager = context.getSystemService(Context.NETWORK_STATS_SERVICE) as NetworkStatsManager

      val (startTime, endTime) = getStartAndEndTime()

      val telephonyManager = context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager
      val subscriberId = getSubscriberId(context)

      var totalRxBytes = 0L
      var totalTxBytes = 0L

      // Get mobile data usage
      val mobileStats = networkStatsManager.queryDetailsForUid(
          NetworkCapabilities.TRANSPORT_CELLULAR, subscriberId, startTime, endTime, uid
      )
      val (mobileRx, mobileTx) = getBytesFromStats(mobileStats)
      totalRxBytes += mobileRx
      totalTxBytes += mobileTx

      // Get WiFi data usage
      val wifiStats = networkStatsManager.queryDetailsForUid(
          NetworkCapabilities.TRANSPORT_WIFI, null, startTime, endTime, uid
      )
      val (wifiRx, wifiTx) = getBytesFromStats(wifiStats)
      totalRxBytes += wifiRx
      totalTxBytes += wifiTx

      return mapOf(
        "rxBytes" to totalRxBytes, 
        "txBytes" to totalTxBytes,
        "isSuccess" to true
      )
    } catch(e: Exception) {
      return mapOf(
        "isSuccess" to false,
        "error" to (e.message ?: "Some error occurred")
      )
    }
  }

  private fun getSubscriberId(
        context: Context,
    ): String? {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q)
                return null

            val telephonyManager = context.getSystemService(Context.TELEPHONY_SERVICE) as TelephonyManager?
            return telephonyManager?.subscriberId
        } catch (_: Exception) {
        }

        return "";
    }

  private fun getBytesFromStats(stats: NetworkStats?): Pair<Long, Long> {
    var rxBytes = 0L
    var txBytes = 0L
    if (stats != null) {
        val bucket = NetworkStats.Bucket()

        while (stats.hasNextBucket()) {
            stats.getNextBucket(bucket)
            rxBytes += bucket.rxBytes
            txBytes += bucket.txBytes
        }
        stats.close()
    }
    return Pair(rxBytes, txBytes)
  }

  private fun getStartAndEndTime(): Pair<Long, Long> {
    val calendar = Calendar.getInstance()

    // Set start time to today 00:00:00
    calendar.set(Calendar.HOUR_OF_DAY, 0)
    calendar.set(Calendar.MINUTE, 0)
    calendar.set(Calendar.SECOND, 0)
    calendar.set(Calendar.MILLISECOND, 0)
    val startTime = calendar.timeInMillis

    // Set end time to today 23:59:59.999
    calendar.set(Calendar.HOUR_OF_DAY, 23)
    calendar.set(Calendar.MINUTE, 59)
    calendar.set(Calendar.SECOND, 59)
    calendar.set(Calendar.MILLISECOND, 999)
    val endTime = calendar.timeInMillis

    return Pair(startTime, endTime)
  }
}
