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

/// iOS 전용 로컬 푸시 종류. Android는 이 기능 자체를 지원하지 않는다
/// (네이티브 SDK에서 주석 처리되어 비활성화됨).
enum LuckieverseLocalPushType {
  main(876663),
  my(876664),
  sajuInfo(876665),
  phoneAuth(876666),
  pointHistory(876667),
  productHistory(876668),
  productHistoryDetail(876669),
  faq(876670),
  faqDetail(876671),
  inquiry(876672),
  inquiryHistory(876673),
  inquiryHistoryDetail(876674),
  termsAndPolicies(876675),
  termsAndPoliciesDetail(876676),
  productStore(876677),
  productStoreDetail(876678),
  error(876679);

  const LuckieverseLocalPushType(this.value);
  final int value;
}

/// iOS 전용 로컬 푸시 예약 정보. [LuckieverseFlutter.setLuckieverseLocalPush]에 사용된다.
///
/// [soundName]을 지정하지 않으면 iOS 네이티브가 시스템 기본 알림음(`.default`)을 사용한다.
/// [soundName]을 지정했더라도 호스트 앱 번들에 해당 이름의 사운드 파일이 없으면,
/// iOS는 에러 없이 조용히 시스템 기본 알림음으로 대체한다(런타임에 이를 알 방법이 없음).
class LuckieverseLocalPush {
  final String title;
  final String body;
  final LuckieverseLocalPushType type;
  final bool repeats;
  final int intervalInSeconds;
  final String? soundName;

  const LuckieverseLocalPush({
    required this.title,
    required this.body,
    required this.type,
    this.repeats = false,
    this.intervalInSeconds = 5,
    this.soundName,
  });

  Map<String, dynamic> toMap() => {
        'title': title,
        'body': body,
        'type': type.value,
        'repeats': repeats,
        'intervalInSeconds': intervalInSeconds,
        'soundName': soundName,
      };
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

  // ── 플랫폼 판별 헬퍼 ───────────────────────────────────────────────
  // 테스트 환경에서 재현 가능하도록 dart:io Platform 대신 defaultTargetPlatform을
  // 사용한다 (flutter test는 FLUTTER_TEST 환경변수로 기본값이 android가 됨).
  static bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;
  static bool get _isIOS => defaultTargetPlatform == TargetPlatform.iOS;

  static void _requireAndroid(String methodName) {
    if (!_isAndroid) {
      throw UnsupportedError('$methodName은(는) Android 전용 API입니다.');
    }
  }

  static void _requireIOS(String methodName) {
    if (!_isIOS) {
      throw UnsupportedError('$methodName은(는) iOS 전용 API입니다.');
    }
  }

  // ── SDK 버전 (Android/iOS 공통) ─────────────────────────────────────

  /// 네이티브 SDK 버전 문자열을 반환합니다.
  static Future<String> getSdkVersion() async {
    _checkInitialization('getSdkVersion');
    final result = await _invokeRaw('getSdkVersion');
    if (result is! String) {
      throw Exception(
        'LuckieverseFlutter.getSdkVersion: unexpected return type ${result.runtimeType}',
      );
    }
    return result;
  }

  /// 네이티브 SDK 버전 문자열을 덮어씁니다. (주로 테스트/진단용)
  static Future<void> setSdkVersion(String version) async {
    _checkInitialization('setSdkVersion');
    await _invoke('setSdkVersion', {'version': version});
  }

  // ── 광고 타임아웃 조회 (Android 전용) ────────────────────────────────
  // iOS 네이티브 SDK는 setFullscreenAdLoadTimeout/setFullscreenAdShowTimeout만
  // 노출하고 대응하는 getter가 없다.

