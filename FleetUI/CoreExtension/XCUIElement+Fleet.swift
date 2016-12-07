import XCTest

extension XCUIElement {
    var visible: Bool {
        get {
            return exists && isHittable
        }
    }
}
