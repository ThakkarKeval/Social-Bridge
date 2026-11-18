#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint social_bridge.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'social_bridge'
  s.version          = '0.1.0'
  s.summary          = 'A modern social authentication Flutter plugin supporting Google and Apple sign-in.'
  s.description      = <<-DESC
A modern social authentication Flutter plugin supporting Google and Apple sign-in.
                       DESC
  s.homepage         = 'https://github.com/ThakkarKeval/Social-Bridge'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }

  s.source           = { :path => '.' }
  s.source_files = 'social_bridge/Sources/social_bridge/**/*'

  # If your plugin requires a privacy manifest, for example if it collects user
  # data, update the PrivacyInfo.xcprivacy file to describe your plugin's
  # privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'social_bridge_privacy' => ['social_bridge/Sources/social_bridge/PrivacyInfo.xcprivacy']}

  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