  /// 현재 설정된 전면 광고 로드 타임아웃(초)을 반환합니다. **Android 전용.**
  static Future<int> getAdLoadTimeout() async {
    _requireAndroid('getAdLoadTimeout');
    _checkInitialization('getAdLoadTimeout');
    final result = await _invokeRaw('getAdLoadTimeout');
    if (result is! int) {
      throw Exception(
        'LuckieverseFlutter.getAdLoadTimeout: unexpected return type ${result.runtimeType}',
      );
    }
    return result;
  }

  /// ⚠️ Deprecated: show 타임아웃 메커니즘이 제거되어 저장된 값만 반환하며
  /// 실제 동작에는 영향을 주지 않습니다. **Android 전용.**
  static Future<int> getShowLoadTimeout() async {
    _requireAndroid('getShowLoadTimeout');
    _checkInitialization('getShowLoadTimeout');
    final result = await _invokeRaw('getShowLoadTimeout');
    if (result is! int) {
      throw Exception(
        'LuckieverseFlutter.getShowLoadTimeout: unexpected return type ${result.runtimeType}',
      );
    }
    return result;
  }

  // ── 광고 존 아이디 (Android 전용, 개별 setter/getter) ─────────────────
  // iOS는 setConsumableFullscreenZoneIds/setConsumableBannerZoneIds(배열)로
  // 모델이 완전히 달라 1:1로 합치지 않고 각각 노출한다.

  @Deprecated(
    '네이티브 SDK에서 더 이상 사용되지 않는 API입니다. 아무 동작도 하지 않습니다(no-op). '
    '존 아이디는 네이티브 내부에서 자동으로 설정됩니다.',
  )
  static Future<void> setFullScreenAdZoneIdForSaju(String zoneId) async {
    _requireAndroid('setFullScreenAdZoneIdForSaju');
    _checkInitialization('setFullScreenAdZoneIdForSaju');
    await _invoke('setFullScreenAdZoneIdForSaju', {'zoneId': zoneId});
  }

  @Deprecated(
    '네이티브 SDK에서 더 이상 사용되지 않는 API입니다. 아무 동작도 하지 않습니다(no-op). '
    '존 아이디는 네이티브 내부에서 자동으로 설정됩니다.',
  )
  static Future<void> setFullScreenAdZoneIdForNotSaju(String zoneId) async {
    _requireAndroid('setFullScreenAdZoneIdForNotSaju');
    _checkInitialization('setFullScreenAdZoneIdForNotSaju');
    await _invoke('setFullScreenAdZoneIdForNotSaju', {'zoneId': zoneId});
  }

  @Deprecated(
    '네이티브 SDK에서 더 이상 사용되지 않는 API입니다. 아무 동작도 하지 않습니다(no-op). '
    '존 아이디는 네이티브 내부에서 자동으로 설정됩니다.',
  )
  static Future<void> setFullScreenAdZoneIdForFortuneCookie(String zoneId) async {
    _requireAndroid('setFullScreenAdZoneIdForFortuneCookie');
    _checkInitialization('setFullScreenAdZoneIdForFortuneCookie');
    await _invoke('setFullScreenAdZoneIdForFortuneCookie', {'zoneId': zoneId});
  }

  /// **Android 전용.**
  static Future<String> getFullScreenAdZoneIdForSaju() async {
    _requireAndroid('getFullScreenAdZoneIdForSaju');
    _checkInitialization('getFullScreenAdZoneIdForSaju');
    final result = await _invokeRaw('getFullScreenAdZoneIdForSaju');
    if (result is! String) {
      throw Exception(
        'LuckieverseFlutter.getFullScreenAdZoneIdForSaju: unexpected return type ${result.runtimeType}',
      );
    }
    return result;
  }

  /// **Android 전용.**
  static Future<String> getFullScreenAdZoneIdForNotSaju() async {
    _requireAndroid('getFullScreenAdZoneIdForNotSaju');
    _checkInitialization('getFullScreenAdZoneIdForNotSaju');
    final result = await _invokeRaw('getFullScreenAdZoneIdForNotSaju');
    if (result is! String) {
      throw Exception(
        'LuckieverseFlutter.getFullScreenAdZoneIdForNotSaju: unexpected return type ${result.runtimeType}',
      );
    }
    return result;
  }

