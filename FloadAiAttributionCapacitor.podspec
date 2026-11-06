require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

# CocoaPods path. The CocoaPods trunk turns read-only on 2 December 2026, so
# fload-attribution-ios is not a pod: its sources are vendored into this pod
# (ios/Vendor, copied from the tagged release by scripts/vendor-ios-sdk.mjs and
# checked byte for byte by `npm run check:vendor`). Swift Package Manager apps
# get the same sources from github.com/fload-ai/fload-attribution-ios instead.
Pod::Spec.new do |s|
  s.name = 'FloadAiAttributionCapacitor'
  s.version = package['version']
  s.summary = package['description']
  s.license = package['license']
  s.homepage = 'https://github.com/fload-ai/fload-attribution-capacitor'
  s.author = package['author']
  s.source = { :git => 'https://github.com/fload-ai/fload-attribution-capacitor.git', :tag => s.version.to_s }
  s.source_files = 'ios/Sources/**/*.swift', 'ios/Vendor/FloadAttribution/**/*.swift'
  s.resource_bundles = { 'FloadAttribution_Privacy' => ['ios/Vendor/FloadAttribution/Resources/PrivacyInfo.xcprivacy'] }
  s.frameworks = 'Foundation', 'Network', 'CryptoKit'
  s.weak_frameworks = 'AdServices'
  s.ios.deployment_target = '15.0'
  s.dependency 'Capacitor'
  s.swift_version = '5.9'
end
