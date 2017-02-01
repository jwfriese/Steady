import XCTest

open class User {
    fileprivate var app: XCUIApplication!
    fileprivate var testCase: XCTestCase!
    fileprivate var reporter: Reporter!

    init(xcApp: XCUIApplication, testCase xcTestCase: XCTestCase, reporter aReporter: Reporter) {
        app = xcApp
        testCase = xcTestCase
        reporter = aReporter
    }

    open func startTesting() {
        app.launch()

        // As a workaround to the radar found here: http://openradar.appspot.com/26320475
        // Hopefully, this can go away one day. Once it does, Fleet users won't have to do anything
        // in their tests. We'll just take this out.
        wait(0.5)
    }

    open func tapButtonWithText(_ text: String) {
        doAction(TapButtonAction(text: text))
    }

    open func expectsTo(_ expectation: Expectation) {
        let expectationResult = expectation.validate(app)
        switch expectationResult {
        case .satisfied:
            return
        case .rejected:
            let failureMessage = "User expected to \(expectation.description), but \(expectationResult.description)"
            reporter.reportError(failureMessage, testCase: testCase)
        }
    }

    fileprivate func doAction(_ action: Action) {
        var actionResult: ActionResult?

        do {
            try actionResult = action.perform(app)
        } catch {
            actionResult = UIError("\(error)")
        }

        guard let finalResult = actionResult else {
            reporter.reportError("Fleet fatal error: No user action result", testCase: testCase)
            return
        }

        if !finalResult.succeeded {
            reporter.reportError(finalResult.resultDescription, testCase: testCase)
        }
    }
}
