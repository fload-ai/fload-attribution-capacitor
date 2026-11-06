import { WebPlugin } from '@capacitor/core';

import type { ConfigureOptions, FloadAttributionPlugin, InstallReferenceResult, SetUserIdOptions } from './definitions';
import { validateConfigure, validateSetUserId } from './validate';

/**
 * In a browser there is no store install to attribute, so the plugin checks
 * its arguments and does nothing else.
 */
export class FloadAttributionWeb extends WebPlugin implements FloadAttributionPlugin {
  private warned = false;

  async configure(options: ConfigureOptions): Promise<void> {
    validateConfigure(options);
    if (!this.warned) {
      this.warned = true;
      console.info('Fload: attribution runs only in the iOS and Android apps; nothing is sent from the web.');
    }
  }

  async setUserId(options: SetUserIdOptions): Promise<void> {
    validateSetUserId(options);
  }

  async getInstallReference(): Promise<InstallReferenceResult> {
    return { installReference: null };
  }
}
