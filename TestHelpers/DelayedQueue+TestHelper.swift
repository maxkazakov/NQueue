import Foundation
import NSpry

import NQueue

extension DelayedQueue: Equatable, SpryEquatable {
    public static func == (lhs: DelayedQueue, rhs: DelayedQueue) -> Bool {
        switch (lhs, rhs) {
        case (.absent, .absent):
            return true
        case (.sync(let a), .sync(let b)),
             (.async(let a), .async(let b)):
            return compare(a, b)
        case (.asyncAfter(let a1, let a2), .asyncAfter(let b1, let b2)):
            return a1 == b1 && compare(a2, b2)
        case (.asyncAfterWithFlags(let a1, let a2, let a3), .asyncAfterWithFlags(let b1, let b2, let b3)):
            return a1 == b1 && a2 == b2 && compare(a3, b3)

        case (.absent, _),
             (.sync, _),
             (.async, _),
             (.asyncAfter, _),
             (.asyncAfterWithFlags, _):
            return false
        }
    }
}

private func compare(_ lhs: Queueable, _ rhs: Queueable) -> Bool {
    if let queueA = lhs as? Queue,
       let queueB = rhs as? Queue {
        return queueA == queueB
    }

    return String(reflecting: lhs) == String(reflecting: rhs)
}
