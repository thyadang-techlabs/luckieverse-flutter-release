## 2.3.0

* 네이티브 SDK(Android v2.1.25 / iOS Luckieverse 2.8.2)가 노출하는 공개 API 중 브릿지에 없던 항목을 대거 추가. 기존 17개 API의 시그니처/동작은 변경하지 않음(순수 추가, minor 버전업).
* **공통(Android/iOS)**:
  * `getSdkVersion()` / `setSdkVersion(version)`
  * `updateGameAppKey(appKey)`, `enableBannerDebug(enable)`, `enableFullScreenAdFailForTest(enable)`
  * 화면 오픈 API 12종: `openLuckieverseMyPage`, `openLuckieverseSajuInfo`, `openLuckieversePhoneAuth`, `openLuckieversePointHistory`, `openLuckieverseProductHistory`, `openLuckieverseProductHistoryDetail(id)`, `openLuckieverseFaq`, `openLuckieverseFaqDetail({id})`, `openLuckieverseInquiry`, `openLuckieverseInquiryHistory`, `openLuckieverseInquiryHistoryDetail(id)`, `openLuckieverseTermsAndPolicies`, `openLuckieverseTermsAndPoliciesDetail({id})`, `openLuckieverseProductStore`, `openLuckieverseProductStoreDetail`, `openLuckieverseError`
  * `openFaceReading()`, `checkGoogleAdmobWebviewAPI()`, `openEmail({toAddress})`(Android `openEmail`/iOS `openEmailApp` 통합), `openLuckieverseGame()`, `openLuckieverseGameByPush(pushKey)`
  * **플랫폼 비대칭 주의**: `openLuckieverseFaqDetail`/`openLuckieverseTermsAndPoliciesDetail`은 iOS 네이티브만 `id`가 필수이고 Android 네이티브는 `id`를 받지 않는다. Dart에서는 `id`를 optional named 파라미터로 두고, iOS에서 생략 시 `ArgumentError`를 던진다.
  * `showRVWithDynamicZoneID`에 `onAdShowFail` 콜백 파라미터 추가. 광고 show 단계 실패를 알리는 terminal 콜백이며, Android/iOS 네이티브 모두 대응 파라미터가 이미 존재함을 확인 후 배선. **하위 호환은 네이티브에 등록 여부를 조건부로 전달하는 방식으로 보장**한다 — Dart에서 `onAdShowFail`을 지정하지 않으면 native에는 아예 등록하지 않는다(무조건 등록하면, 네이티브 `AdManager.kt`가 "host가 onShowFailAd를 등록하지 않았을 때만 onLoadFailAd 폴백을 발화"하도록 설계되어 있어, 기존에 `onLoadFail`만 등록한 호출부가 show 실패를 아예 통지받지 못하는 조용한 회귀가 발생함을 확인했고 이를 수정함).
* **Android 전용** (iOS 네이티브에 대응 API가 없어 호출 시 `UnsupportedError`):
  * `getAdLoadTimeout()`, `getShowLoadTimeout()`(iOS는 setter만 존재, getter 없음)
  * 광고 존 아이디 개별 setter/getter 12종: `set/getFullScreenAdZoneIdForSaju|ForNotSaju|ForFortuneCookie`, `set/getBannerAdZoneIdForSaju|ForNotSaju|ForFortuneCookie` (setter들은 네이티브에서 이미 `@Deprecated`로 no-op 처리되어 Dart 측도 동일하게 `@Deprecated` 표시)
  * `getShouldExposeContent()`, `getSDKInfo()`(nullable), `getContentLandingUrl(contentsId)`(네이티브 suspend 함수를 코루틴 없이 `kotlin.coroutines.startCoroutine`으로 브릿징). ⚠️ **`getContentLandingUrl`은 네이티브 SDK가 개발 서버(`luckybite-dev.adop.co.kr`)를 하드코딩하고 있음을 확인**했다(네이티브 주석에 "실제 API 서버 주소로 변경 필요"라고 명시됨). 호출 시 앱 키/사용자 ID가 이 개발 서버로 전송되므로, 네이티브 SDK가 프로덕션 서버로 전환되기 전까지 프로덕션 앱에서 사용하지 말 것 — Dart doc과 `GUIDE.md`에 경고 추가. 또한 네이티브 `NetworkManager.post`가 네트워크 실패 시에도 예외를 삼키고 빈 문자열을 반환하는 것을 확인해, Dart 측에서 빈 문자열 응답을 `Exception`으로 변환하도록 처리.
