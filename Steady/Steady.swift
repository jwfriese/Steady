import XCTest

open class Steady {
    open class func createUser(testCase xcTestCase: XCTestCase) -> User {
        let xcApp = XCUIApplication()
        return User(xcApp: xcApp, testCase: xcTestCase, reporter: ReporterImpl())
    }
}