  /// **Android 전용.**
  static Future<String> getFullScreenAdZoneIdForFortuneCookie() async {
    _requireAndroid('getFullScreenAdZoneIdForFortuneCookie');
    _checkInitialization('getFullScreenAdZoneIdForFortuneCookie');
    final result = await _invokeRaw('getFullScreenAdZoneIdForFortuneCookie');
    if (result is! String) {
      throw Exception(
        'LuckieverseFlutter.getFullScreenAdZoneIdForFortuneCookie: unexpected return type ${result.runtimeType}',
      );
    }
    return result;
  }

  @Deprecated(
    '네이티브 SDK에서 더 이상 사용되지 않는 API입니다. 아무 동작도 하지 않습니다(no-op). '
    '존 아이디는 네이티브 내부에서 자동으로 설정됩니다.',
  )
  static Future<void> setBannerAdZoneIdForSaju(String zoneId) async {
    _requireAndroid('setBannerAdZoneIdForSaju');
    _checkInitialization('setBannerAdZoneIdForSaju');
    await _invoke('setBannerAdZoneIdForSaju', {'zoneId': zoneId});
  }

  @Deprecated(
    '네이티브 SDK에서 더 이상 사용되지 않는 API입니다. 아무 동작도 하지 않습니다(no-op). '
    '존 아이디는 네이티브 내부에서 자동으로 설정됩니다.',
  )
  static Future<void> setBannerAdZoneIdForNotSaju(String zoneId) async {
    _requireAndroid('setBannerAdZoneIdForNotSaju');
    _checkInitialization('setBannerAdZoneIdForNotSaju');
    await _invoke('setBannerAdZoneIdForNotSaju', {'zoneId': zoneId});
  }

  @Deprecated(
    '네이티브 SDK에서 더 이상 사용되지 않는 API입니다. 아무 동작도 하지 않습니다(no-op). '
    '존 아이디는 네이티브 내부에서 자동으로 설정됩니다.',
  )
  static Future<void> setBannerAdZoneIdForFortuneCookie(String zoneId) async {
    _requireAndroid('setBannerAdZoneIdForFortuneCookie');
    _checkInitialization('setBannerAdZoneIdForFortuneCookie');
    await _invoke('setBannerAdZoneIdForFortuneCookie', {'zoneId': zoneId});
  }

  /// **Android 전용.**
  static Future<String> getBannerAdZoneIdForSaju() async {
    _requireAndroid('getBannerAdZoneIdForSaju');
    _checkInitialization('getBannerAdZoneIdForSaju');
    final result = await _invokeRaw('getBannerAdZoneIdForSaju');
    if (result is! String) {
      throw Exception(
        'LuckieverseFlutter.getBannerAdZoneIdForSaju: unexpected return type ${result.runtimeType}',
      );
    }
    return result;
  }

  /// **Android 전용.**
  static Future<String> getBannerAdZoneIdForNotSaju() async {
    _requireAndroid('getBannerAdZoneIdForNotSaju');
    _checkInitialization('getBannerAdZoneIdForNotSaju');
    final result = await _invokeRaw('getBannerAdZoneIdForNotSaju');
    if (result is! String) {
      throw Exception(
        'LuckieverseFlutter.getBannerAdZoneIdForNotSaju: unexpected return type ${result.runtimeType}',
      );
    }
    return result;
  }

  /// **Android 전용.**
  static Future<String> getBannerAdZoneIdForFortuneCookie() async {
    _requireAndroid('getBannerAdZoneIdForFortuneCookie');
    _checkInitialization('getBannerAdZoneIdForFortuneCookie');
    final result = await _invokeRaw('getBannerAdZoneIdForFortuneCookie');
    if (result is! String) {
      throw Exception(
        'LuckieverseFlutter.getBannerAdZoneIdForFortuneCookie: unexpected return type ${result.runtimeType}',
      );
    }
    return result;
  }

