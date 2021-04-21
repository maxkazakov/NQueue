import Foundation

public enum Mutex {
    public enum PThreadKind {
        case normal
        case recursive

        public static let `default`: Self = .normal
    }

    case unfair
    case nslock
    case pthread(PThreadKind)
    case semaphore
    case barrier(Queueable)

    public static let `default`: Self = .unfair
}

public enum AtomicOption: Equatable {
    case async
    case sync
    case trySync
}

@propertyWrapper
public class Atomic<Value> {
    private let mutex: AtomicLock
    private var value: Value
    private let read: AtomicOption
    private let write: AtomicOption

    public var projectedValue: Atomic<Value> {
        return self
    }

    public var wrappedValue: Value {
        get {
            switch read {
            case .sync:
                return mutex.sync {
                    return value
                }
            case .trySync:
                return mutex.trySync {
                    return value
                }
            case .async:
                return value
            }
        }

        set {
            switch write {
            case .sync:
                mutex.sync {
                    value = newValue
                }
            case .trySync:
                mutex.trySync {
                    value = newValue
                }
            case .async:
                value = newValue
            }
        }
    }

    public init(wrappedValue initialValue: Value,
                mutex: Mutex = .default,
                read: AtomicOption = .async,
                write: AtomicOption = .trySync) {
        self.value = initialValue
        self.read = read
        self.write = write

        switch mutex {
        case .nslock:
            self.mutex = Impl.NSLock()
        case .pthread(let kind):
            self.mutex = Impl.PThread(type: kind)
        case .barrier(let q):
            self.mutex = Impl.Barrier(q)
        case .unfair:
            self.mutex = Impl.Unfair()
        case .semaphore:
            self.mutex = Impl.Semaphore()
        }
    }

    public func mutate(_ mutation: (inout Value) -> Void) {
        mutex.sync {
            mutation(&value)
        }
    }

    public func tryMutate(_ mutation: (inout Value) -> Void) {
        mutex.trySync {
            mutation(&value)
        }
    }

    public func mutate<T>(_ mutation: (inout Value) -> T) -> T {
        return mutex.sync {
            return mutation(&value)
        }
    }

    public func tryMutate<T>(_ mutation: (inout Value) -> T) -> T {
        return mutex.trySync {
            return mutation(&value)
        }
    }
}

extension Atomic where Value: ExpressibleByNilLiteral {
    public convenience init(mutex: Mutex = .default,
                            read: AtomicOption = .async,
                            write: AtomicOption = .async) {
        self.init(wrappedValue: nil,
                  mutex: mutex,
                  read: read,
                  write: write)
    }
}

private protocol AtomicLock {
    @discardableResult
    func sync<R>(execute work: () throws -> R) rethrows -> R

    @discardableResult
    func trySync<R>(execute work: () throws -> R) rethrows -> R
}

private protocol SimpleLock: AtomicLock {
    func lock()
    func tryLock() -> Bool
    func unlock()
}

private extension SimpleLock {
    @discardableResult
    func sync<R>(execute work: () throws -> R) rethrows -> R {
        lock()
        defer {
            unlock()
        }
        return try work()
    }

    @discardableResult
    func trySync<R>(execute work: () throws -> R) rethrows -> R {
        let locked = tryLock()
        defer {
            if locked {
                unlock()
            }
        }
        return try work()
    }
}

private enum Impl {
    final class Unfair: SimpleLock {
        private var _lock = os_unfair_lock()

        func lock() {
            os_unfair_lock_lock(&_lock)
        }

        func tryLock() -> Bool {
            return os_unfair_lock_trylock(&_lock)
        }

        func unlock() {
            os_unfair_lock_unlock(&_lock)
        }
    }

    struct NSLock: SimpleLock {
        private let _lock = Foundation.NSLock()

        func lock() {
            _lock.lock()
        }

        func tryLock() -> Bool {
            return _lock.try()
        }

        func unlock() {
            _lock.unlock()
        }
    }

    final class PThread: SimpleLock {
        private var _lock: pthread_mutex_t = .init()

        public init(type: Mutex.PThreadKind = .default) {
            var attr = pthread_mutexattr_t()

            guard pthread_mutexattr_init(&attr) == 0 else {
                preconditionFailure()
            }

            switch type {
            case .normal:
                pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_NORMAL)
            case .recursive:
                pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE)
            }

            guard pthread_mutex_init(&_lock, &attr) == 0 else {
                preconditionFailure()
            }

            pthread_mutexattr_destroy(&attr)
        }

        deinit {
            pthread_mutex_destroy(&_lock)
        }

        public func lock() {
            pthread_mutex_lock(&_lock)
        }

        public func tryLock() -> Bool {
            return pthread_mutex_trylock(&_lock) == 0
        }

        public func unlock() {
            pthread_mutex_unlock(&_lock)
        }
    }

    struct Semaphore: AtomicLock {
        private var _lock = DispatchSemaphore(value: 1)

        func sync<R>(execute work: () throws -> R) rethrows -> R {
            _lock.wait()
            defer {
                _lock.signal()
            }
            return try work()
        }

        func trySync<R>(execute work: () throws -> R) rethrows -> R {
            _lock.wait()
            defer {
                _lock.signal()
            }
            return try work()
        }
    }

    struct Barrier: AtomicLock {
        private let queue: Queueable

        init(_ queue: Queueable) {
            self.queue = queue
        }

        func sync<R>(execute work: () throws -> R) rethrows -> R {
            return try queue.sync(flags: .barrier, execute: work)
        }

        func trySync<R>(execute work: () throws -> R) rethrows -> R {
            return try queue.sync(flags: .barrier, execute: work)
        }
    }
}
