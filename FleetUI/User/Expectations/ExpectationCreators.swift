public func not(_ expectation: Expectation) -> Expectation {
    return Not(expectation)
}

public func seeText(_ text: String) -> Expectation {
    return CanSeeTextExpectation(text)
}