  /// iOS 전용 배열 기반 존 아이디 설정. Android는 개별 setter
  /// (`setFullScreenAdZoneIdForSaju` 등)를 사용해야 합니다. **iOS 전용.**
  static Future<void> setConsumableFullscreenZoneIds(List<String> zoneIds) async {
    _requireIOS('setConsumableFullscreenZoneIds');
    _checkInitialization('setConsumableFullscreenZoneIds');
    await _invoke('setConsumableFullscreenZoneIds', {'zoneIds': zoneIds});
  }

  /// iOS 전용 배열 기반 배너 존 아이디 설정. **iOS 전용.**
  static Future<void> setConsumableBannerZoneIds(List<String> zoneIds) async {
    _requireIOS('setConsumableBannerZoneIds');
    _checkInitialization('setConsumableBannerZoneIds');
    await _invoke('setConsumableBannerZoneIds', {'zoneIds': zoneIds});
  }

  // ── 기타 진단/설정 (Android/iOS 공통 또는 편중) ───────────────────────

  /// 현재 앱이 Luckieverse 콘텐츠를 노출해야 하는 상태인지 여부. **Android 전용.**
  static Future<bool> getShouldExposeContent() async {
    _requireAndroid('getShouldExposeContent');
    _checkInitialization('getShouldExposeContent');
    final result = await _invokeRaw('getShouldExposeContent');
    if (result is! bool) {
      throw Exception(
        'LuckieverseFlutter.getShouldExposeContent: unexpected return type ${result.runtimeType}',
      );
    }
    return result;
  }

  /// 마지막으로 저장된 SDK 정보 문자열(버전/초기화 시각 등)을 반환합니다.
  /// 초기화 전이거나 저장된 값이 없으면 `null`을 반환할 수 있습니다. **Android 전용.**
  static Future<String?> getSDKInfo() async {
    _requireAndroid('getSDKInfo');
    _checkInitialization('getSDKInfo');
    final result = await _invokeRaw('getSDKInfo');
    if (result != null && result is! String) {
      throw Exception(
        'LuckieverseFlutter.getSDKInfo: unexpected return type ${result.runtimeType}',
      );
    }
    return result as String?;
  }

  /// 참여형 콘텐츠의 랜딩 URL을 조회합니다. **Android 전용.**
  ///
  /// ⚠️ **경고: 현재 네이티브 SDK가 개발 서버를 하드코딩하고 있습니다.**
  /// 네이티브 `Luckieverse.kt`의 이 API 구현이 `https://luckybite-dev.adop.co.kr`
  /// (개발 서버)로 요청을 보내도록 하드코딩되어 있으며, 네이티브 주석 자체가
  /// "실제 API 서버 주소로 변경 필요"라고 미완성임을 밝히고 있습니다. 이 요청에는
  /// `X-App-Key`(앱 키)와 `X-User-Key`(사용자 ID)가 헤더로 함께 전송되므로,
  /// **네이티브 SDK가 프로덕션 서버로 전환되기 전까지 프로덕션 앱에서 호출하지
  /// 마세요.**
  ///
  /// ⚠️ **경고: 네트워크 실패 시 빈 문자열이 반환될 수 있습니다.**
  /// 네이티브 `NetworkManager.post`는 예외를 삼키고 HTTP 실패 시에도 빈 문자열을
  /// 반환하므로, 이 메서드는 결과가 빈 문자열이면 [Exception]을 던집니다. 호출
  /// 측에서 이 예외를 네트워크/서버 실패로 간주하고 처리해야 합니다.
  static Future<String> getContentLandingUrl(String contentsId) async {
    _requireAndroid('getContentLandingUrl');
    _checkInitialization('getContentLandingUrl');
    final result = await _invokeRaw('getContentLandingUrl', {'contentsId': contentsId});
    if (result is! String) {
      throw Exception(
        'LuckieverseFlutter.getContentLandingUrl: unexpected return type ${result.runtimeType}',
      );
    }
    if (result.isEmpty) {
      throw Exception(
        'LuckieverseFlutter.getContentLandingUrl: native가 빈 문자열을 반환했습니다 '
        '(네트워크 실패 또는 서버 오류 가능성 — NetworkManager.post는 실패 시에도 '
        '빈 문자열을 반환합니다).',
      );
    }
    return result;
  }

