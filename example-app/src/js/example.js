import { Capacitor } from '@capacitor/core';
import { FloadAttribution } from '@fload-ai/attribution-capacitor';

// The example talks to the local stub ingest (`npm run stub-ingest` in the
// plugin's root), never to production. The Android emulator reaches the
// host's localhost at 10.0.2.2; the iOS simulator shares the host's network.
const STUB_PORT = 3999;
const defaultEndpoint =
  Capacitor.getPlatform() === 'android' ? `http://10.0.2.2:${STUB_PORT}` : `http://localhost:${STUB_PORT}`;

const $ = (id) => document.getElementById(id);
const log = (line) => {
  $('log').textContent += `${new Date().toLocaleTimeString()}  ${line}\n`;
};

async function configure() {
  try {
    await FloadAttribution.configure({ key: $('key').value, endpoint: $('endpoint').value, logLevel: 'debug' });
    log(`configure: ok (${Capacitor.getPlatform()})`);
  } catch (error) {
    log(`configure: ${error.message}`);
  }
  await showInstallReference();
}

async function setUserId() {
  try {
    await FloadAttribution.setUserId({ id: $('userId').value });
    log(`setUserId: ok`);
  } catch (error) {
    log(`setUserId: ${error.message}`);
  }
}

async function showInstallReference() {
  // The native SDK loads its state on its own thread, so the reference can be
  // null for a moment right after configure.
  for (let attempt = 0; attempt < 10; attempt += 1) {
    const { installReference } = await FloadAttribution.getInstallReference();
    if (installReference) {
      $('installReference').textContent = installReference;
      console.log('Fload example: install reference ' + installReference); // read by the emulator check
      return;
    }
    await new Promise((resolve) => setTimeout(resolve, 300));
  }
  $('installReference').textContent = '(none yet)';
}

$('endpoint').value = defaultEndpoint;
$('configure').addEventListener('click', configure);
$('setUserId').addEventListener('click', setUserId);
$('refresh').addEventListener('click', showInstallReference);

// What an app does at launch: configure once, then name the user.
(async () => {
  await configure();
  await setUserId();
})();
