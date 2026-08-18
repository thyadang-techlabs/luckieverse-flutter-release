import Flutter
import UIKit
import os.log
import UserNotifications
#if canImport(Luckieverse)
import Luckieverse
#endif

public class SwiftLuckieverseFlutterPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
  
  // 로깅을 위한 OSLog
  private static let log = OSLog(subsystem: "com.luckieverse.flutter", category: "LuckieverseFlutter")
  
  // 초기화 상태 추적
  private var isInitializeCalled = false
  private var initializeCallTime: Date?
  
  public static func register(with registrar: FlutterPluginRegistrar) {
    os_log("========== register 호출됨 ==========", log: log, type: .debug)
    let channel = FlutterMethodChannel(name: "luckieverse_flutter", binaryMessenger: registrar.messenger())
    let events = FlutterEventChannel(name: "luckieverse_flutter/events", binaryMessenger: registrar.messenger())
    let instance = SwiftLuckieverseFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    events.setStreamHandler(instance)
    os_log("MethodChannel 및 EventChannel 설정 완료", log: log, type: .debug)
  }
  
  private func log(_ message: String, type: OSLogType = .debug) {
    os_log("%{public}@", log: SwiftLuckieverseFlutterPlugin.log, type: type, message)
    print("[LuckieverseFlutter] \(message)")
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    log("========== handle: \(call.method) ==========")
    log("현재 초기화 상태: isInitializeCalled=\(isInitializeCalled)")
    
    switch call.method {
    case "initialize":
      log("[initialize] 시작")
      
      if isInitializeCalled {
        log("[WARNING] initialize()가 이미 호출되었습니다!")
        if let time = initializeCallTime {
          log("이전 호출 시간: \(time)")
        }
      }
      
      isInitializeCalled = true
      initializeCallTime = Date()
      log("[initialize] 호출 시간: \(initializeCallTime!)")
      
      #if canImport(Luckieverse)
      log("[initialize] LuckieverseSDK.shared.initialize() 호출 전")
      LuckieverseSDK.shared.initialize()
      log("[initialize] LuckieverseSDK.shared.initialize() 호출 완료!")
      result(nil)
      #else
      log("[ERROR] Luckieverse.xcframework가 통합되지 않음")
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "updateUserId":
      log("[updateUserId] 호출됨, isInitializeCalled=\(isInitializeCalled)")
      guard let args = call.arguments as? [String: Any], let userId = args["userId"] as? String else {
        log("[ERROR] updateUserId: Missing userId")
        result(FlutterError(code: "bad_args", message: "Missing userId", details: nil)); return
      }
      log("[updateUserId] userId: \(userId)")
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.updateUSER_ID(userId: userId)
      log("[updateUserId] 완료")
      result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "updateAppKey":
      log("[updateAppKey] 호출됨, isInitializeCalled=\(isInitializeCalled)")
      guard let args = call.arguments as? [String: Any], let appKey = args["appKey"] as? String else {
        log("[ERROR] updateAppKey: Missing appKey")
        result(FlutterError(code: "bad_args", message: "Missing appKey", details: nil)); return
      }
      log("[updateAppKey] appKey: \(appKey)")
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.updateAPP_KEY(APP_KEY: appKey)
      log("[updateAppKey] 완료")
      result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "updateTarotAppKey":
      log("[updateTarotAppKey] 호출됨, isInitializeCalled=\(isInitializeCalled)")
      guard let args = call.arguments as? [String: Any], let appKey = args["appKey"] as? String else {
        log("[ERROR] updateTarotAppKey: Missing appKey")
        result(FlutterError(code: "bad_args", message: "Missing appKey", details: nil)); return
      }
      log("[updateTarotAppKey] appKey: \(appKey)")
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.update_TAROT_APP_KEY(APP_KEY: appKey)
      log("[updateTarotAppKey] 완료")
      result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "updateMainKey":
      log("[updateMainKey] 호출됨, isInitializeCalled=\(isInitializeCalled)")
      guard let args = call.arguments as? [String: Any], let mainKey = args["mainKey"] as? String else {
        log("[ERROR] updateMainKey: Missing mainKey")
        result(FlutterError(code: "bad_args", message: "Missing mainKey", details: nil)); return
      }
      log("[updateMainKey] mainKey: \(mainKey)")
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.updateMAIN_KEY(MAIN_KEY: mainKey)
      log("[updateMainKey] 완료")
      result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "updateIdfa":
      log("[updateIdfa] 호출됨, isInitializeCalled=\(isInitializeCalled)")
      guard let args = call.arguments as? [String: Any], let idfa = args["idfa"] as? String else {
        log("[ERROR] updateIdfa: Missing idfa")
        result(FlutterError(code: "bad_args", message: "Missing idfa", details: nil)); return
      }
      log("[updateIdfa] idfa: \(idfa)")
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.updateIDFA(IDFA: idfa)
      log("[updateIdfa] 완료")
      result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "setGoToSettingCallback":
      log("[setGoToSettingCallback] 호출됨, isInitializeCalled=\(isInitializeCalled)")
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.setGoToSettingSwift({ [weak self] in
        self?.log("[setGoToSettingCallback] 콜백 실행됨!")
        self?.eventSink?("goToSetting")
      })
      log("[setGoToSettingCallback] 완료")
      result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "executeGoToSettingCallback":
      log("[executeGoToSettingCallback] 호출됨, isInitializeCalled=\(isInitializeCalled)")
      #if canImport(Luckieverse)
      // executeGoToSettingCallback은 Android 전용이므로 iOS에서는 구현하지 않음
      log("[executeGoToSettingCallback] iOS에서는 미구현")
      result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "goToAppSetting":
      log("[goToAppSetting] 호출됨, isInitializeCalled=\(isInitializeCalled)")
      result(nil)

    case "openLuckieverseMain":
      log("========== openLuckieverseMain 호출됨 ==========")
      log("[openLuckieverseMain] isInitializeCalled=\(isInitializeCalled)")
      if let time = initializeCallTime {
        let elapsed = Date().timeIntervalSince(time) * 1000
        log("[openLuckieverseMain] 초기화 이후 경과 시간: \(elapsed)ms")
      } else {
        log("[WARNING] openLuckieverseMain: initialize가 호출되지 않았습니다!")
      }
      
      #if canImport(Luckieverse)
      log("[openLuckieverseMain] LuckieverseSDK.shared.openLuckieverseMain() 호출 전")
      LuckieverseSDK.shared.openLuckieverseMain()
      log("[openLuckieverseMain] 성공!")
      result(nil)
      #else
      log("[ERROR] openLuckieverseMain: Luckieverse.xcframework가 통합되지 않음")
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "openLuckieverseTarot":
      log("========== openLuckieverseTarot 호출됨 ==========")
      log("[openLuckieverseTarot] isInitializeCalled=\(isInitializeCalled)")
      if let time = initializeCallTime {
        let elapsed = Date().timeIntervalSince(time) * 1000
        log("[openLuckieverseTarot] 초기화 이후 경과 시간: \(elapsed)ms")
      } else {
        log("[WARNING] openLuckieverseTarot: initialize가 호출되지 않았습니다!")
      }
      
      #if canImport(Luckieverse)
      log("[openLuckieverseTarot] LuckieverseSDK.shared.openLuckieverseTarot() 호출 전")
      LuckieverseSDK.shared.openLuckieverseTarot()
      log("[openLuckieverseTarot] 성공!")
      result(nil)
      #else
      log("[ERROR] openLuckieverseTarot: Luckieverse.xcframework가 통합되지 않음")
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "openLuckieverseByPush":
      log("[openLuckieverseByPush] 호출됨, isInitializeCalled=\(isInitializeCalled)")
      guard let args = call.arguments as? [String: Any], let pushKey = args["pushKey"] as? String else {
        log("[ERROR] openLuckieverseByPush: Missing pushKey")
        result(FlutterError(code: "bad_args", message: "Missing pushKey", details: nil)); return
      }
      log("[openLuckieverseByPush] pushKey: \(pushKey)")
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.openLuckieverseByPush(pushKey: pushKey)
      log("[openLuckieverseByPush] 성공!")
      result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "openLuckieverseTarotByPush":
      log("[openLuckieverseTarotByPush] 호출됨, isInitializeCalled=\(isInitializeCalled)")
      guard let args = call.arguments as? [String: Any], let pushKey = args["pushKey"] as? String else {
        log("[ERROR] openLuckieverseTarotByPush: Missing pushKey")
        result(FlutterError(code: "bad_args", message: "Missing pushKey", details: nil)); return
      }
      log("[openLuckieverseTarotByPush] pushKey: \(pushKey)")
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.openLuckieverseTarotByPush(pushKey: pushKey)
      log("[openLuckieverseTarotByPush] 성공!")
      result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "openNewYearFortune":
      log("[openNewYearFortune] 호출됨, isInitializeCalled=\(isInitializeCalled)")
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.openNewYearFortune()
      log("[openNewYearFortune] 성공!")
      result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "setAdLoadTimeout":
      log("[setAdLoadTimeout] 호출됨, isInitializeCalled=\(isInitializeCalled)")
      guard let args = call.arguments as? [String: Any], let timeoutSeconds = (args["timeoutSeconds"] as? NSNumber)?.doubleValue else {
        log("[ERROR] setAdLoadTimeout: Missing timeoutSeconds")
        result(FlutterError(code: "bad_args", message: "Missing timeoutSeconds", details: nil)); return
      }
      guard timeoutSeconds > 0 else {
        log("[ERROR] setAdLoadTimeout: timeoutSeconds must be positive")
        result(FlutterError(code: "bad_args", message: "timeoutSeconds must be positive", details: nil)); return
      }
      log("[setAdLoadTimeout] timeoutSeconds: \(timeoutSeconds)")
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.setFullscreenAdLoadTimeout(timeoutSeconds)
      log("[setAdLoadTimeout] 완료")
      result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "setAdShowTimeout":
      log("[setAdShowTimeout] 호출됨, isInitializeCalled=\(isInitializeCalled)")
      guard let args = call.arguments as? [String: Any], let timeoutSeconds = (args["timeoutSeconds"] as? NSNumber)?.doubleValue else {
        log("[ERROR] setAdShowTimeout: Missing timeoutSeconds")
        result(FlutterError(code: "bad_args", message: "Missing timeoutSeconds", details: nil)); return
      }
      guard timeoutSeconds > 0 else {
        log("[ERROR] setAdShowTimeout: timeoutSeconds must be positive")
        result(FlutterError(code: "bad_args", message: "timeoutSeconds must be positive", details: nil)); return
      }
      log("[setAdShowTimeout] timeoutSeconds: \(timeoutSeconds)")
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.setFullscreenAdShowTimeout(timeoutSeconds)
      log("[setAdShowTimeout] 완료")
      result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "showRVWithDynamicZoneID":
      log("[showRVWithDynamicZoneID] 호출됨, isInitializeCalled=\(isInitializeCalled)")
      guard let args = call.arguments as? [String: Any], let zoneID = args["zoneID"] as? String else {
        log("[ERROR] showRVWithDynamicZoneID: Missing zoneID")
        result(FlutterError(code: "bad_args", message: "Missing zoneID", details: nil)); return
      }
      let callId = args["callId"] as? String
      // Dart 호출자가 onAdShowFail을 실제로 등록했을 때만 native onAdShowFail을 등록한다.
      // Android AdManager.kt와 동일하게, 네이티브 onAdShowFail 파라미터는 optional(default nil)로
      // 설계되어 있어 무조건 등록하면 구버전 호출부(onLoadFail만 등록)의 폴백 동작이 깨질 수 있다.
      let hasOnAdShowFail = (args["hasOnAdShowFail"] as? Bool) ?? false
      log("[showRVWithDynamicZoneID] zoneID: \(zoneID), callId: \(callId ?? "nil"), hasOnAdShowFail: \(hasOnAdShowFail)")
      #if canImport(Luckieverse)
      if let callId = callId {
        // 오버로드 + optional @convention(block) 클로저 추론 모호성을 피하기 위해
        // 각 콜백을 명시적 타입의 지역 상수로 분리해서 전달한다.
        let onLoadFail: (LuckieverseAdError) -> Void = { [weak self] adError in
          self?.log("[showRVWithDynamicZoneID] onLoadFail 콜백 실행됨, callId=\(callId)")
          let payload: [String: Any] = ["channel": "rvCallback", "callId": callId, "event": "onLoadFail",
                                        "data": ["code": adError.code, "message": adError.message as Any]]
          DispatchQueue.main.async { self?.eventSink?(payload) }
        }
        let onAdComplete: (LuckieverseAdInfo) -> Void = { [weak self] adInfo in
          self?.log("[showRVWithDynamicZoneID] onAdComplete 콜백 실행됨, callId=\(callId)")
          let payload: [String: Any] = ["channel": "rvCallback", "callId": callId, "event": "onAdComplete",
                                        "data": ["zoneId": adInfo.zoneId, "network": adInfo.network as Any, "adType": adInfo.adType as Any]]
          DispatchQueue.main.async { self?.eventSink?(payload) }
        }
        let onAdNoFill: () -> Void = { [weak self] in
          self?.log("[showRVWithDynamicZoneID] onAdNoFill 콜백 실행됨, callId=\(callId)")
          let payload: [String: Any] = ["channel": "rvCallback", "callId": callId, "event": "onAdNoFill"]
          DispatchQueue.main.async { self?.eventSink?(payload) }
        }
        let onAdBlockUser: () -> Void = { [weak self] in
          self?.log("[showRVWithDynamicZoneID] onAdBlockUser 콜백 실행됨, callId=\(callId)")
          let payload: [String: Any] = ["channel": "rvCallback", "callId": callId, "event": "onAdBlockUser"]
          DispatchQueue.main.async { self?.eventSink?(payload) }
        }
        let onAdLoad: () -> Void = { [weak self] in
          self?.log("[showRVWithDynamicZoneID] onAdLoad 콜백 실행됨, callId=\(callId)")
          let payload: [String: Any] = ["channel": "rvCallback", "callId": callId, "event": "onAdLoad"]
          DispatchQueue.main.async { self?.eventSink?(payload) }
        }
        let onAdShow: (LuckieverseAdInfo) -> Void = { [weak self] adInfo in
          self?.log("[showRVWithDynamicZoneID] onAdShow 콜백 실행됨, callId=\(callId)")
          let payload: [String: Any] = ["channel": "rvCallback", "callId": callId, "event": "onAdShow",
                                        "data": ["zoneId": adInfo.zoneId, "network": adInfo.network as Any, "adType": adInfo.adType as Any]]
          DispatchQueue.main.async { self?.eventSink?(payload) }
        }
        let onAdSkip: () -> Void = { [weak self] in
          self?.log("[showRVWithDynamicZoneID] onAdSkip 콜백 실행됨, callId=\(callId)")
          let payload: [String: Any] = ["channel": "rvCallback", "callId": callId, "event": "onAdSkip"]
          DispatchQueue.main.async { self?.eventSink?(payload) }
        }
        let onAdClose: (LuckieverseAdInfo) -> Void = { [weak self] adInfo in
          self?.log("[showRVWithDynamicZoneID] onAdClose 콜백 실행됨, callId=\(callId)")
          let payload: [String: Any] = ["channel": "rvCallback", "callId": callId, "event": "onAdClose",
                                        "data": ["zoneId": adInfo.zoneId, "network": adInfo.network as Any, "adType": adInfo.adType as Any]]
          DispatchQueue.main.async { self?.eventSink?(payload) }
        }
        let onAdClick: (LuckieverseAdInfo) -> Void = { [weak self] adInfo in
          self?.log("[showRVWithDynamicZoneID] onAdClick 콜백 실행됨, callId=\(callId)")
          let payload: [String: Any] = ["channel": "rvCallback", "callId": callId, "event": "onAdClick",
                                        "data": ["zoneId": adInfo.zoneId, "network": adInfo.network as Any, "adType": adInfo.adType as Any]]
          DispatchQueue.main.async { self?.eventSink?(payload) }
        }
        let onAdShowFail: ((LuckieverseAdError) -> Void)? = hasOnAdShowFail ? { [weak self] adError in
          self?.log("[showRVWithDynamicZoneID] onAdShowFail 콜백 실행됨, callId=\(callId)")
          let payload: [String: Any] = ["channel": "rvCallback", "callId": callId, "event": "onAdShowFail",
                                        "data": ["code": adError.code, "message": adError.message as Any]]
          DispatchQueue.main.async { self?.eventSink?(payload) }
        } : nil
        LuckieverseSDK.shared.showRVWithDynamicZoneID(
          zoneID,
          onLoadFail: onLoadFail,
          onAdComplete: onAdComplete,
          onAdNoFill: onAdNoFill,
          onAdBlockUser: onAdBlockUser,
          onAdLoad: onAdLoad,
          onAdShow: onAdShow,
          onAdSkip: onAdSkip,
          onAdClose: onAdClose,
          onAdClick: onAdClick,
          onAdShowFail: onAdShowFail
        )
      } else {
        LuckieverseSDK.shared.showRVWithDynamicZoneID(zoneID)
      }
      log("[showRVWithDynamicZoneID] 성공!")
      result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "getSdkVersion":
      #if canImport(Luckieverse)
      result(LuckieverseSDK.shared.getSDKVersion())
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "setSdkVersion":
      guard let args = call.arguments as? [String: Any], let version = args["version"] as? String else {
        result(FlutterError(code: "bad_args", message: "Missing version", details: nil)); return
      }
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.setSDKVersion(version: version)
      result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "updateGameAppKey":
      guard let args = call.arguments as? [String: Any], let appKey = args["appKey"] as? String else {
        result(FlutterError(code: "bad_args", message: "Missing appKey", details: nil)); return
      }
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.update_GAME_APP_KEY(APP_KEY: appKey)
      result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "enableBannerDebug":
      guard let args = call.arguments as? [String: Any], let enable = args["enable"] as? Bool else {
        result(FlutterError(code: "bad_args", message: "Missing enable", details: nil)); return
      }
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.enableBannerDebug(enable)
      result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "enableFullScreenAdFailForTest":
      guard let args = call.arguments as? [String: Any], let enable = args["enable"] as? Bool else {
        result(FlutterError(code: "bad_args", message: "Missing enable", details: nil)); return
      }
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.enableFullScreenAdFailForTest(enable)
      result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "setConsumableFullscreenZoneIds":
      guard let args = call.arguments as? [String: Any], let zoneIds = args["zoneIds"] as? [String] else {
        result(FlutterError(code: "bad_args", message: "Missing zoneIds", details: nil)); return
      }
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.setConsumableFullscreenZoneIds(zoneIds)
      result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "setConsumableBannerZoneIds":
      guard let args = call.arguments as? [String: Any], let zoneIds = args["zoneIds"] as? [String] else {
        result(FlutterError(code: "bad_args", message: "Missing zoneIds", details: nil)); return
      }
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.setConsumableBannerZoneIds(zoneIds)
      result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "updateBannerHeightLimit":
      guard let args = call.arguments as? [String: Any], let height = (args["height"] as? NSNumber)?.doubleValue else {
        result(FlutterError(code: "bad_args", message: "Missing height", details: nil)); return
      }
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.updateBannerHeightLimit(CGFloat(height))
      result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "updateWebviewInspector":
      guard let args = call.arguments as? [String: Any], let enabled = args["enabled"] as? Bool else {
        result(FlutterError(code: "bad_args", message: "Missing enabled", details: nil)); return
      }
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.updateWebviewInspector(enabled)
      result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "showFloatingButton":
      #if canImport(Luckieverse)
      // UIApplication.getCurrentViewController(base:)는 네이티브 SDK의
      // .swiftinterface상 @MainActor로 격리되어 있다. 이 handle(_:result:)는
      // non-isolated이지만 Flutter 채널 핸들러가 항상 메인 스레드에서 호출되므로
      // 실제로는 이미 MainActor 컨텍스트에서 실행 중임을 MainActor.assumeIsolated로
      // 명시한다 — 이 가정이 깨지면(예: 커스텀 TaskQueue 도입 등) 조용히 넘어가지
      // 않고 런타임에 즉시 크래시하도록 해 문제를 조기에 드러낸다.
      MainActor.assumeIsolated {
        if let viewController = UIApplication.shared.getCurrentViewController() {
          FloatingButtonManager.shared.showFloatingButton(on: viewController)
          result(nil)
        } else {
          log("[ERROR] showFloatingButton: 현재 UIViewController를 찾을 수 없음")
          result(FlutterError(code: "no_view_controller", message: "Could not resolve current UIViewController", details: nil))
        }
      }
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "hideFloatingButton":
      #if canImport(Luckieverse)
      FloatingButtonManager.shared.hideFloatingButton()
      result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "setLuckieverseLocalPush":
      guard let args = call.arguments as? [String: Any],
            let title = args["title"] as? String,
            let body = args["body"] as? String,
            let typeRaw = args["type"] as? Int else {
        result(FlutterError(code: "bad_args", message: "Missing title/body/type", details: nil)); return
      }
      #if canImport(Luckieverse)
      guard let type = LuckieverseLocalPushType(rawValue: typeRaw) else {
        result(FlutterError(code: "bad_args", message: "Invalid type: \(typeRaw)", details: nil)); return
      }
      let repeats = args["repeats"] as? Bool ?? false
      let intervalInSeconds = args["intervalInSeconds"] as? Int ?? 5
      let soundName = args["soundName"] as? String
      let sound: UNNotificationSound
      if let soundName = soundName, !soundName.isEmpty {
        sound = UNNotificationSound(named: UNNotificationSoundName(soundName))
      } else {
        sound = .default
      }
      let push = LuckieverseLocalPush(
        title: title, body: body, type: type, repeats: repeats,
        sound: sound, interverInSeconds: intervalInSeconds
      )
      LuckieverseSDK.shared.setLuckieverseLocalPush(push: push)
      result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "cancelLuckieverseLocalPush":
      guard let args = call.arguments as? [String: Any], let typeRaw = args["pushType"] as? Int else {
        result(FlutterError(code: "bad_args", message: "Missing pushType", details: nil)); return
      }
      #if canImport(Luckieverse)
      guard let type = LuckieverseLocalPushType(rawValue: typeRaw) else {
        result(FlutterError(code: "bad_args", message: "Invalid pushType: \(typeRaw)", details: nil)); return
      }
      LuckieverseSDK.shared.cancelLuckieverseLocalPush(pushType: type)
      result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "openLuckieverseMyPage":
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.openLuckieverseMyPage(); result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "openLuckieverseSajuInfo":
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.openLuckieverseSajuInfo(); result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "openLuckieversePhoneAuth":
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.openLuckieversePhoneAuth(); result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "openLuckieversePointHistory":
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.openLuckieversePointHistory(); result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "openLuckieverseProductHistory":
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.openLuckieverseProductHistory(); result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "openLuckieverseProductHistoryDetail":
      guard let args = call.arguments as? [String: Any], let id = args["id"] as? String else {
        result(FlutterError(code: "bad_args", message: "Missing id", details: nil)); return
      }
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.openLuckieverseProductHistoryDetail(id: id); result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "openLuckieverseFaq":
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.openLuckieverseFaq(); result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "openLuckieverseFaqDetail":
      // iOS 네이티브(openLuckieverseFaqDetail(id:))는 id가 필수 파라미터다.
      guard let args = call.arguments as? [String: Any], let id = args["id"] as? String else {
        result(FlutterError(code: "bad_args", message: "Missing id (iOS에서는 id가 필수입니다)", details: nil)); return
      }
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.openLuckieverseFaqDetail(id: id); result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "openLuckieverseInquiry":
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.openLuckieverseInquiry(); result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "openLuckieverseInquiryHistory":
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.openLuckieverseInquiryHistory(); result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "openLuckieverseInquiryHistoryDetail":
      guard let args = call.arguments as? [String: Any], let id = args["id"] as? String else {
        result(FlutterError(code: "bad_args", message: "Missing id", details: nil)); return
      }
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.openLuckieverseInquiryHistoryDetail(id: id); result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "openLuckieverseTermsAndPolicies":
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.openLuckieverseTermsAndPolicies(); result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "openLuckieverseTermsAndPoliciesDetail":
      // iOS 네이티브(openLuckieverseTermsAndPoliciesDetail(id:))는 id가 필수 파라미터다.
      guard let args = call.arguments as? [String: Any], let id = args["id"] as? String else {
        result(FlutterError(code: "bad_args", message: "Missing id (iOS에서는 id가 필수입니다)", details: nil)); return
      }
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.openLuckieverseTermsAndPoliciesDetail(id: id); result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "openLuckieverseProductStore":
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.openLuckieverseProductStore(); result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "openLuckieverseProductStoreDetail":
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.openLuckieverseProductStoreDetail(); result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "openLuckieverseError":
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.openLuckieverseError(); result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "openFaceReading":
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.openFaceReading(); result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "checkGoogleAdmobWebviewAPI":
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.checkGoogleAdmobWebviewAPI(); result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "openEmail":
      let toAddress = (call.arguments as? [String: Any])?["toAddress"] as? String
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.openEmailApp(recipient: toAddress); result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "openLuckieverseGame":
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.openLuckieverseGame(); result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    case "openLuckieverseGameByPush":
      guard let args = call.arguments as? [String: Any], let pushKey = args["pushKey"] as? String else {
        result(FlutterError(code: "bad_args", message: "Missing pushKey", details: nil)); return
      }
      #if canImport(Luckieverse)
      LuckieverseSDK.shared.openLuckieverseGameByPush(pushKey: pushKey); result(nil)
      #else
      result(FlutterError(code: "unavailable", message: "Luckieverse.xcframework not integrated", details: nil))
      #endif

    default:
      log("[WARNING] 알 수 없는 메서드: \(call.method)")
      result(FlutterMethodNotImplemented)
    }
  }

  // MARK: - FlutterStreamHandler
  private var eventSink: FlutterEventSink?
  
  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    log("EventChannel onListen: arguments=\(String(describing: arguments))")
    self.eventSink = events
    return nil
  }
  
  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    log("EventChannel onCancel: arguments=\(String(describing: arguments))")
    self.eventSink = nil
    return nil
  }
}
