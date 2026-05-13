Pod::Spec.new do |s|
  s.name             = 'luckieverse_flutter'
  s.version          = '2.0.1'
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
  s.dependency 'Luckieverse'

  # NOTE: Ad network adapters are NOT declared here on purpose.
  # Add them in the host app's Podfile instead.
  s.platform = :ios, '13.0'
  s.swift_version = '5.0'

  # Ensure static linking for faster builds
  s.static_framework = true
end
