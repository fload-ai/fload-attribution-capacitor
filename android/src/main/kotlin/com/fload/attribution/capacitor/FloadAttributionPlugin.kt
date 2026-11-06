package com.fload.attribution.capacitor

import com.fload.attribution.Fload
import com.getcapacitor.JSObject
import com.getcapacitor.Plugin
import com.getcapacitor.PluginCall
import com.getcapacitor.PluginMethod
import com.getcapacitor.annotation.CapacitorPlugin

/**
 * Capacitor bridge over fload-attribution-android. Each method maps one to one
 * to the Kotlin SDK; there is no logic here beyond reading the arguments.
 */
@CapacitorPlugin(name = "FloadAttribution")
class FloadAttributionPlugin : Plugin() {

    @PluginMethod
    fun configure(call: PluginCall) {
        val arguments = PluginArguments(
            key = call.getString("key"),
            endpoint = call.getString("endpoint"),
            logLevel = call.getString("logLevel"),
        )
        when (val result = arguments.configuration()) {
            is PluginArguments.Result.Success -> {
                Fload.configure(context, result.key, result.options)
                call.resolve()
            }
            is PluginArguments.Result.Failure -> call.reject(result.message)
        }
    }

    @PluginMethod
    fun setUserId(call: PluginCall) {
        val id = call.getString("id")
        if (id == null) {
            call.reject("Fload: setUserId needs { id: \"…\" }")
            return
        }
        Fload.setUserId(id)
        call.resolve()
    }

    @PluginMethod
    fun getInstallReference(call: PluginCall) {
        val result = JSObject()
        result.put("installReference", Fload.installReference ?: JSObject.NULL)
        call.resolve(result)
    }
}
