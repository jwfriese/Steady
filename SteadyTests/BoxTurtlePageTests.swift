import XCTest
import Steady
import Nimble

class BoxTurtlePageTests: XCTestCase {
    var user: User!

    override func setUp() {
        super.setUp()

        continueAfterFailure = false
        user = Steady.createUser(testCase: self)
        user.startTesting()
    }

    func testMakeThatTurtleDance() {
        user.tapButtonWithText("Box Turtle")
        user.tapButtonWithText("DANCE")
        user.expectsTo(seeText("BOX TURTLE DANCE PARTY"))
    }
}