  /// 게임(가위바위보 등) 전용 앱키를 갱신합니다.
  static Future<void> updateGameAppKey(String appKey) async {
    _checkInitialization('updateGameAppKey');
    await _invoke('updateGameAppKey', {'appKey': appKey});
  }

  /// 배너 광고 디버그 모드를 활성화/비활성화합니다.
  static Future<void> enableBannerDebug(bool enable) async {
    _checkInitialization('enableBannerDebug');
    await _invoke('enableBannerDebug', {'enable': enable});
  }

  /// 테스트 목적으로 전면 광고를 강제로 실패시킵니다.
  /// (Android: `enableMakeFullScreenAdFailForTest`, iOS: `enableFullScreenAdFailForTest`)
  static Future<void> enableFullScreenAdFailForTest(bool enable) async {
    _checkInitialization('enableFullScreenAdFailForTest');
    await _invoke('enableFullScreenAdFailForTest', {'enable': enable});
  }

  /// iOS 전용: 배너 광고의 최대 높이(포인트)를 갱신합니다. **iOS 전용.**
  static Future<void> updateBannerHeightLimit(double height) async {
    _requireIOS('updateBannerHeightLimit');
    _checkInitialization('updateBannerHeightLimit');
    await _invoke('updateBannerHeightLimit', {'height': height});
  }

  /// iOS 전용: WKWebView 인스펙터(Safari 원격 디버깅) 활성화 여부를 설정합니다. **iOS 전용.**
  ///
  /// ⚠️ **경고**: 프로덕션에서 활성화하면 웹뷰 내부(세션 토큰 등 민감 정보 포함 가능)가
  /// Safari 웹 인스펙터를 통해 외부에 노출될 수 있습니다. 프로덕션 빌드에서는
  /// 활성화하지 마세요.
  static Future<void> updateWebviewInspector(bool enabled) async {
    _requireIOS('updateWebviewInspector');
    _checkInitialization('updateWebviewInspector');
    await _invoke('updateWebviewInspector', {'enabled': enabled});
  }

  // ── 플로팅 버튼 (iOS 전용) ───────────────────────────────────────────
  // iOS 네이티브에서 현재 최상단 ViewController를 자동으로 획득해 붙인다.

  /// **iOS 전용.**
  static Future<void> showFloatingButton() async {
    _requireIOS('showFloatingButton');
    _checkInitialization('showFloatingButton');
    await _invoke('showFloatingButton');
  }

  /// **iOS 전용.**
  static Future<void> hideFloatingButton() async {
    _requireIOS('hideFloatingButton');
    _checkInitialization('hideFloatingButton');
    await _invoke('hideFloatingButton');
  }

  // ── 로컬 푸시 (iOS 전용) ─────────────────────────────────────────────
  // Android 네이티브 SDK는 이 기능이 주석 처리되어 비활성화되어 있다.

  /// **iOS 전용.**
  static Future<void> setLuckieverseLocalPush(LuckieverseLocalPush push) async {
    _requireIOS('setLuckieverseLocalPush');
    _checkInitialization('setLuckieverseLocalPush');
    await _invoke('setLuckieverseLocalPush', push.toMap());
  }

  /// **iOS 전용.**
  static Future<void> cancelLuckieverseLocalPush(LuckieverseLocalPushType pushType) async {
    _requireIOS('cancelLuckieverseLocalPush');
    _checkInitialization('cancelLuckieverseLocalPush');
    await _invoke('cancelLuckieverseLocalPush', {'pushType': pushType.value});
  }

