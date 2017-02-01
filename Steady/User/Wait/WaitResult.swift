import Foundation

enum WaitResult {
    case incomplete
    case fulfilled(Bool)
    case timeout
    case stalledMainRunLoop
}
