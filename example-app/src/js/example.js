import { FloadAttribution } from '@fload-ai/attribution-capacitor';

window.testEcho = () => {
    const inputValue = document.getElementById("echoInput").value;
    FloadAttribution.echo({ value: inputValue })
}
