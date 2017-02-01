import XCTest
import Nimble
@testable import Steady

class UIErrorSpec: XCTestCase {
    func test_succeeded_returnsFalse() {
        let subject = UIError("")
        expect(subject.succeeded).to(beFalse())
    }

    func test_resultDescription_returnsMessageUsedToInitializeError() {
        let subject = UIError("error message")
        expect(subject.resultDescription).to(equal("Errored: error message"))
    }
}
