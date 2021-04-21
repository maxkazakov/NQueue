import Foundation

public protocol Queueable: class {
    func async(execute workItem: @escaping () -> Void)

    func asyncAfter(deadline: DispatchTime,
                    flags: Queue.Flags,
                    execute work: @escaping () -> Void)
    func asyncAfter(deadline: DispatchTime,
                    execute work: @escaping () -> Void)

    func sync(execute workItem: () -> Void)
    func sync(execute workItem: () throws -> Void) rethrows

    func sync<T>(flags: Queue.Flags, execute work: () throws -> T) rethrows -> T
    func sync<T>(execute work: () throws -> T) rethrows -> T

    func sync<T>(flags: Queue.Flags, execute work: () -> T) -> T
    func sync<T>(execute work: () -> T) -> T
}
