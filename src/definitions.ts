export interface FloadAttributionPlugin {
  echo(options: { value: string }): Promise<{ value: string }>;
}
