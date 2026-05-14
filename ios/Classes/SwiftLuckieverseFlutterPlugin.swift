import Flutter
import UIKit
import os.log
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

    case "showRVWithDynamicZoneID":
      log("[showRVWithDynamicZoneID] 호출됨, isInitializeCalled=\(isInitializeCalled)")
      guard let args = call.arguments as? [String: Any], let zoneID = args["zoneID"] as? String else {
        log("[ERROR] showRVWithDynamicZoneID: Missing zoneID")
        result(FlutterError(code: "bad_args", message: "Missing zoneID", details: nil)); return
      }
      let callId = args["callId"] as? String
      log("[showRVWithDynamicZoneID] zoneID: \(zoneID), callId: \(callId ?? "nil")")
      #if canImport(Luckieverse)
      if let callId = callId {
        LuckieverseSDK.shared.showRVWithDynamicZoneID(
          zoneID,
          onLoadFail: { [weak self] adError in
            self?.log("[showRVWithDynamicZoneID] onLoadFail 콜백 실행됨, callId=\(callId)")
            let payload: [String: Any] = ["channel": "rvCallback", "callId": callId, "event": "onLoadFail",
                                          "data": ["code": adError.code, "message": adError.message as Any]]
            DispatchQueue.main.async { self?.eventSink?(payload) }
          },
          onAdComplete: { [weak self] adInfo in
            self?.log("[showRVWithDynamicZoneID] onAdComplete 콜백 실행됨, callId=\(callId)")
            let payload: [String: Any] = ["channel": "rvCallback", "callId": callId, "event": "onAdComplete",
                                          "data": ["zoneId": adInfo.zoneId, "network": adInfo.network as Any, "adType": adInfo.adType as Any]]
            DispatchQueue.main.async { self?.eventSink?(payload) }
          },
          onAdNoFill: { [weak self] in
            self?.log("[showRVWithDynamicZoneID] onAdNoFill 콜백 실행됨, callId=\(callId)")
            let payload: [String: Any] = ["channel": "rvCallback", "callId": callId, "event": "onAdNoFill"]
            DispatchQueue.main.async { self?.eventSink?(payload) }
          },
          onAdBlockUser: { [weak self] in
            self?.log("[showRVWithDynamicZoneID] onAdBlockUser 콜백 실행됨, callId=\(callId)")
            let payload: [String: Any] = ["channel": "rvCallback", "callId": callId, "event": "onAdBlockUser"]
            DispatchQueue.main.async { self?.eventSink?(payload) }
          },
          onAdLoad: { [weak self] in
            self?.log("[showRVWithDynamicZoneID] onAdLoad 콜백 실행됨, callId=\(callId)")
            let payload: [String: Any] = ["channel": "rvCallback", "callId": callId, "event": "onAdLoad"]
            DispatchQueue.main.async { self?.eventSink?(payload) }
          },
          onAdShow: { [weak self] adInfo in
            self?.log("[showRVWithDynamicZoneID] onAdShow 콜백 실행됨, callId=\(callId)")
            let payload: [String: Any] = ["channel": "rvCallback", "callId": callId, "event": "onAdShow",
                                          "data": ["zoneId": adInfo.zoneId, "network": adInfo.network as Any, "adType": adInfo.adType as Any]]
            DispatchQueue.main.async { self?.eventSink?(payload) }
          },
          onAdSkip: { [weak self] in
            self?.log("[showRVWithDynamicZoneID] onAdSkip 콜백 실행됨, callId=\(callId)")
            let payload: [String: Any] = ["channel": "rvCallback", "callId": callId, "event": "onAdSkip"]
            DispatchQueue.main.async { self?.eventSink?(payload) }
          },
          onAdClose: { [weak self] adInfo in
            self?.log("[showRVWithDynamicZoneID] onAdClose 콜백 실행됨, callId=\(callId)")
            let payload: [String: Any] = ["channel": "rvCallback", "callId": callId, "event": "onAdClose",
                                          "data": ["zoneId": adInfo.zoneId, "network": adInfo.network as Any, "adType": adInfo.adType as Any]]
            DispatchQueue.main.async { self?.eventSink?(payload) }
          },
          onAdClick: { [weak self] adInfo in
            self?.log("[showRVWithDynamicZoneID] onAdClick 콜백 실행됨, callId=\(callId)")
            let payload: [String: Any] = ["channel": "rvCallback", "callId": callId, "event": "onAdClick",
                                          "data": ["zoneId": adInfo.zoneId, "network": adInfo.network as Any, "adType": adInfo.adType as Any]]
            DispatchQueue.main.async { self?.eventSink?(payload) }
          }
        )
      } else {
        LuckieverseSDK.shared.showRVWithDynamicZoneID(zoneID)
      }
      log("[showRVWithDynamicZoneID] 성공!")
      result(nil)
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
