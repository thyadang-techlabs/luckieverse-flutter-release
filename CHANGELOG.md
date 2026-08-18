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
