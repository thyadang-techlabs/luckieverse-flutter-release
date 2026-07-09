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
