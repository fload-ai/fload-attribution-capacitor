#!/bin/sh
# The Android half of the plugin on an emulator, against the local stub ingest:
# the example app built (the plugin from this checkout, the Kotlin SDK from
# JitPack), installed fresh, launched, and what the stub received checked: one
# accepted install from the Kotlin SDK with the Play referrer, user id linked.
# Needs JDK 21, the Android SDK (ANDROID_HOME, adb), one emulator online, Node and npm.
# Usage: sh scripts/android-emulator-check.sh
set -eu
cd "$(dirname "$0")/.."
root="$PWD"
work="$(mktemp -d)"
stub_script="$root/scripts/stub-ingest.mjs"
. "$root/scripts/sim-common.sh"
. "$root/scripts/emulator-common.sh"
trap 'finish; rm -rf "$work"' EXIT

adb_ready
stub_start 3999

run_logged plugin-npm-ci npm ci --no-audit --no-fund
run_logged plugin-js-build npm run build
cd example-app
run_logged example-npm-ci npm ci --no-audit --no-fund
run_logged example-web-build npm run build
run_logged cap-sync-android npx cap sync android
cd android
echo "sdk.dir=$ANDROID_HOME" > local.properties
run_logged gradle-assembleDebug ./gradlew --no-daemon assembleDebug
apk="app/build/outputs/apk/debug/app-debug.apk"
package="$(node -p "require('../capacitor.config.json').appId")"
apk_fresh_launch "$apk" "$package"
if ! stub_wait_install "$package" 90; then echo "FAIL no install reached the stub in 90 s"; cat "$work/stub.log"; adb logcat -d -s FloadAttribution:V Capacitor:V | tail -40; exit 1; fi
sleep 5   # the identify, if the user id came after the install
stub_assert_android "$package" "example-user-1"
adb shell am force-stop "$package" || true
adb uninstall "$package" >/dev/null 2>&1 || true
echo "stub log:"; cat "$work/stub.log"
