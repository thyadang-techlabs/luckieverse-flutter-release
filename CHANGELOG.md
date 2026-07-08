## 0.1.1

* `showRVWithDynamicZoneID`: native invoke 실패 시 `onLoadFail` 콜백이 등록되어 있으면 예외를 rethrow하지 않고 콜백으로만 전달하도록 변경 (이전엔 항상 rethrow).
* Android: RV 콜백 이벤트 전달을 `Activity.runOnUiThread` 대신 `Handler(Looper.getMainLooper())`로 변경해, 화면 회전 등으로 Activity가 재생성/소멸될 때 발생할 수 있는 참조 누수 및 크래시 위험을 제거.
* TTL(5분) 만료 및 native invoke 실패 시 `onLoadFail` 합성 에러(-998/-999) 통지, `onAdComplete` 발화 여부에 따른 재통지 방지 로직 추가.
* release 빌드에서도 남는 광고 흐름 진단 로그(`_adLog`) 추가.

## 0.0.1

* TODO: Describe initial release.
