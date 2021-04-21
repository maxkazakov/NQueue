import Foundation

public struct Queue: Equatable {
    public enum Attributes: Equatable {
        case concurrent
        case serial
    }

    public enum Flags: Equatable {
        case absent
        case barrier
    }

    public static var main: Queueable {
        return Queue(isMain: true,
                     sdk: .main)
    }

    public static var background: Queueable {
        return Queue(sdk: .global(qos: .background))
    }

    public static var utility: Queueable {
        return Queue(sdk: .global(qos: .utility))
    }

    public static var `default`: Queueable {
        return Queue(sdk: .global(qos: .`default`))
    }

    public static var userInitiated: Queueable {
        return Queue(sdk: .global(qos: .userInitiated))
    }

    public static var userInteractive: Queueable {
        return Queue(sdk: .global(qos: .userInteractive))
    }

    public static func custom(label: String,
                              qos: DispatchQoS = .default,
                              attributes: Attributes = .concurrent) -> Queueable {
        return Queue(sdk: .init(label: label,
                                qos: qos,
                                attributes: attributes.toSDK()))
    }

    public let sdk: DispatchQueue
    internal let isMain: Bool

    private init(isMain: Bool = false,
                 sdk: DispatchQueue) {
        self.isMain = isMain
        self.sdk = sdk
    }
}

private extension Queue.Attributes {
    func toSDK() -> DispatchQueue.Attributes {
        switch self {
        case .concurrent:
            return .concurrent
        case .serial:
            return []
        }
    }
}
