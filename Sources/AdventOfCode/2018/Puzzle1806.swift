
import Foundation

class Puzzle1806: Puzzle {
    let name: String = "2018_06"
    
    func solveA(_ input: Input) -> String {
        let coordinates = input.lines.map(GridCoordinate.init(descriptor:))
        let boundingRect = GridRect.enclosing(coordinates)
        let allPoints = boundingRect.coordinates
        var hazardZones = Frequency<GridCoordinate>(allPoints.compactMap({ selectClosestPoint(options: coordinates, to: $0) }))
        
        for infiniteHazard in infiniteHazards(hazards: coordinates) {
            hazardZones[infiniteHazard] = 0
        }
        
        let biggestZone = hazardZones.mostFrequent!
        let count = hazardZones[biggestZone]
        return "\(count)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    1, 1
                    1, 6
                    8, 3
                    3, 4
                    5, 5
                    8, 9
                    """), expectedOutput: "17")
    ]
    
    func solveB(_ input: Input) -> String {
        // The test case has a different threshold than the real puzzle
        let distanceThreshold = input.lines.count == 6 ? 32 : 10000
        
        let coordinates = input.lines.map(GridCoordinate.init(descriptor:))
        let boundingRect = GridRect.enclosing(coordinates)
        let allPoints = boundingRect.coordinates
        
        let validPoints = allPoints.filter({ computeTotalDistance(from: $0, toAll: coordinates) < distanceThreshold })
        return "\(validPoints.count)"
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("""
                    1, 1
                    1, 6
                    8, 3
                    3, 4
                    5, 5
                    8, 9
                    """), expectedOutput: "16")
    ]
    
    func infiniteHazards(hazards: [GridCoordinate]) -> [GridCoordinate] {
        return hazards.filter({ isHazardInfinite(options: hazards, select: $0) })
    }
    
    func isHazardInfinite(options: [GridCoordinate], select: GridCoordinate) -> Bool {
        // If this coordinate is on the edge of the system, it's infinite
        let boundingRect = GridRect.enclosing(options)
        if select.x == boundingRect.minX { return true }
        if select.x == boundingRect.maxX { return true }
        if select.y == boundingRect.minY { return true }
        if select.y == boundingRect.maxY { return true }
        
        // Pick 4 points in cardinal directions, 1000pts away. Is that point closest to this hazard?
        var ref1 = select
        ref1.x += 1000
        var ref2 = select
        ref2.x -= 1000
        var ref3 = select
        ref3.y += 1000
        var ref4 = select
        ref4.y -= 1000
        
        // If none of these ref points are closest to this point, we assume
        let refPoints = [ref1, ref2, ref3, ref4]
        if refPoints.first(where: { selectClosestPoint(options: options, to: $0) == select }) == nil {
            return false
        } else {
            return true
        }
        
    }
    
    /// If there's a tie, return `nil`
    func selectClosestPoint(options: [GridCoordinate], to coordinate: GridCoordinate) -> GridCoordinate? {
        let distances = options.map { (hazard) -> (coordinate: GridCoordinate, distance: Int) in
            let distance = coordinate.manhattanDistance(to: hazard)
            return (coordinate: hazard, distance: distance)
        }
        
        let shortestDistance = distances.map(\.distance).min()
        let closestPoints = distances.filter({ $0.distance == shortestDistance }).map(\.coordinate)
        if closestPoints.count == 1 {
            return closestPoints[0]
        } else {
            return nil
        }
    }
    
    func computeTotalDistance(from point: GridCoordinate, toAll points: [GridCoordinate]) -> Int {
        return points.map({ $0.manhattanDistance(to: point) }).reduce(0, +)
    }
}
