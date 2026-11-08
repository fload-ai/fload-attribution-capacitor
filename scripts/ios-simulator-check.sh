#!/bin/sh
# The iOS half of the plugin on a simulator, against the local stub ingest:
#   1. the plugin's XCTest (argument rules) through Swift Package Manager,
#   2. the example app built with SPM, installed fresh, launched, and what the
#      stub received checked: one accepted install from the Swift SDK naming this
#      plugin and its version (sdk.wrapper), user id linked.
# Needs Xcode with an iOS simulator, Node and npm. Shuts down the simulator if
# it booted it. Usage: sh scripts/ios-simulator-check.sh   (FLOAD_SIM_UDID=… to pick one)
set -eu
cd "$(dirname "$0")/.."
root="$PWD"
work="$(mktemp -d)"
stub_script="$root/scripts/stub-ingest.mjs"
. "$root/scripts/sim-common.sh"
trap 'finish; rm -rf "$work"' EXIT

sim_boot
stub_start 3999
dest="platform=iOS Simulator,id=$udid"

echo "== plugin XCTest (SPM)"
# Xcode names the all-targets scheme of a package "<name>-Package" when it has one.
scheme=FloadAiAttributionCapacitor
xcodebuild -list 2>/dev/null | grep -q "FloadAiAttributionCapacitor-Package" && scheme=FloadAiAttributionCapacitor-Package
run_logged plugin-xctest xcodebuild test -scheme "$scheme" -destination "$dest" -derivedDataPath "$work/dd-plugin"

echo "== example app"
run_logged plugin-npm-ci npm ci --no-audit --no-fund
run_logged plugin-js-build npm run build
cd example-app
run_logged example-npm-ci npm ci --no-audit --no-fund
run_logged example-web-build npm run build
run_logged cap-sync-ios npx cap sync ios
run_logged example-xcodebuild xcodebuild -project ios/App/App.xcodeproj -scheme App -configuration Debug \
  -destination "$dest" -derivedDataPath "$work/dd-app" CODE_SIGNING_ALLOWED=NO build
app="$(find "$work/dd-app/Build/Products" -maxdepth 2 -name 'App.app' -type d | head -1)"
bundle="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$app/Info.plist")"
xcrun simctl uninstall "$udid" "$bundle" 2>/dev/null || true   # a fresh install, so a first launch
xcrun simctl install "$udid" "$app"
xcrun simctl launch "$udid" "$bundle"
if ! stub_wait_install "$bundle" 60; then echo "FAIL no install reached the stub in 60 s"; cat "$work/stub.log"; exit 1; fi
sleep 5   # the identify, if the user id came after the install
stub_assert "$bundle" "example-user-1" "$(node -p "require('$root/package.json').floadNative.ios")" \
  capacitor "$(node -p "require('$root/package.json').version")"
xcrun simctl terminate "$udid" "$bundle" || true
xcrun simctl uninstall "$udid" "$bundle" || true
echo "stub log:"; cat "$work/stub.log"
