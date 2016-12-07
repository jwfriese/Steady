import XCTest

extension XCUIApplication {
    class func mainWindow() -> XCUIElement {
        return XCUIApplication().windows.element(boundBy: 0)
    }
}
