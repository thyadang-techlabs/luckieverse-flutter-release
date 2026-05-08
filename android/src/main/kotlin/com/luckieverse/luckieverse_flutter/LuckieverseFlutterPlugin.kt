package com.luckieverse.luckieverse_flutter

import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel

import com.techlabs.luckieverse.core.Luckieverse

class LuckieverseFlutterPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware, EventChannel.StreamHandler {
  private lateinit var channel: MethodChannel
  private var activityBinding: ActivityPluginBinding? = null
  private lateinit var eventChannel: EventChannel
  private var eventSink: EventChannel.EventSink? = null
  
  // 초기화 상태 추적
  private var isInitializeCalled = false
  private var initializeCallTime: Long = 0
  
  companion object {
    private const val TAG = "LuckieverseFlutter"
  }

  override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    Log.d(TAG, "========== onAttachedToEngine 호출됨 ==========")
    channel = MethodChannel(binding.binaryMessenger, "luckieverse_flutter")
    channel.setMethodCallHandler(this)
    eventChannel = EventChannel(binding.binaryMessenger, "luckieverse_flutter/events")
    eventChannel.setStreamHandler(this)
    Log.d(TAG, "MethodChannel 및 EventChannel 설정 완료")
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
    Log.d(TAG, "========== onMethodCall: ${call.method} ==========")
    Log.d(TAG, "현재 초기화 상태: isInitializeCalled=$isInitializeCalled")
    Log.d(TAG, "Activity 상태: activityBinding=${activityBinding != null}, activity=${activityBinding?.activity != null}")
    
