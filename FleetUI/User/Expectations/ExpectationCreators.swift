public func not(expectation: Expectation) -> Expectation {
    return Not(expectation)
}

public func findText(text: String) -> Expectation {
    return CanSeeTextExpectation(text)
}
