public func not(expectation: Expectation) -> Expectation {
    return Not(expectation)
}

public func seeText(text: String) -> Expectation {
    return CanSeeTextExpectation(text)
}