* **iOS 전용** (Android 네이티브에 대응 API가 없어 호출 시 `UnsupportedError`):
  * `setConsumableFullscreenZoneIds(zoneIds)` / `setConsumableBannerZoneIds(zoneIds)` — iOS는 Android처럼 개별 setter가 아니라 배열 기반 API라 1:1로 합치지 않고 별도로 노출.
  * `updateBannerHeightLimit(height)`, `updateWebviewInspector(enabled)`
  * `showFloatingButton()` / `hideFloatingButton()` — iOS 네이티브에서 현재 최상단 `UIViewController`를 자동으로 획득해 전달.
  * `setLuckieverseLocalPush(LuckieverseLocalPush)` / `cancelLuckieverseLocalPush(LuckieverseLocalPushType)` — Android는 네이티브 SDK에서 해당 기능이 주석 처리되어 비활성화 상태라 iOS 전용으로만 구현. `LuckieverseLocalPush`/`LuckieverseLocalPushType` Dart 모델 신설(`soundName` 생략 시 iOS 기본 알림음 사용).
* **구현하지 않음**: iOS `makeUIViewController`/`updateUIViewController`/`getCurrentViewController`(SwiftUI 내부 구현용), Android `createFloatingButtonXML`/`createFloatingButtonCompose`·iOS `setFloatingButton(viewController:show:)`(네이티브 View 객체 반환/요구, PlatformView 없이 브릿징 불가), iOS `setGoToSettingObjc`/`setGoToSettingSwift`(이미 `setGoToSettingCallback`으로 노출됨), Android `instance()` 및 `internal` 함수 전부.
* `test/luckieverse_flutter_test.dart`에 신규 API 전체에 대한 단위 테스트 40개 추가(기존 12개 유지, 총 52개). 플랫폼 분기(`defaultTargetPlatform` override), 반환값 타입 불일치, native 실패, 플랫폼 비대칭 `ArgumentError`, 이모지/빈 문자열 등 엣지 케이스 포함.
* 검수 후속 조치 (위험도 높음/중간):
  * `android/build.gradle`에 `kotlinx-coroutines-android:1.7.1`을 명시적으로 선언. `libs/luckieverse.jar`가 raw jar 의존이라 전이 의존성이 해석되지 않는데, 네이티브 `NetworkManager`가 `kotlinx.coroutines`(`withContext(Dispatchers.IO)`)를 사용함에도 불구하고 `kotlinx-coroutines-android`는 Flutter 임베딩 경로로 우연히 딸려오는 전이 의존성으로만 classpath에 있었음을 확인. Flutter 임베딩 구성 변경 시 `NoClassDefFoundError`로 조용히 깨질 수 있어 명시 선언으로 고정.
  * iOS `showFloatingButton`에서 `@MainActor`로 격리된 네이티브 `getCurrentViewController(base:)`를 non-isolated 컨텍스트에서 동기 호출하던 부분을 `MainActor.assumeIsolated`로 명시적으로 감쌈. 현재는 Flutter 채널 핸들러가 항상 메인 스레드에서 호출되어 크래시가 없었지만, Swift 6 strict concurrency 전환 시 컴파일 에러가 되는 문제를 예방하고 의도를 코드에 드러냄.
  * Android `getContentLandingUrl` 브릿지 로그에서 `contentsId`/`url` 값 자체를 제거(호출/성공 사실만 로깅). `consumer-rules.pro`가 비어 있어 release 빌드에서도 로그가 스트립되지 않아 값이 그대로 남는 문제였음.
  * `openEmail`의 `toAddress`에 개행(`\r`, `\n`) 등 제어문자가 포함되면 `ArgumentError`를 던지도록 검증 추가(메일 헤더 인젝션 방지).

## 2.2.2