    when (call.method) {
      "initialize" -> {
        Log.d(TAG, "[initialize] 시작")
        val activity = activityBinding?.activity
        if (activity == null) {
          Log.e(TAG, "[initialize] 실패: Activity가 null입니다!")
          Log.e(TAG, "[initialize] activityBinding: $activityBinding")
          return result.error("no_activity", "Activity is not attached", null)
        }
        Log.d(TAG, "[initialize] Activity 확인됨: ${activity.javaClass.simpleName}")
        Log.d(TAG, "[initialize] Activity hashCode: ${activity.hashCode()}")
        Log.d(TAG, "[initialize] Activity isFinishing: ${activity.isFinishing}")
        Log.d(TAG, "[initialize] Activity isDestroyed: ${activity.isDestroyed}")
        
        try {
          Log.d(TAG, "[initialize] Luckieverse.instance() 호출 전")
          val instance = Luckieverse.instance()
          Log.d(TAG, "[initialize] Luckieverse instance: $instance")
          Log.d(TAG, "[initialize] Luckieverse.initialize(activity) 호출 전")
          
          initializeCallTime = System.currentTimeMillis()
          instance.initialize(activity)
          isInitializeCalled = true
          
          Log.d(TAG, "[initialize] Luckieverse.initialize(activity) 호출 완료")
          Log.d(TAG, "[initialize] 초기화 호출 시간: $initializeCallTime")
          Log.d(TAG, "[initialize] 성공!")
          result.success(null)
        } catch (e: Exception) {
          Log.e(TAG, "[initialize] 예외 발생: ${e.message}")
          Log.e(TAG, "[initialize] 스택트레이스:", e)
          result.error("init_error", e.message, e.stackTraceToString())
        }
      }
      "updateUserId" -> {
        Log.d(TAG, "[updateUserId] 호출됨, isInitializeCalled=$isInitializeCalled")
        val userId = call.argument<String>("userId") ?: return result.error("bad_args", "Missing userId", null)
        Log.d(TAG, "[updateUserId] userId: $userId")
        Luckieverse.instance().updateUserId(userId)
        Log.d(TAG, "[updateUserId] 완료")
        result.success(null)
      }
      "updateAppKey" -> {
        Log.d(TAG, "[updateAppKey] 호출됨, isInitializeCalled=$isInitializeCalled")
        val appKey = call.argument<String>("appKey") ?: return result.error("bad_args", "Missing appKey", null)
        Log.d(TAG, "[updateAppKey] appKey: $appKey")
        Luckieverse.instance().updateAppKey(appKey)
        Log.d(TAG, "[updateAppKey] 완료")
        result.success(null)
      }
      "updateTarotAppKey" -> {
        Log.d(TAG, "[updateTarotAppKey] 호출됨, isInitializeCalled=$isInitializeCalled")
        val appKey = call.argument<String>("appKey") ?: return result.error("bad_args", "Missing appKey", null)
        Log.d(TAG, "[updateTarotAppKey] appKey: $appKey")
        Luckieverse.instance().updateTarotAppKey(appKey)
        Log.d(TAG, "[updateTarotAppKey] 완료")
        result.success(null)
      }
      "updateMainKey" -> {
        Log.d(TAG, "[updateMainKey] 호출됨, isInitializeCalled=$isInitializeCalled")
        val mainKey = call.argument<String>("mainKey") ?: return result.error("bad_args", "Missing mainKey", null)
        Log.d(TAG, "[updateMainKey] mainKey: $mainKey")
        Luckieverse.instance().updateMainKey(mainKey)
        Log.d(TAG, "[updateMainKey] 완료")
        result.success(null)
      }
      "updateIdfa" -> {
        Log.d(TAG, "[updateIdfa] 호출됨, isInitializeCalled=$isInitializeCalled")
        val idfa = call.argument<String>("idfa") ?: return result.error("bad_args", "Missing idfa", null)
        Log.d(TAG, "[updateIdfa] idfa: $idfa")
        Luckieverse.instance().updateADID(idfa)
        Log.d(TAG, "[updateIdfa] 완료")
        result.success(null)
      }
      "setFullScreenAdZoneIdForSaju" -> {
        Log.d(TAG, "[setFullScreenAdZoneIdForSaju] 호출됨, isInitializeCalled=$isInitializeCalled")
        val zoneId = call.argument<String>("zoneId") ?: return result.error("bad_args", "Missing zoneId", null)
        Log.d(TAG, "[setFullScreenAdZoneIdForSaju] zoneId: $zoneId")
        Luckieverse.instance().setFullScreenAdZoneIdForSaju(zoneId)
        Log.d(TAG, "[setFullScreenAdZoneIdForSaju] 완료")
        result.success(null)
      }
      "setFullScreenAdZoneIdForNotSaju" -> {
        Log.d(TAG, "[setFullScreenAdZoneIdForNotSaju] 호출됨, isInitializeCalled=$isInitializeCalled")
        val zoneId = call.argument<String>("zoneId") ?: return result.error("bad_args", "Missing zoneId", null)
        Log.d(TAG, "[setFullScreenAdZoneIdForNotSaju] zoneId: $zoneId")
        Luckieverse.instance().setFullScreenAdZoneIdForNotSaju(zoneId)
        Log.d(TAG, "[setFullScreenAdZoneIdForNotSaju] 완료")
        result.success(null)
      }
      "setFullScreenAdZoneIdForFortuneCookie" -> {
        Log.d(TAG, "[setFullScreenAdZoneIdForFortuneCookie] 호출됨, isInitializeCalled=$isInitializeCalled")
        val zoneId = call.argument<String>("zoneId") ?: return result.error("bad_args", "Missing zoneId", null)
        Log.d(TAG, "[setFullScreenAdZoneIdForFortuneCookie] zoneId: $zoneId")
        Luckieverse.instance().setFullScreenAdZoneIdForFortuneCookie(zoneId)
        Log.d(TAG, "[setFullScreenAdZoneIdForFortuneCookie] 완료")
        result.success(null)
      }
      "setBannerAdZoneIdForSaju" -> {
        Log.d(TAG, "[setBannerAdZoneIdForSaju] 호출됨, isInitializeCalled=$isInitializeCalled")
        val zoneId = call.argument<String>("zoneId") ?: return result.error("bad_args", "Missing zoneId", null)
        Log.d(TAG, "[setBannerAdZoneIdForSaju] zoneId: $zoneId")
        Luckieverse.instance().setBannerAdZoneIdForSaju(zoneId)
        Log.d(TAG, "[setBannerAdZoneIdForSaju] 완료")
        result.success(null)
      }
      "setBannerAdZoneIdForNotSaju" -> {
        Log.d(TAG, "[setBannerAdZoneIdForNotSaju] 호출됨, isInitializeCalled=$isInitializeCalled")
        val zoneId = call.argument<String>("zoneId") ?: return result.error("bad_args", "Missing zoneId", null)
        Log.d(TAG, "[setBannerAdZoneIdForNotSaju] zoneId: $zoneId")
        Luckieverse.instance().setBannerAdZoneIdForNotSaju(zoneId)
        Log.d(TAG, "[setBannerAdZoneIdForNotSaju] 완료")
        result.success(null)
      }
      "setBannerAdZoneIdForFortuneCookie" -> {
        Log.d(TAG, "[setBannerAdZoneIdForFortuneCookie] 호출됨, isInitializeCalled=$isInitializeCalled")
        val zoneId = call.argument<String>("zoneId") ?: return result.error("bad_args", "Missing zoneId", null)
        Log.d(TAG, "[setBannerAdZoneIdForFortuneCookie] zoneId: $zoneId")
        Luckieverse.instance().setBannerAdZoneIdForFortuneCookie(zoneId)
        Log.d(TAG, "[setBannerAdZoneIdForFortuneCookie] 완료")
        result.success(null)
      }
      "setGoToSettingCallback" -> {
        Log.d(TAG, "[setGoToSettingCallback] 호출됨, isInitializeCalled=$isInitializeCalled")
        Luckieverse.instance().setGoToSettingCallback {
          Log.d(TAG, "[setGoToSettingCallback] 콜백 실행됨!")
          eventSink?.success("goToSetting")
        }
        Log.d(TAG, "[setGoToSettingCallback] 완료")
        result.success(null)
      }
      "executeGoToSettingCallback" -> {
        Log.d(TAG, "[executeGoToSettingCallback] 호출됨, isInitializeCalled=$isInitializeCalled")
        Luckieverse.instance().executeGoToSettingCallback()
        Log.d(TAG, "[executeGoToSettingCallback] 완료")
        result.success(null)
      }
      "goToAppSetting" -> {
        Log.d(TAG, "[goToAppSetting] 호출됨, isInitializeCalled=$isInitializeCalled")
        // Android SDK에는 goToAppSetting이 없으므로 executeGoToSettingCallback을 호출
        // Luckieverse.instance().executeGoToSettingCallback()
        result.success(null)
      }
      "openLuckieverseMain" -> {
        Log.d(TAG, "[openLuckieverseMain] 호출됨")
        Log.d(TAG, "[openLuckieverseMain] isInitializeCalled=$isInitializeCalled")
        Log.d(TAG, "[openLuckieverseMain] 초기화 이후 경과 시간: ${System.currentTimeMillis() - initializeCallTime}ms")
        
        val activity = activityBinding?.activity
        if (activity == null) {
          Log.e(TAG, "[openLuckieverseMain] 실패: Activity가 null입니다!")
          return result.error("no_activity", "Activity is not attached", null)
        }
        Log.d(TAG, "[openLuckieverseMain] Activity: ${activity.javaClass.simpleName}, hashCode: ${activity.hashCode()}")
        
        try {
          Log.d(TAG, "[openLuckieverseMain] Luckieverse.instance().openLuckieverseMain() 호출 전")
          Luckieverse.instance().openLuckieverseMain(activity)
          Log.d(TAG, "[openLuckieverseMain] 성공!")
          result.success(null)
        } catch (e: Exception) {
          Log.e(TAG, "[openLuckieverseMain] 예외 발생: ${e.message}")
          Log.e(TAG, "[openLuckieverseMain] 스택트레이스:", e)
          result.error("open_error", e.message, e.stackTraceToString())
        }
      }
      "openLuckieverseTarot" -> {
        Log.d(TAG, "[openLuckieverseTarot] 호출됨")
        Log.d(TAG, "[openLuckieverseTarot] isInitializeCalled=$isInitializeCalled")
        Log.d(TAG, "[openLuckieverseTarot] 초기화 이후 경과 시간: ${System.currentTimeMillis() - initializeCallTime}ms")
        
        val activity = activityBinding?.activity
        if (activity == null) {
          Log.e(TAG, "[openLuckieverseTarot] 실패: Activity가 null입니다!")
          return result.error("no_activity", "Activity is not attached", null)
        }
        Log.d(TAG, "[openLuckieverseTarot] Activity: ${activity.javaClass.simpleName}, hashCode: ${activity.hashCode()}")
        
        try {
          Log.d(TAG, "[openLuckieverseTarot] Luckieverse.instance().openLuckieverseTarot() 호출 전")
          Luckieverse.instance().openLuckieverseTarot(activity)
          Log.d(TAG, "[openLuckieverseTarot] 성공!")
          result.success(null)
        } catch (e: Exception) {
          Log.e(TAG, "[openLuckieverseTarot] 예외 발생: ${e.message}")
          Log.e(TAG, "[openLuckieverseTarot] 스택트레이스:", e)
          result.error("open_error", e.message, e.stackTraceToString())
        }
      }
      "openLuckieverseByPush" -> {
        Log.d(TAG, "[openLuckieverseByPush] 호출됨")
        Log.d(TAG, "[openLuckieverseByPush] isInitializeCalled=$isInitializeCalled")
        
        val activity = activityBinding?.activity
        if (activity == null) {
          Log.e(TAG, "[openLuckieverseByPush] 실패: Activity가 null입니다!")
          return result.error("no_activity", "Activity is not attached", null)
        }
        val pushKey = call.argument<String>("pushKey") ?: return result.error("bad_args", "Missing pushKey", null)
        Log.d(TAG, "[openLuckieverseByPush] pushKey: $pushKey")
        
        try {
          Luckieverse.instance().openLuckieverseByPush(activity, pushKey)
          Log.d(TAG, "[openLuckieverseByPush] 성공!")
          result.success(null)
        } catch (e: Exception) {
          Log.e(TAG, "[openLuckieverseByPush] 예외 발생: ${e.message}")
          Log.e(TAG, "[openLuckieverseByPush] 스택트레이스:", e)
          result.error("open_error", e.message, e.stackTraceToString())
        }
      }
      "openLuckieverseTarotByPush" -> {
        Log.d(TAG, "[openLuckieverseTarotByPush] 호출됨")
        Log.d(TAG, "[openLuckieverseTarotByPush] isInitializeCalled=$isInitializeCalled")
        
        val activity = activityBinding?.activity
        if (activity == null) {
          Log.e(TAG, "[openLuckieverseTarotByPush] 실패: Activity가 null입니다!")
          return result.error("no_activity", "Activity is not attached", null)
        }
        val pushKey = call.argument<String>("pushKey") ?: return result.error("bad_args", "Missing pushKey", null)
        Log.d(TAG, "[openLuckieverseTarotByPush] pushKey: $pushKey")
        
        try {
          Luckieverse.instance().openLuckieverseTarotByPush(activity, pushKey)
          Log.d(TAG, "[openLuckieverseTarotByPush] 성공!")
          result.success(null)
        } catch (e: Exception) {
          Log.e(TAG, "[openLuckieverseTarotByPush] 예외 발생: ${e.message}")
          Log.e(TAG, "[openLuckieverseTarotByPush] 스택트레이스:", e)
          result.error("open_error", e.message, e.stackTraceToString())
        }
      }
      "openNewYearFortune" -> {
        Log.d(TAG, "[openNewYearFortune] 호출됨")
        Log.d(TAG, "[openNewYearFortune] isInitializeCalled=$isInitializeCalled")

        val activity = activityBinding?.activity
        if (activity == null) {
          Log.e(TAG, "[openNewYearFortune] 실패: Activity가 null입니다!")
          return result.error("no_activity", "Activity is not attached", null)
        }

        try {
          Luckieverse.instance().openNewYearFortune(activity)
          Log.d(TAG, "[openNewYearFortune] 성공!")
          result.success(null)
        } catch (e: Exception) {
          Log.e(TAG, "[openNewYearFortune] 예외 발생: ${e.message}")
          Log.e(TAG, "[openNewYearFortune] 스택트레이스:", e)
          result.error("open_error", e.message, e.stackTraceToString())
        }
      }
      "showRVWithDynamicZoneID" -> {
        Log.d(TAG, "[showRVWithDynamicZoneID] 호출됨, isInitializeCalled=$isInitializeCalled")
        val zoneID = call.argument<String>("zoneID")
          ?: return result.error("bad_args", "Missing zoneID", null)
        val activity = activityBinding?.activity
          ?: return result.error("no_activity", "Activity is not attached", null)
        Log.d(TAG, "[showRVWithDynamicZoneID] zoneID: $zoneID")
        try {
          Luckieverse.instance().showRVWithDynamicZoneID(activity, zoneID)
          Log.d(TAG, "[showRVWithDynamicZoneID] 성공!")
          result.success(null)
        } catch (e: Exception) {
          Log.e(TAG, "[showRVWithDynamicZoneID] 예외 발생: ${e.message}")
          Log.e(TAG, "[showRVWithDynamicZoneID] 스택트레이스:", e)
          result.error("ad_error", e.message, e.stackTraceToString())
        }
      }
      else -> {
        Log.w(TAG, "알 수 없는 메서드: ${call.method}")
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    Log.d(TAG, "========== onDetachedFromEngine 호출됨 ==========")
    channel.setMethodCallHandler(null)
    eventChannel.setStreamHandler(null)
  }

  // ActivityAware implementations
  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    Log.d(TAG, "========== onAttachedToActivity ==========")
    Log.d(TAG, "Activity: ${binding.activity.javaClass.simpleName}")
    Log.d(TAG, "Activity hashCode: ${binding.activity.hashCode()}")
    activityBinding = binding
  }

  override fun onDetachedFromActivityForConfigChanges() {
    Log.d(TAG, "========== onDetachedFromActivityForConfigChanges ==========")
    Log.w(TAG, "Activity가 config 변경으로 분리됨! (예: 화면 회전)")
    activityBinding = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    Log.d(TAG, "========== onReattachedToActivityForConfigChanges ==========")
    Log.d(TAG, "Activity 재연결: ${binding.activity.javaClass.simpleName}")
    Log.d(TAG, "Activity hashCode: ${binding.activity.hashCode()}")
    activityBinding = binding
  }

  override fun onDetachedFromActivity() {
    Log.d(TAG, "========== onDetachedFromActivity ==========")
    Log.w(TAG, "Activity가 완전히 분리됨!")
    activityBinding = null
  }

  // EventChannel.StreamHandler
  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    Log.d(TAG, "EventChannel onListen: arguments=$arguments")
    eventSink = events
  }
  override fun onCancel(arguments: Any?) {
    Log.d(TAG, "EventChannel onCancel: arguments=$arguments")
    eventSink = null
  }
}
