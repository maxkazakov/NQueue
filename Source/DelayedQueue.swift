import Foundation

public enum DelayedQueue {
    case absent
    case sync(Queueable)

    case async(Queueable)
    case asyncAfter(deadline: DispatchTime, queue: Queueable)
    case asyncAfterWithFlags(deadline: DispatchTime, flags: Queue.Flags, queue: Queueable)
}

extension DelayedQueue {
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
