import Foundation

struct GridRect: Hashable {
    var origin: GridCoordinate
    var size: GridSize
    
    init(_ origin: GridCoordinate, _ size: GridSize) {
        self.origin = origin
        self.size = size
    }
    
    init(x: Int, y: Int, width: Int, height: Int) {
        self.origin = GridCoordinate(x: x, y: y)
        self.size = GridSize(width: width, height: height)
    }
    
    init(x1: Int, y1: Int, x2: Int, y2: Int) {
        let xMin = min(x1, x2)
        let yMin = min(y1, y2)
        self.origin = GridCoordinate(x: xMin, y: yMin)
        
        let width = abs(x2 - x1)
        let height = abs(y2 - y1)
        self.size = GridSize(width: width, height: height)
    }
    
    var coordinates: Set<GridCoordinate> {
        var set = Set<GridCoordinate>()
        for x in (origin.x..<(origin.x + size.width)) {
            for y in (origin.y..<(origin.y + size.height)) {
                set.insert(GridCoordinate(x: x, y: y))
            }
        }
        return set
    }
}

extension GridRect {
    
    /// Creates a rect in the form `x,y: wxh`
    init(descriptor: String) {
        let dims = descriptor.split(separator: ":").map({ $0.trimmingCharacters(in: .whitespaces )})
        self.origin = GridCoordinate(descriptor: dims[0])
        self.size = GridSize(descriptor: dims[1])
    }
}

extension GridRect {
    init(left: Int, top: Int, width: Int, height: Int) {
        self.origin = GridCoordinate(left: left, top: top)
        self.size = GridSize(width: width, height: height)
    }
}

