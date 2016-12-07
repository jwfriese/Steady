import XCTest

protocol Action {
    func perform(_ app: XCUIApplication) throws -> ActionResult
}
