#!/bin/sh
# Compiles the plugin's Capacitor-free Swift (argument rules) with the vendored
# Swift SDK for the host Mac and runs ios/HostTests. Needs only a Swift toolchain.
set -eu
cd "$(dirname "$0")/.."
out="$(mktemp -d)"
trap 'rm -rf "$out"' EXIT
swiftc -O -module-name FloadAttributionPlugin \
  ios/Vendor/FloadAttribution/*.swift \
  ios/Sources/FloadAttributionPlugin/PluginArguments.swift \
  ios/HostTests/main.swift \
  -o "$out/host-tests"
"$out/host-tests"
