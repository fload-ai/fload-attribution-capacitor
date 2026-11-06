import FloadAttribution
import XCTest
@testable import FloadAttributionPlugin

/// The plugin's argument rules on the iOS simulator (`xcodebuild test`). The same
/// checks run on any Mac without Xcode through scripts/host-test-ios.sh.
final class PluginArgumentsTests: XCTestCase {
    private func configuration(_ key: String?, _ endpoint: String? = nil, _ logLevel: String? = nil) -> PluginArguments.Configuration? {
        try? PluginArguments(key: key, endpoint: endpoint, logLevel: logLevel).configuration().get()
    }

    func testKeyPassesThroughWithProductionDefaults() throws {
        let configuration = try XCTUnwrap(configuration("fload_pk_abc"))
        XCTAssertEqual(configuration.key, "fload_pk_abc")
        XCTAssertEqual(configuration.options.endpoint, URL(string: "https://ingest.fload.com"))
        XCTAssertEqual(configuration.options.logLevel, .warning)
    }

    func testMissingOrBlankKeyIsRefused() {
        XCTAssertNil(configuration(nil))
        XCTAssertNil(configuration("  "))
    }

    func testEndpointAndLogLevelOverride() throws {
        let configuration = try XCTUnwrap(configuration("k", "http://localhost:3999", "debug"))
        XCTAssertEqual(configuration.options.endpoint, URL(string: "http://localhost:3999"))
        XCTAssertEqual(configuration.options.logLevel, .debug)
    }

    func testBadEndpointOrLogLevelIsRefused() {
        XCTAssertNil(configuration("k", "ftp://x"))
        XCTAssertNil(configuration("k", nil, "verbose"))
    }
}
