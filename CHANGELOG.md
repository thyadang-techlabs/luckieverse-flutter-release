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
