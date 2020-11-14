
import Foundation



class Puzzle1803: Puzzle {
    let name: String = "2018_03"
    
    func solveA(_ input: Input) -> String {
        let claims = input.lines.map(Claim.init)
        var freq = Frequency<Coordinate>()
        
        claims.forEach { (claim) in
            claim.rect.coordinates.forEach({ freq.increment($0) })
        }
        
        let overlappingCoords = freq.values(where: { $0 > 1 })
        return "\(overlappingCoords.count)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    #1 @ 1,3: 4x4
                    #2 @ 3,1: 4x4
                    #3 @ 5,5: 2x2
                    """), expectedOutput: "4")
    ]
    
    func solveB(_ input: Input) -> String {
        let claims = input.lines.map(Claim.init)
        var freq = Frequency<Coordinate>()
        
        claims.forEach { (claim) in
            claim.rect.coordinates.forEach({ freq.increment($0) })
        }
        
        let overlappingCoords = freq.values(where: { $0 > 1 })
        
        let nonOverlappingClaim = claims.first { (claim) -> Bool in
            return claim.rect.coordinates.first(where: { overlappingCoords.contains($0) }) == nil
        }
        
        return nonOverlappingClaim!.id
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("""
                    #1 @ 1,3: 4x4
                    #2 @ 3,1: 4x4
                    #3 @ 5,5: 2x2
                    """), expectedOutput: "#3")
    ]
    
    struct Coordinate: Hashable {
        var top: Int
        var left: Int
        init(left: Int, top: Int) {
            self.top = top
            self.left = left
        }
        
        init(descriptor: String) {
            let coords = descriptor.split(separator: ",")
            self.left = Int(coords[0])!
            self.top = Int(coords[1])!
        }
    }
    
    struct Size: Hashable {
        var width: Int
        var height: Int
        
        init(width: Int, height: Int) {
            self.width = width
            self.height = height
        }
        
        init(descriptor: String) {
            let dims = descriptor.split(separator: "x")
            self.width = Int(dims[0])!
            self.height = Int(dims[1])!
        }
    }
    
    struct Rect: Hashable {
        var origin: Coordinate
        var size: Size
        
        init(_ origin: Coordinate, _ size: Size) {
            self.origin = origin
            self.size = size
        }
        
        init(left: Int, top: Int, width: Int, height: Int) {
            self.origin = Coordinate(left: left, top: top)
            self.size = Size(width: width, height: height)
        }
        
        init(descriptor: String) {
            let dims = descriptor.split(separator: ":").map({ $0.trimmingCharacters(in: .whitespaces )})
            self.origin = Coordinate(descriptor: dims[0])
            self.size = Size(descriptor: dims[1])
        }
        
        var coordinates: Set<Coordinate> {
            var set = Set<Coordinate>()
            for leftOffset in (origin.left..<(origin.left + size.width)) {
                for topOffset in (origin.top..<(origin.top + size.height)) {
                    set.insert(Coordinate(left: leftOffset, top: topOffset))
                }
            }
            return set
        }
    }
    
    struct Claim {
        var id: String
        var rect: Rect
        
        init(_ descriptor: String) {
            let parts = descriptor.split(separator: "@").map({ $0.trimmingCharacters(in: .whitespaces )})
            self.id = String(parts[0])
            self.rect = Rect(descriptor: String(parts[1]))
        }
    }
}
