import XCTest
import FleetUI
import Nimble

class UserWaitTests: XCTestCase {
    var user: User!

    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        user = FleetUI.createUser(testCase: self)
        user.startTesting()
    }

    func testActionsWillWaitBeforeGivingUpAndFailing() {
        user.tapButtonWithText("Puppy")
        user.tapButtonWithText("Show Puppies")
        user.tapButtonWithText("Corgi") // This is expected to appear after a period of time
        user.expectsTo(findText("It's a Corgi!"))
        user.expectsTo(not(findText("I don't see what's so great about puppies")))
    }
}
