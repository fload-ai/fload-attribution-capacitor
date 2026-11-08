# Changelog

## 1.1.0 (2026-11-08)

- Native SDKs 1.1.0; installs name this wrapper (FLO-3957). Every request now
  carries `sdk.wrapper` `{ name: "capacitor", version: "1.1.0" }`. An app that
  pins the Android SDK through `floadAttributionAndroidVersion` needs 1.1.0 or later.
- Upgrading from 1.0.x: if you set `floadAttributionAndroidVersion` to a 1.0.x
  version, drop that override (or set 1.1.0); the build fails against the 1.0.x
  Android SDK.

## 1.0.0 (2026-11-06)

- First release. Wraps fload-attribution-ios 1.0.2 and fload-attribution-android 1.0.2:
  configure, setUserId and the install reference.
