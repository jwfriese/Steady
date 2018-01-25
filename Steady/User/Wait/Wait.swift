import Foundation

func wait(_ timeout: Double) {
    let _ = Wait(withPredicate: { return true == false }).timeout(timeout).wait()
}

func wait(_ timeout: Double, forCondition condition: @escaping () -> Bool) -> Bool {
    let wait = Wait(withPredicate: condition).timeout(timeout).wait()
    return wait
}

struct WaitDefaults {
    static var timeout: Double {
        get {
            return 3
        }
    }

    static var mainLoopStallTimeout: UInt64 {
        get {
            return 5
        }
    }
}

private class Wait {
    var predicate: () -> Bool
    var timeout: Double = WaitDefaults.timeout
    var promise: WaitPromise
    var predicateSource: DispatchSource?
    var timeoutSource: DispatchSource?

    init(withPredicate predicate: @escaping () -> Bool) {
        self.predicate = predicate
        self.promise = WaitPromise()
    }

    func timeout(_ timeout: Double) -> Wait {
        self.timeout = timeout
        return self
    }

    func wait() -> Bool {
        let predicateSource = constructPredicateSource(predicate)
        let timeoutSource = constructTimeoutSource(timeout)

        self.predicateSource = predicateSource
        self.timeoutSource = timeoutSource

        predicateSource.resume()
        timeoutSource.resume()

        while promise.isIncomplete() {
            // This "advances" the run loop, blocking on processing of other sources on this run
            // loop (including our timeout and predicate sources above). If this were not here,
            // the loop would spin countless times in this loop before giving up control.
            RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date.distantFuture)
        }

        timeoutSource.suspend()
        predicateSource.suspend()

        timeoutSource.cancel()
        predicateSource.cancel()

        switch promise.result {
        case .fulfilled(let value):
            return value
        case .stalledMainRunLoop:
            print("Steady: Timeout occurred on user action and run loop stalled")
            return false
        default:
            return false
        }
    }

    func constructTimeoutSource(_ timeout: Double) -> DispatchSource {
        let timeoutSource = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags.strict, queue: DispatchQueue.global(qos: .userInitiated))

        let timeoutValue = Double(Int64(timeout * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        timeoutSource.schedule(deadline: DispatchTime.now() + timeoutValue, leeway: DispatchTimeInterval.milliseconds(2))

        timeoutSource.setEventHandler {
            guard self.promise.isIncomplete() else { return }

            let timeoutSemaphore = DispatchSemaphore(value: 1)

            let mainRunLoop = CFRunLoopGetMain()
            CFRunLoopPerformBlock(mainRunLoop, CFRunLoopMode.defaultMode.rawValue) {
                timeoutSemaphore.signal()

                if self.promise.set(.timeout) {
                    CFRunLoopStop(mainRunLoop)
                }
            }

            // Stop the run loop to pause the main thread and cycle through to the timeout processing
            // block added above.
            CFRunLoopStop(mainRunLoop)

            // It's possible that the stopped run loop could stall and never run the timeout
            // code. The following semaphores, which wait on the timeout code to run, are set
            // up to timeout themselves in case that happens.
            let stallTimeout = DispatchTime.now() + Double(Int64(WaitDefaults.mainLoopStallTimeout * NSEC_PER_SEC)) / Double(NSEC_PER_SEC)

            let didTimeOut = (timeoutSemaphore.wait(timeout: stallTimeout) == .timedOut)
            if didTimeOut {
                if self.promise.set(.stalledMainRunLoop) {
                    CFRunLoopStop(mainRunLoop)
                }
            }
        }

        return timeoutSource as! DispatchSource
    }

    func constructPredicateSource(_ predicate: @escaping () -> Bool) -> DispatchSource {
        let predicateSource = DispatchSource.makeTimerSource(
            flags: DispatchSource.TimerFlags.strict,
            queue: DispatchQueue.global(qos: .userInitiated)
        )

        predicateSource.schedule(
            deadline: DispatchTime.now(),
            repeating: DispatchTimeInterval.nanoseconds(Int(TimeInterval(NSEC_PER_SEC))),
            leeway: DispatchTimeInterval.milliseconds(1)
        )

        predicateSource.setEventHandler {
            DispatchQueue.main.async {
                print("Running predicate evaluation")
                if predicate() {
                    if self.promise.set(.fulfilled(true)) {
                        CFRunLoopStop(CFRunLoopGetCurrent())
                    }
                }
            }
        }

        return predicateSource as! DispatchSource
    }
}