  // ── 화면 오픈 (Android/iOS 공통) ─────────────────────────────────────

  static Future<void> openLuckieverseMyPage() async {
    _checkInitialization('openLuckieverseMyPage');
    await _invoke('openLuckieverseMyPage');
  }

  static Future<void> openLuckieverseSajuInfo() async {
    _checkInitialization('openLuckieverseSajuInfo');
    await _invoke('openLuckieverseSajuInfo');
  }

  static Future<void> openLuckieversePhoneAuth() async {
    _checkInitialization('openLuckieversePhoneAuth');
    await _invoke('openLuckieversePhoneAuth');
  }

  static Future<void> openLuckieversePointHistory() async {
    _checkInitialization('openLuckieversePointHistory');
    await _invoke('openLuckieversePointHistory');
  }

  static Future<void> openLuckieverseProductHistory() async {
    _checkInitialization('openLuckieverseProductHistory');
    await _invoke('openLuckieverseProductHistory');
  }

  /// [id]는 두 플랫폼 모두 필수입니다.
  static Future<void> openLuckieverseProductHistoryDetail(String id) async {
    _checkInitialization('openLuckieverseProductHistoryDetail');
    await _invoke('openLuckieverseProductHistoryDetail', {'id': id});
  }

  static Future<void> openLuckieverseFaq() async {
    _checkInitialization('openLuckieverseFaq');
    await _invoke('openLuckieverseFaq');
  }

  /// **플랫폼 비대칭 주의**: iOS 네이티브는 `id`가 필수 파라미터이지만
  /// Android 네이티브는 `id`를 받지 않습니다(무시됨).
  /// iOS에서 [id]를 생략(`null`)하면 [ArgumentError]가 발생합니다.
  static Future<void> openLuckieverseFaqDetail({String? id}) async {
    _checkInitialization('openLuckieverseFaqDetail');
    if (_isIOS && id == null) {
      throw ArgumentError.value(
        id,
        'id',
        'openLuckieverseFaqDetail: iOS에서는 id가 필수입니다.',
      );
    }
    await _invoke('openLuckieverseFaqDetail', {'id': id});
  }

  static Future<void> openLuckieverseInquiry() async {
    _checkInitialization('openLuckieverseInquiry');
    await _invoke('openLuckieverseInquiry');
  }

  static Future<void> openLuckieverseInquiryHistory() async {
    _checkInitialization('openLuckieverseInquiryHistory');
    await _invoke('openLuckieverseInquiryHistory');
  }

  /// [id]는 두 플랫폼 모두 필수입니다.
  static Future<void> openLuckieverseInquiryHistoryDetail(String id) async {
    _checkInitialization('openLuckieverseInquiryHistoryDetail');
    await _invoke('openLuckieverseInquiryHistoryDetail', {'id': id});
  }

  static Future<void> openLuckieverseTermsAndPolicies() async {
    _checkInitialization('openLuckieverseTermsAndPolicies');
    await _invoke('openLuckieverseTermsAndPolicies');
  }

  /// **플랫폼 비대칭 주의**: iOS 네이티브는 `id`가 필수 파라미터이지만
  /// Android 네이티브는 `id`를 받지 않습니다(무시됨).
  /// iOS에서 [id]를 생략(`null`)하면 [ArgumentError]가 발생합니다.
  static Future<void> openLuckieverseTermsAndPoliciesDetail({String? id}) async {
    _checkInitialization('openLuckieverseTermsAndPoliciesDetail');
    if (_isIOS && id == null) {
      throw ArgumentError.value(
        id,
        'id',
        'openLuckieverseTermsAndPoliciesDetail: iOS에서는 id가 필수입니다.',
      );
    }
    await _invoke('openLuckieverseTermsAndPoliciesDetail', {'id': id});
  }

  static Future<void> openLuckieverseProductStore() async {
    _checkInitialization('openLuckieverseProductStore');
    await _invoke('openLuckieverseProductStore');
  }

