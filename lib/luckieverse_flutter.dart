library luckieverse_flutter;

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class LuckieverseAdInfo {
  final String zoneId;
  final String? network;
  final String? adType;

  const LuckieverseAdInfo({required this.zoneId, this.network, this.adType});

  factory LuckieverseAdInfo.fromMap(Map<dynamic, dynamic> map) {
    return LuckieverseAdInfo(
      zoneId: map['zoneId'] as String? ?? '',
      network: map['network'] as String?,
      adType: map['adType'] as String?,
    );
  }
}

class LuckieverseAdError {
  final int code;
  final String? message;

  const LuckieverseAdError({required this.code, this.message});

  factory LuckieverseAdError.fromMap(Map<dynamic, dynamic> map) {
    return LuckieverseAdError(
      code: map['code'] as int? ?? -1,
      message: map['message'] as String?,
    );
  }
}

class LuckieverseFlutter {
  static const MethodChannel _channel = MethodChannel('luckieverse_flutter');
  static const EventChannel _eventChannel = EventChannel('luckieverse_flutter/events');
  
  // 초기화 상태 추적
  static bool _isInitializeCalled = false;
  static DateTime? _initializeCallTime;
  static bool _isInitializeCompleted = false;

  static Stream<dynamic>? _cachedRawEventStream;
  static Stream<dynamic> get _rawEventStream => _cachedRawEventStream ??= _eventChannel.receiveBroadcastStream();

  static Stream<String> get events => _rawEventStream
      .where((event) => event is String && !event.startsWith('rvCallback:'))
      .cast<String>();
  
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

  /// 전면(fullscreen) 광고 로드 타임아웃을 설정합니다. 기본값 40초.
  /// 유효 범위(Android: 1초~600초, iOS: 1초 이상 상한 없음)를 벗어난 값은
  /// 예외 없이 조용히 무시되고 이전 값이 유지됩니다.
  ///
  /// [timeoutSeconds]가 0 이하(음수 포함)이면 네이티브로 전달하지 않고
  /// [ArgumentError]를 던집니다.
  static Future<void> setAdLoadTimeout(int timeoutSeconds) async {
    _log('[setAdLoadTimeout] timeoutSeconds=$timeoutSeconds, isInitialized=$_isInitializeCompleted');
    if (timeoutSeconds <= 0) {
      throw ArgumentError.value(
        timeoutSeconds,
        'timeoutSeconds',
        'setAdLoadTimeout: timeoutSeconds는 0보다 커야 합니다.',
      );
    }
    _checkInitialization('setAdLoadTimeout');
    await _invoke('setAdLoadTimeout', {'timeoutSeconds': timeoutSeconds});
    _log('[setAdLoadTimeout] 완료');
  }

  /// 전면(fullscreen) 광고 표시(show) 타임아웃을 설정합니다. 기본값 180초.
  /// 유효 범위(Android: 1초~600초, iOS: 1초 이상 상한 없음)를 벗어난 값은
  /// 예외 없이 조용히 무시되고 이전 값이 유지됩니다.
  ///
  /// [timeoutSeconds]가 0 이하(음수 포함)이면 네이티브로 전달하지 않고
  /// [ArgumentError]를 던집니다.
  static Future<void> setAdShowTimeout(int timeoutSeconds) async {
    _log('[setAdShowTimeout] timeoutSeconds=$timeoutSeconds, isInitialized=$_isInitializeCompleted');
    if (timeoutSeconds <= 0) {
      throw ArgumentError.value(
        timeoutSeconds,
        'timeoutSeconds',
        'setAdShowTimeout: timeoutSeconds는 0보다 커야 합니다.',
      );
    }
    _checkInitialization('setAdShowTimeout');
    await _invoke('setAdShowTimeout', {'timeoutSeconds': timeoutSeconds});
    _log('[setAdShowTimeout] 완료');
  }

  // RV 콜백 관련 상태
  static final Map<String, _RVCallbacks> _rvCallbacks = {};
  static final Random _secureRandom = Random.secure();
  static bool _rvListenerStarted = false;
  static StreamSubscription<dynamic>? _rvCallbackSubscription;

