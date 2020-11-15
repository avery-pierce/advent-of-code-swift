
import Foundation

class Puzzle1803: Puzzle {
    typealias Coordinate = GridCoordinate
    typealias Size = GridSize
    typealias Rect = GridRect
    
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
