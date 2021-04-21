import Foundation

public extension DispatchTimeInterval {
    static func seconds(_ seconds: Double) -> Self {
        let nano = Int(seconds * 1e+9)
        return .nanoseconds(nano)
    }
}
