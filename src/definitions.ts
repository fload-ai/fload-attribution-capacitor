/**
 * What the SDK writes to the device log. It never logs the write key, Apple's
 * token, the Play referrer or a user id.
 */
export type FloadLogLevel = 'none' | 'error' | 'warning' | 'info' | 'debug';

export interface ConfigureOptions {
  /**
   * The app's public write key (`fload_pk_…`) from Fload. It names the app
   * only, so it is safe to ship in the app.
   */
  key: string;
  /**
   * Fload's ingest endpoint. Change it only to test against your own Fload API.
   *
   * @default "https://ingest.fload.com"
   */
  endpoint?: string;
  /**
   * @default "warning"
   */
  logLevel?: FloadLogLevel;
}

export interface SetUserIdOptions {
  /**
   * Your app's user id, for example RevenueCat's `appUserID`.
   * Trimmed; 1 to 256 characters.
   */
  id: string;
}

export interface InstallReferenceResult {
  /**
   * This install's random reference, or null before `configure` has loaded
   * the SDK's state. Useful when asking Fload support about one install.
   */
  installReference: string | null;
}

export interface FloadAttributionPlugin {
  /**
   * Starts the SDK. Call it once, early in launch. It returns at once; the
   * native SDK does its disk and network work in the background.
   *
   * On iOS it wraps `Fload.configure(key:options:)` from
   * fload-attribution-ios, on Android `Fload.configure(context, key, options)`
   * from fload-attribution-android. In a browser it does nothing.
   */
  configure(options: ConfigureOptions): Promise<void>;

  /**
   * Links your app's user id to this install. Optional. Safe to call before
   * `configure` and on every launch: the same id is sent once.
   */
  setUserId(options: SetUserIdOptions): Promise<void>;

  /**
   * This install's random reference.
   */
  getInstallReference(): Promise<InstallReferenceResult>;
}
