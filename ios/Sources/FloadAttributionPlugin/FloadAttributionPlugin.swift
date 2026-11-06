import Capacitor
import Foundation
#if canImport(FloadAttribution)
// Swift Package Manager: the SDK is the fload-attribution-ios package.
// CocoaPods: the SDK's sources are vendored into this pod's own module.
import FloadAttribution
#endif

/// Capacitor bridge over fload-attribution-ios. Each method maps one to one to
/// the Swift SDK; there is no logic here beyond reading the arguments.
@objc(FloadAttributionPlugin)
public class FloadAttributionPlugin: CAPPlugin, CAPBridgedPlugin {
    public let identifier = "FloadAttributionPlugin"
    public let jsName = "FloadAttribution"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "configure", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "setUserId", returnType: CAPPluginReturnPromise),
        CAPPluginMethod(name: "getInstallReference", returnType: CAPPluginReturnPromise),
    ]

    @objc func configure(_ call: CAPPluginCall) {
        let arguments = PluginArguments(
            key: call.getString("key"),
            endpoint: call.getString("endpoint"),
            logLevel: call.getString("logLevel")
        )
        switch arguments.configuration() {
        case let .success(configuration):
            Fload.configure(key: configuration.key, options: configuration.options)
            call.resolve()
        case let .failure(error):
            call.reject(error.message)
        }
    }

    @objc func setUserId(_ call: CAPPluginCall) {
        guard let id = call.getString("id") else {
            call.reject("Fload: setUserId needs { id: \"…\" }")
            return
        }
        Fload.setUserId(id)
        call.resolve()
    }

    @objc func getInstallReference(_ call: CAPPluginCall) {
        call.resolve(["installReference": Fload.installReference ?? NSNull()])
    }
}
