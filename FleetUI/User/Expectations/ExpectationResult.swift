public enum ExpectationResult {
    case satisfied
    case rejected(String)

    var description: String {
        get {
            switch self {
            case .satisfied:
                return "Satisfied"
            case .rejected(let rejectionMessage):
                return rejectionMessage
            }
        }
    }
}
