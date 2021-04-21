import Foundation

public enum DelayedQueue: Equatable {
    case absent
    case sync(Queueable)

    case async(Queueable)
    case asyncAfter(deadline: DispatchTime, queue: Queueable)
    case asyncAfterWithFlags(deadline: DispatchTime, flags: Queue.Flags, queue: Queueable)

    public static func == (lhs: DelayedQueue, rhs: DelayedQueue) -> Bool {
        switch (lhs, rhs) {
        case (.absent, .absent):
            return true
        case (.sync(let a), .sync(let b)),
             (.async(let a), .async(let b)):
            return a === b
        case (.asyncAfter(let a1, let a2), .asyncAfter(let b1, let b2)):
            return a1 == b1 && a2 === b2
        case (.asyncAfterWithFlags(let a1, let a2, let a3), .asyncAfterWithFlags(let b1, let b2, let b3)):
            return a1 == b1 && a2 == b2 && a3 === b3

        case (.absent, _),
             (.sync, _),
             (.async, _),
             (.asyncAfter, _),
             (.asyncAfterWithFlags, _):
            return false
        }
    }
}

public extension DelayedQueue {
    func fire(_ workItem: @escaping () -> Void) {
        switch self {
        case .absent:
            workItem()
        case .sync(let queue):
            queue.sync(execute: workItem)
        case .async(let queue):
            queue.async(execute: workItem)
        case .asyncAfter(let deadline, let queue):
            queue.asyncAfter(deadline: deadline,
                             execute: workItem)
        case .asyncAfterWithFlags(let deadline, let flags, let queue):
            queue.asyncAfter(deadline: deadline,
                             flags: flags,
                             execute: workItem)
        }
    }
}
