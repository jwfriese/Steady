import XCTest

protocol Reporter {
    func reportError(_ errorMessage: String, testCase: XCTestCase)
}

class ReporterImpl: Reporter {
    func reportError(_ errorMessage: String, testCase: XCTestCase) {
        testCase.recordFailure(withDescription: errorMessage, inFile: #file, atLine: #line, expected: false)
    }
}
