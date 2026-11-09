Pod::Spec.new do |s|
  s.name             = 'luckieverse_flutter'
  s.version          = '2.5.1'
  s.summary          = 'Luckieverse Flutter plugin'
  s.description      = <<-DESC
A Flutter plugin wrapper for the Luckieverse native SDKs.
  DESC
  s.homepage         = 'https://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Luckieverse' => 'dev@luckieverse.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.module_name = 'luckieverse_flutter'
  s.dependency 'Flutter'
  s.dependency 'Luckieverse', '2.9.2'
  # Luckieverse 2.9.1~2.9.2는 아래 Bidmad 의존성을 고정하지 않는다. 검증된 범위(>= 7.0.1, < 7.1.0,
  # 호스트 어댑터 핀과 동일)를 벗어나 7.1.0 이상으로 해석되지 않도록 플러그인에서 제한한다.
  s.dependency 'BidmadSDK', '~> 7.0.1'
  s.dependency 'OpenBiddingHelper', '~> 7.0.1'
  s.dependency 'BidmadGoogleGDPRAdapter', '~> 7.0.1'

  # NOTE: Ad network adapters are NOT declared here on purpose.
  # Add them in the host app's Podfile instead.
  s.platform = :ios, '15.0'
  s.swift_version = '5.0'

  # Ensure static linking for faster builds
  s.static_framework = true
end
