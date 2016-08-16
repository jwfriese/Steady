import XCTest
import Nimble
@testable import FleetUI

class NotSpec: XCTestCase {
    var user: User!
    var reporter: FakeReporter!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        let app = XCUIApplication()
        reporter = FakeReporter()
        user = User(xcApp: app, testCase: self, reporter: reporter)
        user.startTesting()
    }

    func test_not_logicallyFlipsExpectation() {
        user.expectsTo(not(seeText("KITTENS THO")))
        expect(self.reporter.lastReportedMessage).to(beNil())

        user.expectsTo(not(seeText("Animals")))
        expect(self.reporter.lastReportedMessage).to(equal("User expected to not find text \"Animals\", but did"))
    }
}