  static String _generateCallId() {
    final bytes = List<int>.generate(16, (_) => _secureRandom.nextInt(256));
    final nonce = base64Url.encode(bytes).replaceAll('=', '').replaceAll(':', '_');
    return 'rv_$nonce';
  }

  /// terminal 콜백: 광고 사이클 종료 신호. 수신 즉시 매핑 제거.
  static const _rvTerminalEvents = {
    'onLoadFail',
    'onAdNoFill',
    'onAdBlockUser',
    'onAdClose',
  };

  static void _ensureRvCallbackListener() {
    if (_rvListenerStarted) return;
    _rvListenerStarted = true;
    _rvCallbackSubscription = _rawEventStream.listen(
      (event) {
        String? callId;
        String? type;
        Map<dynamic, dynamic>? dataMap;

        if (event is Map) {
          if (event['channel'] != 'rvCallback') return;
          callId = event['callId'] as String?;
          type = event['event'] as String?;
          final raw = event['data'];
          if (raw is Map) dataMap = raw;
        } else if (event is String) {
          if (!event.startsWith('rvCallback:')) return;
          final parts = event.split(':');
          if (parts.length < 3) {
            _adLog(
              '[showRVWithDynamicZoneID] rvCallback 이벤트 파싱 실패(형식 오류): raw="$event"',
              warning: true,
            );
            return;
          }
          callId = parts[1];
          type = parts[2];
        }

        if (callId == null || type == null) {
          _adLog(
            '[showRVWithDynamicZoneID] rvCallback 이벤트 파싱 실패(callId 또는 type 누락): raw=$event',
            warning: true,
          );
          return;
        }
        _adLog('[showRVWithDynamicZoneID] 콜백 수신: callId=$callId, type=$type');

        final isTerminal = _rvTerminalEvents.contains(type);
        final callbacks = isTerminal
            ? _rvCallbacks.remove(callId)
            : _rvCallbacks[callId];
        if (callbacks == null) {
          _adLog(
            '[showRVWithDynamicZoneID] callId=$callId 에 대한 콜백을 못 찾음(이미 처리됨), type=$type',
            warning: true,
          );
          return;
        }

        switch (type) {
          case 'onLoadFail':
            try {
              final adError = dataMap != null
                  ? LuckieverseAdError.fromMap(dataMap)
                  : const LuckieverseAdError(code: -1);
              callbacks.onLoadFail?.call(adError);
            } catch (e, st) {
              _adLog('[showRVWithDynamicZoneID] onLoadFail 콜백 예외: $e\n$st', warning: true);
            }
            break;
          case 'onAdComplete':
            try {
              final adInfo = dataMap != null
                  ? LuckieverseAdInfo.fromMap(dataMap)
                  : const LuckieverseAdInfo(zoneId: '');
              callbacks.onAdComplete?.call(adInfo);
            } catch (e, st) {
              _adLog('[showRVWithDynamicZoneID] onAdComplete 콜백 예외: $e\n$st', warning: true);
            }
            break;
          case 'onAdNoFill':
            try {
              callbacks.onAdNoFill?.call();
            } catch (e, st) {
              _adLog('[showRVWithDynamicZoneID] onAdNoFill 콜백 예외: $e\n$st', warning: true);
            }
            break;
          case 'onAdBlockUser':
            try {
              callbacks.onAdBlockUser?.call();
            } catch (e, st) {
              _adLog('[showRVWithDynamicZoneID] onAdBlockUser 콜백 예외: $e\n$st', warning: true);
            }
            break;
          case 'onAdLoad':
            try {
              callbacks.onAdLoad?.call();
            } catch (e, st) {
              _adLog('[showRVWithDynamicZoneID] onAdLoad 콜백 예외: $e\n$st', warning: true);
            }
            break;
          case 'onAdShow':
            try {
              final adInfo = dataMap != null
                  ? LuckieverseAdInfo.fromMap(dataMap)
                  : const LuckieverseAdInfo(zoneId: '');
              callbacks.onAdShow?.call(adInfo);
            } catch (e, st) {
              _adLog('[showRVWithDynamicZoneID] onAdShow 콜백 예외: $e\n$st', warning: true);
            }
            break;
          case 'onAdClick':
            try {
              final adInfo = dataMap != null
                  ? LuckieverseAdInfo.fromMap(dataMap)
                  : const LuckieverseAdInfo(zoneId: '');
              callbacks.onAdClick?.call(adInfo);
            } catch (e, st) {
              _adLog('[showRVWithDynamicZoneID] onAdClick 콜백 예외: $e\n$st', warning: true);
            }
            break;
          case 'onAdSkip':
            try {
              callbacks.onAdSkip?.call();
            } catch (e, st) {
              _adLog('[showRVWithDynamicZoneID] onAdSkip 콜백 예외: $e\n$st', warning: true);
            }
            break;
          case 'onAdClose':
            try {
              final adInfo = dataMap != null
                  ? LuckieverseAdInfo.fromMap(dataMap)
                  : const LuckieverseAdInfo(zoneId: '');
              callbacks.onAdClose?.call(adInfo);
            } catch (e, st) {
              _adLog('[showRVWithDynamicZoneID] onAdClose 콜백 예외: $e\n$st', warning: true);
            }
            break;
        }
      },
      onError: (error) {
        _adLog('[showRVWithDynamicZoneID] EventChannel 오류: $error', warning: true);
      },
    );
    _adLog('[showRVWithDynamicZoneID] RV 콜백 리스너 시작됨');
  }

