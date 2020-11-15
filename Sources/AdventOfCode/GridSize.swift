import Foundation

struct GridSize: Hashable, Equatable {
    var width: Int
    var height: Int
    
    init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
}

extension GridSize {
    /// Creates a size from the format `w x y`
    init(descriptor: String) {
        let dims = descriptor.split(separator: "x").map({ $0.trimmingCharacters(in: .whitespacesAndNewlines )})
        self.width = Int(dims[0])!
        self.height = Int(dims[1])!
    }
}
