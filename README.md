# Luckieverse Flutter SDK

Luckieverse Flutter 플러그인 배포 패키지입니다.

## 설치

`pubspec.yaml`에 다음을 추가하세요:

```yaml
dependencies:
  luckieverse_flutter:
    git:
      url: https://github.com/thyadang-techlabs/luckieverse-flutter-release.git
```

그런 다음 실행:

```bash
flutter pub get
```

### iOS 추가 설정

iOS 디렉토리에서 `pod install`을 진행하십시오.

### Android 추가 설정

별도 설정 없이 사용 가능합니다. AAR이 패키지에 포함되어 있습니다.

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

현재 버전: **v1.0.0**
