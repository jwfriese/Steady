class WaitPromise {
    fileprivate(set) var result: WaitResult = .incomplete
    fileprivate var setSemaphore: DispatchSemaphore

    init() {
        setSemaphore = DispatchSemaphore(value: 1)
    }

    func set(_ result: WaitResult) -> Bool {
        var didSet = false
        let _ = setSemaphore.wait(timeout: DispatchTime(uptimeNanoseconds: 0))
        if isIncomplete() {
            self.result = result
            didSet = true
        }
        setSemaphore.signal()

        return didSet
    }

    func isIncomplete() -> Bool {
        switch result {
        case .incomplete:
            return true
        default:
            return false
        }
    }
}