  static Future<void> openLuckieverseProductStoreDetail() async {
    _checkInitialization('openLuckieverseProductStoreDetail');
    await _invoke('openLuckieverseProductStoreDetail');
  }

  static Future<void> openLuckieverseError() async {
    _checkInitialization('openLuckieverseError');
    await _invoke('openLuckieverseError');
  }

  static Future<void> openFaceReading() async {
    _checkInitialization('openFaceReading');
    await _invoke('openFaceReading');
  }

  static Future<void> checkGoogleAdmobWebviewAPI() async {
    _checkInitialization('checkGoogleAdmobWebviewAPI');
    await _invoke('checkGoogleAdmobWebviewAPI');
  }

  /// 이메일 앱을 엽니다. [toAddress]를 생략하면 각 네이티브 SDK의 기본 수신 주소로 연결됩니다.
  /// (Android: `openEmail`, iOS: `openEmailApp`)
  ///
  /// [toAddress]에 개행(`\r`, `\n`) 또는 그 외 제어문자가 포함되어 있으면
  /// 메일 헤더 인젝션 가능성을 막기 위해 [ArgumentError]를 던집니다.
  static Future<void> openEmail({String? toAddress}) async {
    _checkInitialization('openEmail');
    if (toAddress != null && _containsControlCharacters(toAddress)) {
      throw ArgumentError.value(
        toAddress,
        'toAddress',
        'openEmail: toAddress에 개행/제어문자를 포함할 수 없습니다.',
      );
    }
    await _invoke('openEmail', {'toAddress': toAddress});
  }

  /// 개행(`\r`, `\n`) 및 그 외 제어문자(0x00-0x1F, 0x7F) 포함 여부를 검사합니다.
  static bool _containsControlCharacters(String value) {
    for (final codeUnit in value.codeUnits) {
      if (codeUnit <= 0x1F || codeUnit == 0x7F) {
        return true;
      }
    }
    return false;
  }

  static Future<void> openLuckieverseGame() async {
    _checkInitialization('openLuckieverseGame');
    await _invoke('openLuckieverseGame');
  }

