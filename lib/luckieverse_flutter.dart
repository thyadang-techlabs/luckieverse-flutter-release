library luckieverse_flutter;

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class LuckieverseFlutter {
  static const MethodChannel _channel = MethodChannel('luckieverse_flutter');
  static const EventChannel _eventChannel = EventChannel('luckieverse_flutter/events');
  
  // 초기화 상태 추적
  static bool _isInitializeCalled = false;
  static DateTime? _initializeCallTime;
  static bool _isInitializeCompleted = false;

  static Stream<String> get events => _eventChannel
      .receiveBroadcastStream()
      .cast<String>()
      .where((event) => !event.startsWith('rvCallback:'));
  
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

  // RV 콜백 관련 상태
  static final Map<String, _RVCallbacks> _rvCallbacks = {};
  static final Random _secureRandom = Random.secure();
  static bool _rvListenerStarted = false;
  static StreamSubscription<String>? _rvCallbackSubscription;

  static String _generateCallId() {
    final bytes = List<int>.generate(16, (_) => _secureRandom.nextInt(256));
    final nonce = base64Url.encode(bytes).replaceAll('=', '').replaceAll(':', '_');
    return 'rv_$nonce';
  }

  /// terminal 콜백: 광고 사이클 종료 신호. 수신 즉시 매핑 제거 + timer 취소.
  static const _rvTerminalEvents = {
    'onLoadFail',
    'onAdComplete',
    'onAdNoFill',
    'onAdBlockUser',
    'onAdClose',
  };

  static void _ensureRvCallbackListener() {
    if (_rvListenerStarted) return;
    _rvListenerStarted = true;
    _rvCallbackSubscription = _eventChannel.receiveBroadcastStream().cast<String>().listen(
      (event) {
        if (!event.startsWith('rvCallback:')) return;
        final parts = event.split(':');
        if (parts.length < 3) return;
        final callId = parts[1];
        final type = parts[2];
        _log('[showRVWithDynamicZoneID] 콜백 수신: callId=$callId, type=$type');

        final isTerminal = _rvTerminalEvents.contains(type);
        final callbacks = isTerminal
            ? _rvCallbacks.remove(callId)
            : _rvCallbacks[callId];
        if (callbacks == null) return;
        if (isTerminal) callbacks.timer?.cancel();

        switch (type) {
          case 'onLoadFail':
            try {
              callbacks.onLoadFail?.call();
            } catch (e, st) {
              _log('[showRVWithDynamicZoneID] onLoadFail 콜백 예외: $e\n$st');
            }
            break;
          case 'onAdComplete':
            try {
              callbacks.onAdComplete?.call();
            } catch (e, st) {
              _log('[showRVWithDynamicZoneID] onAdComplete 콜백 예외: $e\n$st');
            }
            break;
          case 'onAdNoFill':
            try {
              callbacks.onAdNoFill?.call();
            } catch (e, st) {
              _log('[showRVWithDynamicZoneID] onAdNoFill 콜백 예외: $e\n$st');
            }
            break;
          case 'onAdBlockUser':
            try {
              callbacks.onAdBlockUser?.call();
            } catch (e, st) {
              _log('[showRVWithDynamicZoneID] onAdBlockUser 콜백 예외: $e\n$st');
            }
            break;
          case 'onAdLoad':
            try {
              callbacks.onAdLoad?.call();
            } catch (e, st) {
              _log('[showRVWithDynamicZoneID] onAdLoad 콜백 예외: $e\n$st');
            }
            break;
          case 'onAdShow':
            try {
              callbacks.onAdShow?.call();
            } catch (e, st) {
              _log('[showRVWithDynamicZoneID] onAdShow 콜백 예외: $e\n$st');
            }
            break;
          case 'onAdClick':
            try {
              callbacks.onAdClick?.call();
            } catch (e, st) {
              _log('[showRVWithDynamicZoneID] onAdClick 콜백 예외: $e\n$st');
            }
            break;
          case 'onAdSkip':
            try {
              callbacks.onAdSkip?.call();
            } catch (e, st) {
              _log('[showRVWithDynamicZoneID] onAdSkip 콜백 예외: $e\n$st');
            }
            break;
          case 'onAdClose':
            try {
              callbacks.onAdClose?.call();
            } catch (e, st) {
              _log('[showRVWithDynamicZoneID] onAdClose 콜백 예외: $e\n$st');
            }
            break;
        }
      },
      onError: (error) {
        _log('[showRVWithDynamicZoneID] EventChannel 오류: $error');
      },
    );
    _log('[showRVWithDynamicZoneID] RV 콜백 리스너 시작됨');
  }

  /// RV(보상형 광고)를 동적 zoneID로 표시합니다.
  ///
  /// **lifecycle 콜백** (광고 사이클 중 여러 번 호출될 수 있음):
  /// - [onAdLoad]  : 광고 로드 완료 시 호출.
  /// - [onAdShow]  : 광고 화면이 표시될 때 호출.
  /// - [onAdClick] : 사용자가 광고를 클릭할 때 호출.
  /// - [onAdSkip]  : 사용자가 광고를 건너뛸 때 호출.
  ///
  /// **terminal 콜백** (광고 사이클 종료 신호. 호출 후 매핑 자동 정리):
  /// - [onLoadFail]    : 광고 로드 실패 시 호출.
  /// - [onAdComplete]  : 보상 조건 달성(광고 완시청) 시 호출.
  /// - [onAdNoFill]    : 광고 인벤토리 없음 시 호출.
  /// - [onAdBlockUser] : 광고 차단 사용자 처리 시 호출.
  /// - [onAdClose]     : 광고 화면이 닫힐 때 호출 (사이클 최종 종료).
  static Future<void> showRVWithDynamicZoneID(
    String zoneID, {
    VoidCallback? onLoadFail,
    VoidCallback? onAdComplete,
    VoidCallback? onAdNoFill,
    VoidCallback? onAdBlockUser,
    VoidCallback? onAdLoad,
    VoidCallback? onAdShow,
    VoidCallback? onAdClick,
    VoidCallback? onAdSkip,
    VoidCallback? onAdClose,
  }) async {
    _log('[showRVWithDynamicZoneID] zoneID=$zoneID, isInitialized=$_isInitializeCompleted');
    _checkInitialization('showRVWithDynamicZoneID');

    final hasCallbacks = onLoadFail != null || onAdComplete != null ||
        onAdNoFill != null || onAdBlockUser != null ||
        onAdLoad != null || onAdShow != null || onAdClick != null ||
        onAdSkip != null || onAdClose != null;

    if (hasCallbacks) {
      _ensureRvCallbackListener();
      final callId = _generateCallId();
      final entry = _RVCallbacks(
        onLoadFail: onLoadFail,
        onAdComplete: onAdComplete,
        onAdNoFill: onAdNoFill,
        onAdBlockUser: onAdBlockUser,
        onAdLoad: onAdLoad,
        onAdShow: onAdShow,
        onAdClick: onAdClick,
        onAdSkip: onAdSkip,
        onAdClose: onAdClose,
      );
      entry.timer = Timer(const Duration(minutes: 5), () {
        if (_rvCallbacks.remove(callId) != null) {
          _log('[showRVWithDynamicZoneID] callId=$callId TTL 만료로 정리됨');
        }
      });
      _rvCallbacks[callId] = entry;
      _log('[showRVWithDynamicZoneID] callId=$callId 생성됨');
      await _invoke('showRVWithDynamicZoneID', {'zoneID': zoneID, 'callId': callId});
    } else {
      await _invoke('showRVWithDynamicZoneID', {'zoneID': zoneID});
    }
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

class _RVCallbacks {
  final VoidCallback? onLoadFail;
  final VoidCallback? onAdComplete;
  final VoidCallback? onAdNoFill;
  final VoidCallback? onAdBlockUser;
  final VoidCallback? onAdLoad;
  final VoidCallback? onAdShow;
  final VoidCallback? onAdClick;
  final VoidCallback? onAdSkip;
  final VoidCallback? onAdClose;
  Timer? timer;

  _RVCallbacks({
    this.onLoadFail,
    this.onAdComplete,
    this.onAdNoFill,
    this.onAdBlockUser,
    this.onAdLoad,
    this.onAdShow,
    this.onAdClick,
    this.onAdSkip,
    this.onAdClose,
  });
}
