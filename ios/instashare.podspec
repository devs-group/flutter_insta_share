#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint instashare.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'instashare'
  s.version          = '0.0.5'
  s.summary          = 'Share easily and directly to Instagram.'
  s.description      = <<-DESC
  Share easily and directly to Instagram.
                       DESC
  s.homepage         = 'https://devs-group.ch'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'devs group' => 'info@devs-group.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
