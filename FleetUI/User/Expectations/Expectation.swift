import XCTest

public protocol Expectation {
    var description: String { get }
    func validate(_ app: XCUIApplication) -> ExpectationResult
}
