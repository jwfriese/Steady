import XCTest
import Steady
import Nimble

class UserWaitTests: XCTestCase {
    var user: User!

    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        user = Steady.createUser(testCase: self)
        user.startTesting()
    }

    func testActionsWillWaitBeforeGivingUpAndFailing() {
        user.tapButtonWithText("Puppy")
        user.tapButtonWithText("Show Puppies")
        user.tapButtonWithText("Corgi") // This is expected to appear after a period of time
        user.expectsTo(seeText("It's a Corgi!"))
        user.expectsTo(not(seeText("I don't see what's so great about puppies")))
    }
}
