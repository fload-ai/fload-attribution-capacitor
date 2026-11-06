import { WebPlugin } from '@capacitor/core';

import type { FloadAttributionPlugin } from './definitions';

export class FloadAttributionWeb extends WebPlugin implements FloadAttributionPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
  }
}
