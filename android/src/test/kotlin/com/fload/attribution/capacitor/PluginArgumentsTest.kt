package com.fload.attribution.capacitor

import com.fload.attribution.FloadLogLevel
import org.junit.Assert.assertEquals
import org.junit.Assert.assertTrue
import org.junit.Test

class PluginArgumentsTest {
    private fun configure(key: String?, endpoint: String? = null, logLevel: String? = null) =
        PluginArguments(key, endpoint, logLevel).configuration()

    @Test
    fun keyPassesThroughWithProductionDefaults() {
        val result = configure("fload_pk_abc") as PluginArguments.Result.Success
        assertEquals("fload_pk_abc", result.key)
        assertEquals("https://ingest.fload.com", result.options.endpoint)
        assertEquals(FloadLogLevel.WARNING, result.options.logLevel)
    }

    @Test
    fun missingOrBlankKeyIsRefused() {
        assertTrue(configure(null) is PluginArguments.Result.Failure)
        assertTrue(configure("  ") is PluginArguments.Result.Failure)
    }

    @Test
    fun endpointAndLogLevelOverride() {
        val result = configure("k", "http://10.0.2.2:3001", "debug") as PluginArguments.Result.Success
        assertEquals("http://10.0.2.2:3001", result.options.endpoint)
        assertEquals(FloadLogLevel.DEBUG, result.options.logLevel)
    }

    @Test
    fun badEndpointOrLogLevelIsRefused() {
        assertTrue(configure("k", "ftp://x") is PluginArguments.Result.Failure)
        assertTrue(configure("k", "not a url") is PluginArguments.Result.Failure)
        assertTrue(configure("k", null, "verbose") is PluginArguments.Result.Failure)
    }

    @Test
    fun everyLogLevelNameMaps() {
        for (name in listOf("none", "error", "warning", "info", "debug")) {
            assertTrue(name, configure("k", null, name) is PluginArguments.Result.Success)
        }
    }
}
