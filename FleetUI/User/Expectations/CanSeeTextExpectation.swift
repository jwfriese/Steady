import XCTest

class CanSeeTextExpectation: Expectation {
    var text: String!

    init(_ text: String) {
        self.text = text
    }

    var description: String {
        get {
            return "find text \"\(text)\""
        }
    }

    func validate(app: XCUIApplication) -> ExpectationResult {
        let textExists = app.staticTexts[text].exists
        guard textExists else {
            return .Rejected("it does not seem to exist")
        }

        let textVisible = app.staticTexts[text].visible
        guard textVisible else {
            return .Rejected("it appears to be offscreen")
        }

        return .Satisfied
    }
}
