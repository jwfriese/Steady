import XCTest

open class FleetUI {
    open class func createUser(testCase xcTestCase: XCTestCase) -> User {
        let xcApp = XCUIApplication()
        return User(xcApp: xcApp, testCase: xcTestCase, reporter: ReporterImpl())
    }
}
