import { registerPlugin } from '@capacitor/core';

import type { FloadAttributionPlugin } from './definitions';

const FloadAttribution = registerPlugin<FloadAttributionPlugin>('FloadAttribution', {
  web: () => import('./web').then((m) => new m.FloadAttributionWeb()),
});

export * from './definitions';
export { FloadAttribution };
