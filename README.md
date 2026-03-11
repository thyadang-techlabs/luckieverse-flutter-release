# Luckieverse Flutter SDK

Luckieverse Flutter 플러그인 배포 패키지입니다.

## 설치

`pubspec.yaml`에 다음을 추가하세요:

```yaml
dependencies:
  luckieverse_flutter:
    git:
      url: <THIS_REPO_URL>
      ref: v1.0.1
```

그런 다음 실행:

```bash
flutter pub get
```

### 플랫폼별 설정

iOS, Android 모두 별도 설정 없이 사용 가능합니다.
네이티브 의존성은 자동으로 해결됩니다.

## 사용법

```dart
import 'package:luckieverse_flutter/luckieverse_flutter.dart';

// 초기화
await LuckieverseFlutter.initialize();

// 사용자 ID 설정
await LuckieverseFlutter.updateUserId('user123');

// 메인 화면 열기
await LuckieverseFlutter.openLuckieverseMain();
```

## 버전

현재 버전: **v1.0.1**
