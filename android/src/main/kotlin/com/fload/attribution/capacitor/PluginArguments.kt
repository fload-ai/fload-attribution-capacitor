package com.fload.attribution.capacitor

import com.fload.attribution.FloadLogLevel
import com.fload.attribution.FloadOptions
import java.net.URI

/** The plugin's argument rules, kept free of Capacitor so they can be unit tested. */
internal class PluginArguments(
    private val key: String?,
    private val endpoint: String?,
    private val logLevel: String?,
) {
    sealed class Result {
        class Success(val key: String, val options: FloadOptions) : Result()
        class Failure(val message: String) : Result()
    }

    fun configuration(): Result {
        if (key.isNullOrBlank()) {
            return Result.Failure("Fload: configure needs { key: \"fload_pk_…\" }")
        }
        val defaults = FloadOptions()
        val resolvedEndpoint = endpoint ?: defaults.endpoint
        if (!isHttpUrl(resolvedEndpoint)) {
            return Result.Failure("Fload: endpoint must be an http(s) URL")
        }
        val level = if (logLevel == null) defaults.logLevel else LOG_LEVELS[logLevel]
            ?: return Result.Failure("Fload: logLevel must be one of none, error, warning, info, debug")
        return Result.Success(key, FloadOptions(resolvedEndpoint, level))
    }

    private fun isHttpUrl(value: String): Boolean = try {
        val uri = URI(value)
        (uri.scheme == "https" || uri.scheme == "http") && !uri.host.isNullOrEmpty()
    } catch (_: Exception) {
        false
    }

    companion object {
        val LOG_LEVELS: Map<String, FloadLogLevel> = mapOf(
            "none" to FloadLogLevel.NONE,
            "error" to FloadLogLevel.ERROR,
            "warning" to FloadLogLevel.WARNING,
            "info" to FloadLogLevel.INFO,
            "debug" to FloadLogLevel.DEBUG,
        )
    }
}
