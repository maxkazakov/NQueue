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

    private enum Kind: Equatable {
        case main
        case custom(label: String,
                    qos: DispatchQoS = .default,
                    attributes: Attributes = .concurrent)

        case background
        case utility
        case `default`
        case userInitiated
        case userInteractive
    }

    public static var main: Queueable {
        return Queue(kind: .main,
                     sdk: .main)
    }

    public static var background: Queueable {
        return Queue(kind: .background,
                     sdk: .global(qos: .background))
    }

    public static var utility: Queueable {
        return Queue(kind: .utility,
                     sdk: .global(qos: .utility))
    }

    public static var `default`: Queueable {
        return Queue(kind: .default,
                     sdk: .global(qos: .default))
    }

    public static var userInitiated: Queueable {
        return Queue(kind: .userInitiated,
                     sdk: .global(qos: .userInitiated))
    }

    public static var userInteractive: Queueable {
        return Queue(kind: .userInteractive,
                     sdk: .global(qos: .userInteractive))
    }

    public static func custom(label: String,
                              qos: DispatchQoS = .default,
                              attributes: Attributes = .concurrent) -> Queueable {
        return Queue(kind: .custom(label: label,
                                   qos: qos,
                                   attributes: attributes),
                     sdk: .init(label: label,
                                qos: qos,
                                attributes: attributes.toSDK()))
    }

    public let sdk: DispatchQueue
    private let kind: Kind

    internal var isMain: Bool {
        return kind == .main
    }

    private init(kind: Kind,
                 sdk: DispatchQueue) {
        self.kind = kind
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
