import XCTest
import Steady
import Nimble

class ElementVisibilityTests: XCTestCase {
    var user: User!

    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        user = Steady.createUser(testCase: self)
        user.startTesting()
    }

    func test_visibilityPropertyOnXCUIElement() {
        user.tapButtonWithText("Puppy")
        user.tapButtonWithText("Show Puppies")
        user.tapButtonWithText("French Bulldog")

        // Currently offscreen
        user.expectsTo(not(seeText("Bulldog three")))

        // After scrolling down a bit, it will be onscreen
    }
}
