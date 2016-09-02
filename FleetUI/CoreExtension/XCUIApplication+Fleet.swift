import XCTest

extension XCUIApplication {
    class func mainWindow() -> XCUIElement {
        return XCUIApplication().windows.elementBoundByIndex(0)
    }
}
