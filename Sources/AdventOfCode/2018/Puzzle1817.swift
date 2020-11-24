
import Foundation

class Puzzle1817: Puzzle {
    let name: String = "2018_17"
    
    func solveA(_ input: Input) -> String {
        let coords = Set(parse(input))
        let sim = WaterSimulator(coords)
        sim.flowWaterFromSource()
        print(sim.render())
        return "\(sim.countWetTiles())"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    x=495, y=2..7
                    y=7, x=495..501
                    x=501, y=3..7
                    x=498, y=2..4
                    x=506, y=1..2
                    x=498, y=10..13
                    x=504, y=10..13
                    y=13, x=498..504
                    """), expectedOutput: "57")
    ]
    
    func solveB(_ input: Input) -> String {
        let coords = Set(parse(input))
        let sim = WaterSimulator(coords)
        sim.flowWaterFromSource()
        return "\(sim.countStillWaterTiles())"
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("""
                    x=495, y=2..7
                    y=7, x=495..501
                    x=501, y=3..7
                    x=498, y=2..4
                    x=506, y=1..2
                    x=498, y=10..13
                    x=504, y=10..13
                    y=13, x=498..504
                    """), expectedOutput: "29")
    ]
    
    func parse(_ input: Input) -> [GridCoordinate] {
        return input.lines.flatMap(parse)
    }
    
    func parse(_ line: String) -> [GridCoordinate] {
        let components = line.split(separator: ",").map(String.init).map({ $0.trimmingCharacters(in: .whitespaces)})
        
        let a = components[0].split(separator: "=")
        let aKey = a[0]
        let aVal = Int(a[1])!
        
        let b = components[1].split(separator: "=")
        let bRange = b[1].split(separator: ".")
        let bMin = Int(bRange[0])!
        let bMax = Int(bRange[1])!
        
        return (bMin...bMax).map { (bVal) -> GridCoordinate in
            if aKey == "x" {
                return GridCoordinate(x: aVal, y: bVal)
            } else {
                return GridCoordinate(x: bVal, y: aVal)
            }
        }
    }
    
    class WaterSimulator {
        var source = GridCoordinate(x: 500, y: 0)
        var clay: Set<GridCoordinate>
        lazy var boundingRect = GridRect.enclosing(clay)
        
        var water = [GridCoordinate: WaterForm]()
        
        func addStillWater(_ coord: GridCoordinate) {
            water[coord] = .still
        }
        func addFlowingWater(_ coord: GridCoordinate) {
            guard water[coord] == nil else { return }
            water[coord] = .flowing
        }
        
        init(_ clay: Set<GridCoordinate>) {
            self.clay = clay
            
        }
        
        func flowWaterFromSource() {
            dropWaterVertically(from: source)
        }
        
        func dropWaterVertically(from coordinate: GridCoordinate) {
            let (lowestPoint, reason) = lowestUninteruptedPoint(from: coordinate)
            let wetCoords = GridRect.enclosing([coordinate, lowestPoint]).coordinates
            wetCoords.forEach(addFlowingWater(_:))
            
            if reason == .floor {
                spreadWaterHorizontally(from: lowestPoint)
            }
        }
        
        enum VerticalBreakReason {
            case floor
            case redundant
            case outOfBounds
        }
        
        func lowestUninteruptedPoint(from coordinate: GridCoordinate) -> (coordinate: GridCoordinate, reason: VerticalBreakReason) {
            var currentCoordinate = coordinate
            while true {
                let nextCoordinate = currentCoordinate.moved(by: .down)
                if cellSupportsWater(nextCoordinate) {
                    return (coordinate: currentCoordinate, reason: .floor)
                }
                
                if nextCoordinate.y > boundingRect.maxY {
                    return (coordinate: currentCoordinate, reason: .outOfBounds)
                }
                
                currentCoordinate = nextCoordinate
                
                if water[currentCoordinate] == .flowing {
                    return (coordinate: currentCoordinate, reason: .redundant)
                }
            }
        }
        
        var counter = 0
        
        func spreadWaterHorizontally(from coordinate: GridCoordinate) {
            let leftMost = furthestSupportedUninterruptedPoint(from: coordinate, direction: .left)
            let rightMost = furthestSupportedUninterruptedPoint(from: coordinate, direction: .right)
            let rect = GridRect.enclosing([leftMost.coordinate, rightMost.coordinate])
            rect.coordinates.forEach(addFlowingWater(_:))
            
            if (leftMost.reason == .obstruction && rightMost.reason == .obstruction) {
                rect.coordinates.forEach(addStillWater(_:))
                if counter < 10_000 {
                    counter += 1
                    spreadWaterHorizontally(from: coordinate.moved(by: .up))
                }
            }
            
            if (leftMost.reason == .overflow) {
                dropWaterVertically(from: leftMost.coordinate)
            }
            
            if (rightMost.reason == .overflow) {
                dropWaterVertically(from: rightMost.coordinate)
            }
        }
        
        enum BreakReason {
            case overflow
            case obstruction
            case outOfBounds
        }
        
        func furthestSupportedUninterruptedPoint(from coordinate: GridCoordinate, direction: GridVector) -> (coordinate: GridCoordinate, reason: BreakReason) {
            var currentCoordinate = coordinate
            while true {
                let nextCoordinate = currentCoordinate.moved(by: direction)
                if clay.contains(nextCoordinate) {
                    return (coordinate: currentCoordinate, reason: .obstruction)
                }
                
//                if !boundingRect.encloses(nextCoordinate) {
//                    return (coordinate: currentCoordinate, reason: .outOfBounds)
//                }
                
                // Nothing obstructed the coordinate
                currentCoordinate = nextCoordinate
                
                let coordinateBelow = currentCoordinate.moved(by: .down)
                if !cellSupportsWater(coordinateBelow) {
                    return (coordinate: currentCoordinate, reason: .overflow)
                }
            }
            fatalError("too far")
        }
        
        func cellSupportsWater(_ cell: GridCoordinate) -> Bool {
            if clay.contains(cell) {
                return true
            }
            
            if water[cell] == .still {
                return true
            }
            
            return false
        }
        
        func render() -> String {
            return boundingRect.render(renderChar)
        }
        
        func renderChar(_ coordinate: GridCoordinate) -> Character {
            if let waterState = water[coordinate] {
                switch waterState {
                case .flowing: return "|"
                case .still: return "~"
                }
            }
            
            return clay.contains(coordinate) ? "#" : "."
        }
        
        enum WaterForm {
            case flowing
            case still
        }
        
        func countWetTiles() -> Int {
            return water.keys.filter({ $0.y >= boundingRect.minY && $0.y <= boundingRect.maxY }).count
        }
        
        func countStillWaterTiles() -> Int {
            return water.compactMap { (coord, waterForm) -> GridCoordinate? in
                guard waterForm == .still else { return nil }
                if coord.y >= boundingRect.minY && coord.y <= boundingRect.maxY {
                    return coord
                } else {
                    return nil
                }
            }.count
        }
    }
}
