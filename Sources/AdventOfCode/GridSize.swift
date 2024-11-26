import Foundation

public struct GridSize: Hashable, Equatable {
    public var width: Int
    public var height: Int
    
    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
}

public extension GridSize {
    /// Creates a size from the format `w x y`
    init(descriptor: String) {
        let dims = descriptor.split(separator: "x").map({ $0.trimmingCharacters(in: .whitespacesAndNewlines )})
        self.width = Int(dims[0])!
        self.height = Int(dims[1])!
    }
}

public extension GridSize {
    static var zero = GridSize(width: 0, height: 0)
}