  /// RV(보상형 광고)를 동적 zoneID로 표시합니다.
  ///
  /// **lifecycle 콜백** (광고 사이클 중 여러 번 호출될 수 있음):
  /// - [onAdLoad]  : 광고 로드 완료 시 호출.
  /// - [onAdShow]  : 광고 화면이 표시될 때 호출 ([LuckieverseAdInfo] 포함).
  /// - [onAdClick] : 사용자가 광고를 클릭할 때 호출 ([LuckieverseAdInfo] 포함).
  /// - [onAdSkip]  : 사용자가 광고를 건너뛸 때 호출.
  ///
  /// **terminal 콜백** (광고 사이클 종료 신호. 호출 후 매핑 자동 정리):
  /// - [onLoadFail]    : 광고 로드 실패 시 호출 ([LuckieverseAdError] 포함).
  /// - [onAdNoFill]    : 광고 인벤토리 없음 시 호출.
  /// - [onAdBlockUser] : 광고 차단 사용자 처리 시 호출.
  /// - [onAdClose]     : 광고 화면이 닫힐 때 호출 ([LuckieverseAdInfo] 포함, 사이클 최종 종료).
  ///
  /// **lifecycle 콜백 (추가)**:
  /// - [onAdComplete]  : 보상 조건 달성(광고 완시청) 시 호출 ([LuckieverseAdInfo] 포함). onAdClose 이전에 발화.
  ///
  /// **주의: 콜백 매핑은 시간 기반으로 만료되지 않음**
  /// callId에 대한 콜백 매핑은 오직 native(안드로이드)로부터 terminal 콜백
  /// ([onLoadFail], [onAdNoFill], [onAdBlockUser], [onAdClose])이 도착했을 때만
  /// 정리된다. native가 응답을 영영 주지 않는 극단적 케이스에서는 해당 콜백이
  /// 영원히 발화되지 않을 수 있다(호출 측에서 필요 시 자체 타임아웃을 구현해야 함).
  ///
  /// **주의: native 호출 실패 시 에러 처리**
  /// native 호출(`_invoke`)이 실패했을 때, [onLoadFail] 콜백이 등록되어 있다면
  /// [onLoadFail]로 합성 에러(code: -999)가 전달되고 Future는 정상 종료됩니다.
  /// 만약 [onLoadFail] 콜백이 등록되어 있지 않다면, 예외(Exception)가 rethrow되므로
  /// 호출 측에서 try-catch 등으로 예외를 처리해야 합니다.
  static Future<void> showRVWithDynamicZoneID(
    String zoneID, {
    void Function(LuckieverseAdError)? onLoadFail,
    void Function(LuckieverseAdInfo)? onAdComplete,
    VoidCallback? onAdNoFill,
    VoidCallback? onAdBlockUser,
    VoidCallback? onAdLoad,
    void Function(LuckieverseAdInfo)? onAdShow,
    void Function(LuckieverseAdInfo)? onAdClick,
    VoidCallback? onAdSkip,
    void Function(LuckieverseAdInfo)? onAdClose,
  }) async {
    _adLog('[showRVWithDynamicZoneID] zoneID=$zoneID, isInitialized=$_isInitializeCompleted');
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
      _rvCallbacks[callId] = entry;
      _adLog('[showRVWithDynamicZoneID] callId=$callId 생성됨');
      try {
        await _invoke(
          'showRVWithDynamicZoneID',
          {'zoneID': zoneID, 'callId': callId},
          true,
        );
      } catch (e) {
        if (_rvCallbacks.remove(callId) != null) {
          _adLog(
            '[showRVWithDynamicZoneID] callId=$callId _invoke 실패로 즉시 정리됨: $e',
            warning: true,
          );
          if (onLoadFail != null) {
            try {
              onLoadFail.call(const LuckieverseAdError(
                code: -999,
                message: 'showRVWithDynamicZoneID native invoke failed',
              ));
            } catch (cbErr, cbSt) {
              _adLog(
                '[showRVWithDynamicZoneID] callId=$callId invoke 실패 onLoadFail 콜백 예외: $cbErr\n$cbSt',
                warning: true,
              );
            }
          } else {
            rethrow;
          }
        } else {
          rethrow;
        }
      }
    } else {
      await _invoke('showRVWithDynamicZoneID', {'zoneID': zoneID}, true);
    }
    _adLog('[showRVWithDynamicZoneID] 완료');
  }

  /// [isAdFlow]가 true면 release 빌드에서도 남는 [_adLog]를 사용한다.
  /// (showRVWithDynamicZoneID 등 광고 흐름 추적용)
  static Future<void> _invoke(
    String method, [
    Map<String, dynamic>? arguments,
    bool isAdFlow = false,
  ]) async {
    void log(String message, {bool warning = false}) {
      if (isAdFlow) {
        _adLog(message, warning: warning);
      } else {
        _log(message);
      }
    }

    log('[_invoke] method=$method, arguments=$arguments');
    try {
      await _channel.invokeMethod(method, arguments);
      log('[_invoke] $method 성공');
    } on PlatformException catch (e) {
      log(
        '[_invoke] PlatformException 발생: code=${e.code}, message=${e.message}, details=${e.details}',
        warning: isAdFlow,
      );
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
  
  /// 디버그 로그 출력 (release 빌드에서는 출력되지 않음)
  static void _log(String message) {
    if (kDebugMode) {
      debugPrint('[LuckieverseFlutter] $message');
    }
  }

  /// 광고(RV) 흐름 전용 로그. release 빌드에서도 항상 출력됨.
  /// "광고 로드는 됐는데 show가 안 됨" 같은 프로덕션 버그를 추적하기 위한 목적.
  static void _adLog(String message, {bool warning = false}) {
    final tag = warning ? '[LuckieverseFlutter][WARN]' : '[LuckieverseFlutter]';
    debugPrint('$tag $message');
  }

  /// 테스트 전용: RV 콜백 리스너/매핑 상태를 초기화한다.
  /// 프로덕션 코드에서는 절대 호출하지 말 것 — 테스트 간 static 상태 격리를 위한 용도.
  @visibleForTesting
  static void resetRvStateForTesting() {
    _rvCallbackSubscription?.cancel();
    _rvCallbackSubscription = null;
    _rvListenerStarted = false;
    _cachedRawEventStream = null;
    _rvCallbacks.clear();
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
  final void Function(LuckieverseAdError)? onLoadFail;
  final void Function(LuckieverseAdInfo)? onAdComplete;
  final VoidCallback? onAdNoFill;
  final VoidCallback? onAdBlockUser;
  final VoidCallback? onAdLoad;
  final void Function(LuckieverseAdInfo)? onAdShow;
  final void Function(LuckieverseAdInfo)? onAdClick;
  final VoidCallback? onAdSkip;
  final void Function(LuckieverseAdInfo)? onAdClose;

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