* Android 네이티브 SDK를 v2.1.24 → v2.1.25로 갱신. `sdk_spec.txt`와 `Luckieverse` 클래스 구현부만 변경되었으며 공개 API 시그니처는 동일하므로 Kotlin/Dart 측 코드 변경 없음.
  * **BREAKING**: 호스트 앱의 Kotlin 컴파일러 최소 버전이 2.2.20으로 상향. Luckieverse 2.1.25가 Kotlin 2.3.21로 컴파일되어, 그보다 낮은 Kotlin(예: 2.1.0)은 metadata(2.3.0)를 읽지 못해 `compileDebugKotlin`이 즉시 실패함을 `example/android`에서 실제 빌드로 확인. `example/android/settings.gradle.kts`의 `org.jetbrains.kotlin.android`를 `2.1.0` → `2.2.20`으로 상향해 조치.
  * **BREAKING**: `android/build.gradle`의 `compileSdk`/`targetSdk`를 `34` → `36`으로 상향. 네이티브 SDK 원본(LuckyBiteAOS)이 compileSdk 36/targetSdk 36으로 빌드되는 것에 맞춘 정합화 결정. `minSdk`는 23으로 그대로 유지되어 소비자 앱의 최소 지원 기기 범위는 변하지 않지만, **호스트 앱의 compileSdk도 36 이상으로 올려야** 한다(그렇지 않으면 AGP가 "Dependency ... requires compileSdk 36" 오류를 냄). `example/android`의 `:luckieverse_flutter:assembleDebug`와 `:app:assembleDebug` 모두 실제 빌드 성공으로 검증(이후 `example/android/app/build.gradle.kts`의 `compileSdk`/`targetSdk`는 Flutter SDK 버전에 대한 종속을 없애기 위해 `36`으로 직접 명시하도록 추가 정합화됨 — 아래 "문서/example 정합화" 참고).
  * `android/build.gradle`의 `buildToolsVersion` 명시(`33.0.2`)를 제거하고 AGP 기본값에 맡기도록 변경. AGP 8.7.3에서 33.0.2/34.0.0 등 낮은 명시값은 어차피 조용히 대체되고 있었음을 확인했고, compileSdk 상향 때마다 buildToolsVersion을 함께 관리해야 하는 부담을 없애기 위함.
* iOS 네이티브 SDK Luckieverse 2.8.2 기준으로 podspec을 정합화.
  * **BREAKING**: iOS 최소 지원 버전을 13.0 → 14.0으로 상향. Luckieverse 2.8.2 및 BidmadSDK 7.0.1이 iOS 14.0을 요구함에 따른 변경.
  * `luckieverse_flutter.podspec`의 `Luckieverse` 의존성을 `2.8.2`로 명시 핀. 버전 미지정 시 CocoaPods가 iOS 14.0 요구조건을 충족하지 못해 2.7.2로 조용히 다운그레이드 해석하던 문제를 수정.
  * `example/ios/Podfile`의 광고 어댑터 pod를 BidmadSDK 7.0.1과 짝을 이루는 버전(`-ForLuckieverse` 접미사 없는 정식 배포명, 예: `BidmadAdpieAdapter 1.6.16.14.1`)으로 갱신. `pod install` 실행으로 의존성 해석 성공 및 `Luckieverse`가 2.8.2로 정상 고정됨을 확인.
