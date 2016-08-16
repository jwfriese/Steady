import XCTest

class Not: Expectation {
    private var expectation: Expectation!

    init(_ expectation: Expectation) {
        self.expectation = expectation
    }

    var description: String {
        get {
            return "not \(expectation.description)"
        }
    }

    func validate(app: XCUIApplication) -> ExpectationResult {
        let result = expectation.validate(app)
        switch result {
        case .Satisfied:
            return .Rejected("did")
        case .Rejected:
            return .Satisfied
        }
    }
}
