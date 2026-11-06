import type { ConfigureOptions, FloadLogLevel, SetUserIdOptions } from './definitions';

const LOG_LEVELS: readonly FloadLogLevel[] = ['none', 'error', 'warning', 'info', 'debug'];

/** The same argument checks the native halves make, so the web behaves alike. */
export function validateConfigure(options: ConfigureOptions | undefined): void {
  if (!options || typeof options.key !== 'string' || options.key.trim() === '') {
    throw new Error('Fload: configure needs { key: "fload_pk_…" }');
  }
  if (options.endpoint !== undefined && typeof options.endpoint !== 'string') {
    throw new Error('Fload: endpoint must be a URL string');
  }
  if (options.logLevel !== undefined && !LOG_LEVELS.includes(options.logLevel)) {
    throw new Error(`Fload: logLevel must be one of ${LOG_LEVELS.join(', ')}`);
  }
}

export function validateSetUserId(options: SetUserIdOptions | undefined): void {
  if (!options || typeof options.id !== 'string') {
    throw new Error('Fload: setUserId needs { id: "…" }');
  }
}
