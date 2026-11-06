# Fload Attribution for Capacitor

Counts your app's installs in Fload and attributes them: to Apple Ads through
Apple's AdServices token on iOS, and to the Google Play Install Referrer on
Android. No IDFA, no advertising ID, no App Tracking Transparency prompt, no
events.

This plugin is a thin bridge over Fload's native SDKs,
[fload-attribution-ios](https://github.com/fload-ai/fload-attribution-ios) and
[fload-attribution-android](https://github.com/fload-ai/fload-attribution-android).
Everything they do (the offline queue, retries, what is sent) is described in
their READMEs.

Capacitor 8 or later. iOS 15 or later, Android 7 (API 24) or later.

## Install

```sh
npm install @fload-ai/attribution-capacitor
npx cap sync
```

**iOS.** With Swift Package Manager (the default for new Capacitor apps), `cap
sync` adds the plugin, and the plugin pulls in
`github.com/fload-ai/fload-attribution-ios`. With CocoaPods, the plugin's pod
carries a copy of the same Swift sources (the iOS SDK is not on the CocoaPods
trunk, which turns read-only on 2 December 2026). Either way your app's iOS
deployment target must be 15.0 or later.

**Android.** The Kotlin SDK comes from [JitPack](https://jitpack.io). The plugin
adds the JitPack repository (for the `com.github.fload-ai` group only) to your
Gradle build. If your `android/settings.gradle` sets
`repositoriesMode = RepositoriesMode.FAIL_ON_PROJECT_REPOS`, add it there yourself:

```groovy
dependencyResolutionManagement {
    repositories {
        google()
        mavenCentral()
        maven { url 'https://jitpack.io'; content { includeGroup 'com.github.fload-ai' } }
    }
}
```

## Use

```ts
import { FloadAttribution } from '@fload-ai/attribution-capacitor';

// Once, early in launch:
await FloadAttribution.configure({ key: 'fload_pk_…' });

// Optional: link your user id (e.g. RevenueCat's appUserID) to the install.
const { appUserID } = await Purchases.getAppUserID();
await FloadAttribution.setUserId({ id: appUserID });
```

The key is your app's public write key from Fload. It can only report installs
for that one app, so it is safe to ship in the app.

| Call | What it does |
| --- | --- |
| `configure({ key, endpoint?, logLevel? })` | Starts the SDK. Returns at once; the native SDK works in the background. A second call is ignored. |
| `setUserId({ id })` | Links your user id to this install. Safe before `configure` and on every launch; each id is sent once. |
| `getInstallReference()` | `{ installReference }`: this install's random id, or `null` until the SDK has loaded. For support questions. |

`endpoint` is for testing against your own server; `logLevel` is one of `none`,
`error`, `warning` (the default), `info`, `debug`. The SDKs never log the key,
Apple's token, the referrer or a user id.

In a browser (`npx cap serve`, or the web build) the calls check their
arguments and do nothing else.

## Privacy

What the SDK collects and how to answer Apple's privacy questions and Google
Play's Data safety form: see the
[iOS](https://github.com/fload-ai/fload-attribution-ios#privacy) and
[Android](https://github.com/fload-ai/fload-attribution-android#google-play-data-safety)
READMEs. The iOS SDK ships its `PrivacyInfo.xcprivacy`.

## Example app

`example-app/` sends to a local stub of Fload's ingest, never to production:

```sh
npm install && npm run build
npm run stub-ingest                 # terminal 1: listens on :3999
cd example-app && npm install && npm run build && npx cap sync
npx cap run android                 # or: npx cap run ios
curl -s localhost:3999/__requests   # what the stub received
```

The Android emulator reaches your machine at `10.0.2.2`, the iOS simulator at
`localhost`. The example allows plain `http` to those two hosts only.

## Development

- `npm run build`: TypeScript and the bundles.
- `npm test`: the iOS argument checks on the host (`swiftc`, no Xcode needed)
  and the Android unit tests.
- `npm run check:vendor`: the CocoaPods copy of the Swift SDK in `ios/Vendor`
  matches the pinned `fload-attribution-ios` tag byte for byte.
  `npm run vendor` refreshes it.

## License

MIT. See [LICENSE](LICENSE).
