import XCTest
@testable import Steady

class FakeReporter: Reporter {
    var lastReportedMessage: String?

    func reportError(_ errorMessage: String, testCase: XCTestCase) {
        lastReportedMessage = errorMessage
    }
}
