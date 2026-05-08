library luckieverse_flutter;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class LuckieverseFlutter {
  static const MethodChannel _channel = MethodChannel('luckieverse_flutter');
  static const EventChannel _eventChannel = EventChannel('luckieverse_flutter/events');
  
  // 초기화 상태 추적
  static bool _isInitializeCalled = false;
  static DateTime? _initializeCallTime;
  static bool _isInitializeCompleted = false;

  static Stream<String> get events => _eventChannel.receiveBroadcastStream().cast<String>();
  
  /// 초기화 여부 확인
  static bool get isInitialized => _isInitializeCompleted;
  
  /// 초기화 호출 여부 확인
  static bool get isInitializeCalled => _isInitializeCalled;

  static Future<void> initialize() async {
    _log('========== initialize() 호출됨 ==========');
    _log('현재 상태: _isInitializeCalled=$_isInitializeCalled, _isInitializeCompleted=$_isInitializeCompleted');
    
    if (_isInitializeCalled) {
      _log('[WARNING] initialize()가 이미 호출되었습니다!');
      _log('이전 호출 시간: $_initializeCallTime');
    }
    
    _isInitializeCalled = true;
    _initializeCallTime = DateTime.now();
    _log('initialize 호출 시간: $_initializeCallTime');
    
    try {
      _log('네이티브 initialize 호출 전...');
      await _invoke('initialize');
      _isInitializeCompleted = true;
      _log('네이티브 initialize 호출 완료! _isInitializeCompleted=$_isInitializeCompleted');
    } catch (e, stackTrace) {
      _log('[ERROR] initialize 실패: $e');
      _log('[ERROR] 스택트레이스: $stackTrace');
      _isInitializeCompleted = false;
      rethrow;
    }
  }
  
  static Future<void> updateUserId(String userId) async {
    _log('[updateUserId] userId=$userId, isInitialized=$_isInitializeCompleted');
    _checkInitialization('updateUserId');
    await _invoke('updateUserId', {'userId': userId});
    _log('[updateUserId] 완료');
  }
  
  static Future<void> updateAppKey(String appKey) async {
    _log('[updateAppKey] appKey=$appKey, isInitialized=$_isInitializeCompleted');
    _checkInitialization('updateAppKey');
    await _invoke('updateAppKey', {'appKey': appKey});
    _log('[updateAppKey] 완료');
  }
  
  static Future<void> updateTarotAppKey(String appKey) async {
    _log('[updateTarotAppKey] appKey=$appKey, isInitialized=$_isInitializeCompleted');
    _checkInitialization('updateTarotAppKey');
    await _invoke('updateTarotAppKey', {'appKey': appKey});
    _log('[updateTarotAppKey] 완료');
  }
  
  static Future<void> updateMainKey(String mainKey) async {
    _log('[updateMainKey] mainKey=$mainKey, isInitialized=$_isInitializeCompleted');
    _checkInitialization('updateMainKey');
    await _invoke('updateMainKey', {'mainKey': mainKey});
    _log('[updateMainKey] 완료');
  }
  
  static Future<void> updateIdfa(String idfa) async {
    _log('[updateIdfa] idfa=$idfa, isInitialized=$_isInitializeCompleted');
    _checkInitialization('updateIdfa');
    await _invoke('updateIdfa', {'idfa': idfa});
    _log('[updateIdfa] 완료');
  }

  static Future<void> setFullScreenAdZoneIdForSaju(String zoneId) async {
    _log('[setFullScreenAdZoneIdForSaju] zoneId=$zoneId, isInitialized=$_isInitializeCompleted');
    _checkInitialization('setFullScreenAdZoneIdForSaju');
    await _invoke('setFullScreenAdZoneIdForSaju', {'zoneId': zoneId});
    _log('[setFullScreenAdZoneIdForSaju] 완료');
  }
  
  static Future<void> setFullScreenAdZoneIdForNotSaju(String zoneId) async {
    _log('[setFullScreenAdZoneIdForNotSaju] zoneId=$zoneId, isInitialized=$_isInitializeCompleted');
    _checkInitialization('setFullScreenAdZoneIdForNotSaju');
    await _invoke('setFullScreenAdZoneIdForNotSaju', {'zoneId': zoneId});
    _log('[setFullScreenAdZoneIdForNotSaju] 완료');
  }
  
  static Future<void> setFullScreenAdZoneIdForFortuneCookie(String zoneId) async {
    _log('[setFullScreenAdZoneIdForFortuneCookie] zoneId=$zoneId, isInitialized=$_isInitializeCompleted');
    _checkInitialization('setFullScreenAdZoneIdForFortuneCookie');
    await _invoke('setFullScreenAdZoneIdForFortuneCookie', {'zoneId': zoneId});
    _log('[setFullScreenAdZoneIdForFortuneCookie] 완료');
  }

  static Future<void> setBannerAdZoneIdForSaju(String zoneId) async {
    _log('[setBannerAdZoneIdForSaju] zoneId=$zoneId, isInitialized=$_isInitializeCompleted');
    _checkInitialization('setBannerAdZoneIdForSaju');
    await _invoke('setBannerAdZoneIdForSaju', {'zoneId': zoneId});
    _log('[setBannerAdZoneIdForSaju] 완료');
  }
  
  static Future<void> setBannerAdZoneIdForNotSaju(String zoneId) async {
    _log('[setBannerAdZoneIdForNotSaju] zoneId=$zoneId, isInitialized=$_isInitializeCompleted');
    _checkInitialization('setBannerAdZoneIdForNotSaju');
    await _invoke('setBannerAdZoneIdForNotSaju', {'zoneId': zoneId});
    _log('[setBannerAdZoneIdForNotSaju] 완료');
  }
  
  static Future<void> setBannerAdZoneIdForFortuneCookie(String zoneId) async {
    _log('[setBannerAdZoneIdForFortuneCookie] zoneId=$zoneId, isInitialized=$_isInitializeCompleted');
    _checkInitialization('setBannerAdZoneIdForFortuneCookie');
    await _invoke('setBannerAdZoneIdForFortuneCookie', {'zoneId': zoneId});
    _log('[setBannerAdZoneIdForFortuneCookie] 완료');
  }

  static Future<void> setGoToSettingCallback() async {
    _log('[setGoToSettingCallback] isInitialized=$_isInitializeCompleted');
    await _invoke('setGoToSettingCallback');
    _log('[setGoToSettingCallback] 완료');
  }
  
  static Future<void> executeGoToSettingCallback() async {
    _log('[executeGoToSettingCallback] isInitialized=$_isInitializeCompleted');
    await _invoke('executeGoToSettingCallback');
    _log('[executeGoToSettingCallback] 완료');
  }
  
  static Future<void> goToAppSetting() async {
    _log('[goToAppSetting] isInitialized=$_isInitializeCompleted');
    await _invoke('goToAppSetting');
    _log('[goToAppSetting] 완료');
  }

  static Future<void> openLuckieverseMain() async {
    _log('========== openLuckieverseMain() 호출됨 ==========');
    _log('초기화 상태: _isInitializeCalled=$_isInitializeCalled, _isInitializeCompleted=$_isInitializeCompleted');
    if (_initializeCallTime != null) {
      final elapsed = DateTime.now().difference(_initializeCallTime!);
      _log('initialize 호출 이후 경과 시간: ${elapsed.inMilliseconds}ms');
    } else {
      _log('[WARNING] initialize가 호출되지 않았습니다!');
    }
    
    _checkInitialization('openLuckieverseMain');
    
    try {
      _log('[openLuckieverseMain] 네이티브 호출 시작...');
      await _invoke('openLuckieverseMain');
      _log('[openLuckieverseMain] 네이티브 호출 완료!');
    } catch (e, stackTrace) {
      _log('[ERROR] openLuckieverseMain 실패: $e');
      _log('[ERROR] 스택트레이스: $stackTrace');
      rethrow;
    }
  }
  
  static Future<void> openLuckieverseTarot() async {
    _log('========== openLuckieverseTarot() 호출됨 ==========');
    _log('초기화 상태: _isInitializeCalled=$_isInitializeCalled, _isInitializeCompleted=$_isInitializeCompleted');
    if (_initializeCallTime != null) {
      final elapsed = DateTime.now().difference(_initializeCallTime!);
      _log('initialize 호출 이후 경과 시간: ${elapsed.inMilliseconds}ms');
    } else {
      _log('[WARNING] initialize가 호출되지 않았습니다!');
    }
    
    _checkInitialization('openLuckieverseTarot');
    
    try {
      _log('[openLuckieverseTarot] 네이티브 호출 시작...');
      await _invoke('openLuckieverseTarot');
      _log('[openLuckieverseTarot] 네이티브 호출 완료!');
    } catch (e, stackTrace) {
      _log('[ERROR] openLuckieverseTarot 실패: $e');
      _log('[ERROR] 스택트레이스: $stackTrace');
      rethrow;
    }
  }
  
  static Future<void> openLuckieverseByPush(String pushKey) async {
    _log('[openLuckieverseByPush] pushKey=$pushKey, isInitialized=$_isInitializeCompleted');
    _checkInitialization('openLuckieverseByPush');
    await _invoke('openLuckieverseByPush', {'pushKey': pushKey});
    _log('[openLuckieverseByPush] 완료');
  }
  
  static Future<void> openLuckieverseTarotByPush(String pushKey) async {
    _log('[openLuckieverseTarotByPush] pushKey=$pushKey, isInitialized=$_isInitializeCompleted');
    _checkInitialization('openLuckieverseTarotByPush');
    await _invoke('openLuckieverseTarotByPush', {'pushKey': pushKey});
    _log('[openLuckieverseTarotByPush] 완료');
  }
  
  static Future<void> openNewYearFortune() async {
    _log('[openNewYearFortune] isInitialized=$_isInitializeCompleted');
    _checkInitialization('openNewYearFortune');
    await _invoke('openNewYearFortune');
    _log('[openNewYearFortune] 완료');
  }

  static Future<void> showRVWithDynamicZoneID(String zoneID) async {
    _log('[showRVWithDynamicZoneID] zoneID=$zoneID, isInitialized=$_isInitializeCompleted');
    _checkInitialization('showRVWithDynamicZoneID');
    await _invoke('showRVWithDynamicZoneID', {'zoneID': zoneID});
    _log('[showRVWithDynamicZoneID] 완료');
  }

  static Future<void> _invoke(String method, [Map<String, dynamic>? arguments]) async {
    _log('[_invoke] method=$method, arguments=$arguments');
    try {
      await _channel.invokeMethod(method, arguments);
      _log('[_invoke] $method 성공');
    } on PlatformException catch (e) {
      _log('[_invoke] PlatformException 발생: code=${e.code}, message=${e.message}, details=${e.details}');
      // Re-throw as regular exception with message
      throw Exception('LuckieverseFlutter.$method failed: ${e.code} ${e.message}');
    }
  }
  
  /// 초기화 상태를 확인하고 경고 로그 출력
  static void _checkInitialization(String methodName) {
    if (!_isInitializeCalled) {
      _log('[WARNING] $methodName 호출됨 - 하지만 initialize()가 아직 호출되지 않았습니다!');
    } else if (!_isInitializeCompleted) {
      _log('[WARNING] $methodName 호출됨 - initialize()가 호출되었지만 완료되지 않았습니다!');
    }
  }
  
  /// 디버그 로그 출력
  static void _log(String message) {
    if (kDebugMode) {
      debugPrint('[LuckieverseFlutter] $message');
    }
  }
  
  /// 현재 초기화 상태를 문자열로 반환 (디버깅용)
  static String getDebugStatus() {
    return '''
LuckieverseFlutter Debug Status:
  - isInitializeCalled: $_isInitializeCalled
  - isInitializeCompleted: $_isInitializeCompleted
  - initializeCallTime: $_initializeCallTime
  - timeSinceInitialize: ${_initializeCallTime != null ? DateTime.now().difference(_initializeCallTime!).inMilliseconds : 'N/A'}ms
''';
  }
}
