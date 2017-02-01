import XCTest

class Not: Expectation {
    fileprivate var expectation: Expectation

    init(_ expectation: Expectation) {
        self.expectation = expectation
    }

    var description: String {
        get {
            return "not \(expectation.description)"
        }
    }

    func validate(_ app: XCUIApplication) -> ExpectationResult {
        let result = expectation.validate(app)
        switch result {
        case .satisfied:
            return .rejected("did")
        case .rejected:
            return .satisfied
        }
    }
}
