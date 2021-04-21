import Foundation
import Spry

@testable import NQueue

extension DelayedQueue: Equatable, SpryEquatable {
    public static func == (lhs: DelayedQueue, rhs: DelayedQueue) -> Bool {
        switch (lhs, rhs) {
        case (.absent, .absent):
            return true
        case (.sync(let a), .sync(let b)),
             (.async(let a), .async(let b)):
            return a.comparable == b.comparable
        case (.asyncAfter(let a1, let a2), .asyncAfter(let b1, let b2)):
            return a1 == b1
                && a2.comparable == b2.comparable
        case (.asyncAfterWithFlags(let a1, let a2, let a3), .asyncAfterWithFlags(let b1, let b2, let b3)):
            return a1 == b1
                && a2 == b2
                && a3.comparable == b3.comparable
        case (.absent, _),
             (.sync, _),
             (.async, _),
             (.asyncAfter, _),
             (.asyncAfterWithFlags, _):
            return false
        }
    }
}

private extension Queueable {
    var comparable: String {
        return String(reflecting: self)
    }
}
