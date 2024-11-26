import Foundation

public struct GridRect: Hashable {
    public var origin: GridCoordinate
    public var size: GridSize
    
    public var minX: Int { origin.x }
    public var minY: Int { origin.y }
    public var maxX: Int { origin.x + size.width }
    public var maxY: Int { origin.y + size.height }
    
    public var width: Int { size.width }
    public var height: Int { size.height }
    public var area: Int { width * height }
    
    public init(_ origin: GridCoordinate, _ size: GridSize) {
        self.origin = origin
        self.size = size
    }
    
    public init(x: Int, y: Int, width: Int, height: Int) {
        self.origin = GridCoordinate(x: x, y: y)
        self.size = GridSize(width: width, height: height)
    }
    
    public init(x1: Int, y1: Int, x2: Int, y2: Int) {
        let xMin = min(x1, x2)
        let yMin = min(y1, y2)
        self.origin = GridCoordinate(x: xMin, y: yMin)
        
        let width = abs(x2 - x1)
        let height = abs(y2 - y1)
        self.size = GridSize(width: width, height: height)
    }
    
    public var coordinates: Set<GridCoordinate> {
        var set = Set<GridCoordinate>()
        for x in (minX...maxX) {
            for y in (minY...maxY) {
                set.insert(GridCoordinate(x: x, y: y))
            }
        }
        return set
    }
}

public extension GridRect {
    
    /// Creates a rect in the form `x,y: wxh`
    init(descriptor: String) {
        let dims = descriptor.split(separator: ":").map({ $0.trimmingCharacters(in: .whitespaces )})
        self.origin = GridCoordinate(descriptor: dims[0])
        self.size = GridSize(descriptor: dims[1])
    }
}

public extension GridRect {
    init(left: Int, top: Int, width: Int, height: Int) {
        self.origin = GridCoordinate(left: left, top: top)
        self.size = GridSize(width: width, height: height)
    }
}

public extension GridRect {
    static var zero = GridRect(x: 0, y: 0, width: 0, height: 0)
    
    static func enclosing(_ coords: [GridCoordinate]) -> GridRect {
        return enclosing(Set(coords))
    }
    
    static func enclosing(_ coords: Set<GridCoordinate>) -> GridRect {
        guard coords.count > 0 else { return .zero }
        guard coords.count > 1 else { return GridRect(Array(coords)[0], .zero)}
        
        let allX = coords.map(\.x)
        let allY = coords.map(\.y)
        
        let minX = allX.min()!
        let minY = allY.min()!
        let maxX = allX.max()!
        let maxY = allY.max()!
        
        return GridRect(x1: minX, y1: minY, x2: maxX, y2: maxY)
    }
    
    func encloses(_ coord: GridCoordinate) -> Bool {
        let withinX = coord.x >= minX && coord.x <= maxX
        let withinY = coord.y >= minY && coord.y <= maxY
        return withinX && withinY
    }
}

public extension GridRect {
    func render(_ renderChar: (GridCoordinate) -> Character) -> String {
        let lines = (minY...maxY).map { (y) -> String in
            let chars = (minX...maxX)
                .map({ GridCoordinate(x: $0, y: y) })
                .map(renderChar)
            return String(chars)
        }
        
        return lines.joined(separator: "\n")
    }
}