* 문서/example 정합화 (기능 변경 없음, 코드 동작에는 영향 없음):
  * `README_DEVELOPER_GUIDE.md`: Android 요구사항 중 "Gradle 7.0 이상 / AGP 7.0 이상"이 compileSdk 36 요구사항과 모순되던 것(AGP 7.0은 API 36을 인식하지 못함)을 수정. `example/android`에서 실제 빌드 성공이 검증된 조합인 Gradle 8.12 / AGP 8.7.3 기준으로 갱신하고, 이 값이 실측 검증된 하한임을 명시. 그보다 낮은 하한은 미검증.
  * `README_DEVELOPER_GUIDE.md`: iOS 요구사항 중 근거 없이 적혀 있던 "Xcode 15.0 이상"을 제거. `Luckieverse.xcframework`가 Xcode 26.6(Swift 6.3.3)으로 빌드되었고 `.swiftinterface`에 Swift 6.3 기능 플래그가 포함되어 있다는 실측 사실 기반 서술로 교체. 정확한 호환 하한 Xcode 버전은 구버전 설치 환경이 없어 미검증.
  * `example/android/app/build.gradle.kts`: `compileSdk`/`targetSdk`를 `flutter.compileSdkVersion`/`flutter.targetSdkVersion`(Flutter SDK 버전에 종속) 대신 `36`으로 직접 명시. `pubspec.yaml`의 `flutter: ">=1.17.0"` 제약상 구버전 Flutter(기본 compileSdk 34/35) 환경에서는 이 값이 36 미만이 되어 "Dependency ... requires compileSdk 36" 빌드 실패가 재현되지 않고 넘어갈 수 있었음. `flutter build apk --debug`로 빌드 성공 재검증.
  * `GUIDE.md`, `README_DEVELOPER_GUIDE.md`: 호스트 앱의 `android/app/build.gradle`에 `compileSdk`/`targetSdk`를 직접 36으로 명시하라는 안내 추가. Flutter 기본값에만 의존하면 Flutter 버전에 따라 빌드가 깨질 수 있음을 명시.
  * `GUIDE.md`: iOS 어댑터 목록(AppLovin/Fyber/GoogleAdManager/GoogleAdMob/Pangle/Partners)이 `example/ios/Podfile`(Adpie/GoogleAdManager/GoogleAdMob/Pangle/Vungle/Partners/UnityAds/AppLovin)과 다른 것에 대해, 이 목록이 전체 어댑터가 아니라 일부 예시이며 프로젝트에 필요한 네트워크만 선택해 추가하면 된다는 안내를 추가. 기존 "예시이므로 그대로 복사하지 말고 테크랩스 개발자로부터 전달받은 PDF의 어댑터를 사용하라"는 문구는 유지.
  * 유지보수 참고: `ios/luckieverse_flutter.podspec`의 `Luckieverse` 네이티브 SDK 의존성은 `2.8.2`로 다운그레이드 방지 목적의 하드 핀이 유지된다. 이후 네이티브 SDK 패치(예: 2.8.3)가 나오더라도 이 핀을 올려 이 플러그인을 재배포하기 전까지는 소비자가 해당 패치를 받을 수 없으므로, 네이티브 패치 시 이 podspec 버전업이 필요하다는 점에 유의할 것.

## 2.1.6

* `setAdShowTimeout`: 네이티브 SDK(Android/iOS)에서 show 타임아웃 안전장치가 완전히 제거됨에 따라 `@Deprecated`로 표시. API 시그니처, 파라미터 검증(`timeoutSeconds <= 0` 시 `ArgumentError`), 네이티브 호출은 하위 호환을 위해 그대로 유지되지만, 더 이상 실제 타임아웃 동작에는 영향을 주지 않음. `setAdLoadTimeout`(로드 타임아웃)은 영향 없이 정상 동작.

## 2.1.5

* **BREAKING**: `setAdLoadTimeout`/`setAdShowTimeout`의 파라미터 타입을 `Duration`에서 `int timeoutSeconds`(초 단위)로 변경. Android(LuckyBiteAOS v2.1.9+)/iOS(LuckyVerseiOS) 네이티브 SDK의 공개 타임아웃 API가 이미 초 단위로 통일된 데 맞춘 변경.
* `timeoutSeconds`가 0 이하(음수 포함)이면 `ArgumentError`를 던지는 검증 추가.

## 0.1.2

* `showRVWithDynamicZoneID`: callId 콜백 매핑을 강제 만료시키던 5분 TTL 타이머를 완전히 제거. 이제 콜백은 오직 native(안드로이드)로부터 실제 응답이 도착했을 때만 발화되며, 시간 경과에 따른 합성 `onLoadFail(-998)` 통지는 더 이상 발생하지 않음 (native가 응답을 영영 주지 않는 극단적 케이스에서는 콜백이 발화되지 않을 수 있음 — 필요 시 호출 측에서 자체 타임아웃 구현 필요).
* native invoke(`_invoke`) 실패 시의 합성 `onLoadFail(-999)` 통지는 TTL과 무관하므로 그대로 유지.

## 0.1.1

* `showRVWithDynamicZoneID`: native invoke 실패 시 `onLoadFail` 콜백이 등록되어 있으면 예외를 rethrow하지 않고 콜백으로만 전달하도록 변경 (이전엔 항상 rethrow).
* Android: RV 콜백 이벤트 전달을 `Activity.runOnUiThread` 대신 `Handler(Looper.getMainLooper())`로 변경해, 화면 회전 등으로 Activity가 재생성/소멸될 때 발생할 수 있는 참조 누수 및 크래시 위험을 제거.
* TTL(5분) 만료 및 native invoke 실패 시 `onLoadFail` 합성 에러(-998/-999) 통지, `onAdComplete` 발화 여부에 따른 재통지 방지 로직 추가.
* release 빌드에서도 남는 광고 흐름 진단 로그(`_adLog`) 추가.

## 0.0.1

* TODO: Describe initial release.