  static Future<void> openLuckieverseGameByPush(String pushKey) async {
    _checkInitialization('openLuckieverseGameByPush');
    await _invoke('openLuckieverseGameByPush', {'pushKey': pushKey});
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

  /// ⚠️ Deprecated: 네이티브 SDK(Android/iOS)에서 show 타임아웃 안전장치가
  /// 완전히 제거되어, 이 메서드는 값을 네이티브에 저장만 할 뿐 더 이상
  /// 실제 타임아웃 동작(광고 show 후 close 미응답 시 자동 실패 처리)에
  /// 영향을 주지 않습니다. 기존 호출부가 깨지지 않도록 하위 호환을 위해
  /// API와 파라미터 검증 로직은 그대로 유지됩니다.
  ///
  /// [timeoutSeconds]가 0 이하(음수 포함)이면 네이티브로 전달하지 않고
  /// [ArgumentError]를 던집니다.
  @Deprecated(
    '네이티브 SDK에서 show 타임아웃 메커니즘이 제거되어 더 이상 효과 없음. '
    '값은 저장만 되고 실제 동작에 영향을 주지 않습니다.',
  )
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
    'onAdShowFail',
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
          case 'onAdShowFail':
            try {
              final adError = dataMap != null
                  ? LuckieverseAdError.fromMap(dataMap)
                  : const LuckieverseAdError(code: -1);
              callbacks.onAdShowFail?.call(adError);
            } catch (e, st) {
              _adLog('[showRVWithDynamicZoneID] onAdShowFail 콜백 예외: $e\n$st', warning: true);
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
  /// - [onAdShowFail]  : 광고 show 단계에서 실패했을 때 호출 ([LuckieverseAdError] 포함).
  ///
  /// **주의: [onAdShowFail]은 등록 여부에 따라 native 등록 자체가 조건부로 이뤄짐**
  /// [onAdShowFail]을 넘기지 않으면(`null`) native의 onAdShowFail 파라미터 자체가
  /// 등록되지 않는다. 이는 native(Android `AdManager.kt`)가 "host가 onShowFailAd를
  /// 등록하지 않으면 onLoadFailAd 폴백을 발화한다"는 하위 호환 설계를 갖고 있기 때문 —
  /// 무조건 등록해버리면 [onLoadFail]만 등록한 기존 호출부가 show 실패 통지를 아예
  /// 받지 못하는 회귀가 생긴다. 즉 [onAdShowFail]을 등록하지 않은 기존 호출부는
  /// show 실패 시 대신 [onLoadFail]이 발화된다(신규 동작이 아니라 native의 기존
  /// 폴백 설계가 그대로 보존되는 것).
  ///
  /// **lifecycle 콜백 (추가)**:
  /// - [onAdComplete]  : 보상 조건 달성(광고 완시청) 시 호출 ([LuckieverseAdInfo] 포함). onAdClose 이전에 발화.
  ///
  /// **주의: 콜백 매핑은 시간 기반으로 만료되지 않음**
  /// callId에 대한 콜백 매핑은 오직 native(안드로이드)로부터 terminal 콜백
  /// ([onLoadFail], [onAdNoFill], [onAdBlockUser], [onAdClose], [onAdShowFail])이
  /// 도착했을 때만 정리된다. native가 응답을 영영 주지 않는 극단적 케이스에서는
  /// 해당 콜백이 영원히 발화되지 않을 수 있다(호출 측에서 필요 시 자체 타임아웃을
  /// 구현해야 한다).
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
    void Function(LuckieverseAdError)? onAdShowFail,
  }) async {
    _adLog('[showRVWithDynamicZoneID] zoneID=$zoneID, isInitialized=$_isInitializeCompleted');
    _checkInitialization('showRVWithDynamicZoneID');

    final hasCallbacks = onLoadFail != null || onAdComplete != null ||
        onAdNoFill != null || onAdBlockUser != null ||
        onAdLoad != null || onAdShow != null || onAdClick != null ||
        onAdSkip != null || onAdClose != null || onAdShowFail != null;

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
        onAdShowFail: onAdShowFail,
      );
      _rvCallbacks[callId] = entry;
      _adLog('[showRVWithDynamicZoneID] callId=$callId 생성됨');
      try {
        await _invoke(
          'showRVWithDynamicZoneID',
          {
            'zoneID': zoneID,
            'callId': callId,
            // native의 onAdShowFail 파라미터를 호출자가 실제로 등록한 경우에만
            // 등록하기 위한 플래그. 무조건 등록하면 host가 onLoadFail만 등록한
            // 구버전 호출부에서 native의 onLoadFail 폴백 발화가 스킵되는 회귀가
            // 생긴다 (네이티브 AdManager.kt의 hostOnShowFailAd == null 폴백 설계 참고).
            'hasOnAdShowFail': onAdShowFail != null,
          },
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

  /// 반환값이 있는 네이티브 메서드 호출용. [_invoke]와 달리 native의 반환값을
  /// 그대로(dynamic) 돌려준다 — 타입 검증은 각 public getter에서 수행한다.
  static Future<dynamic> _invokeRaw(
    String method, [
    Map<String, dynamic>? arguments,
  ]) async {
    _log('[_invoke] method=$method, arguments=$arguments (반환값 기대)');
    try {
      final result = await _channel.invokeMethod(method, arguments);
      _log('[_invoke] $method 성공, result=$result');
      return result;
    } on PlatformException catch (e) {
      _log(
        '[_invoke] PlatformException 발생: code=${e.code}, message=${e.message}, details=${e.details}',
      );
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
  final void Function(LuckieverseAdError)? onAdShowFail;

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
    this.onAdShowFail,
  });
}
