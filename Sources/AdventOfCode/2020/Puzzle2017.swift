
import Foundation

class Puzzle2017: Puzzle {
    let name: String = "2020_17"
    
    func solveA(_ input: Input) -> String {
        let coords = Set(input.grid.filter({ $1 == "#" }).keys.map(GridCoordinate3D.init))
        let sim = Simulation()
        sim.activeCoords = coords
        
        for _ in 0..<6 {
            sim.iterate()
        }
        
        return "\(sim.activeCoords.count)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    .#.
                    ..#
                    ###
                    """), expectedOutput: "112")
    ]
    
    func solveB(_ input: Input) -> String {
        let coords = Set(input.grid.filter({ $1 == "#" }).keys.map(GridCoordinate4D.init))
        let sim = Simulation4D()
        sim.activeCoords = coords
        
        for _ in 0..<6 {
            sim.iterate()
        }
        
        return "\(sim.activeCoords.count)"
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("""
                    .#.
                    ..#
                    ###
                    """), expectedOutput: "848")
    ]
    
    class Simulation {
        var activeCoords = Set<GridCoordinate3D>()
        
        func iterate() {
            let next = nextStep()
            activeCoords = next
        }
        
        func nextStep() -> Set<GridCoordinate3D> {
            var step = Set<GridCoordinate3D>()
            let coords = affectedCoords()
            for coord in coords {
                let neighbors = activeNeighbors(of: coord)
                if activeCoords.contains(coord) {
                    if neighbors.count == 2 || neighbors.count == 3 {
                        step.insert(coord)
                    }
                } else {
                    if neighbors.count == 3 {
                        step.insert(coord)
                    }
                }
                
            }
            return step
        }
        
        func affectedCoords() -> Set<GridCoordinate3D> {
            let allX = activeCoords.map(\.x)
            let minX = allX.min()! - 1
            let maxX = allX.max()! + 1
            
            let allY = activeCoords.map(\.y)
            let minY = allY.min()! - 1
            let maxY = allY.max()! + 1
            
            let allZ = activeCoords.map(\.z)
            let minZ = allZ.min()! - 1
            let maxZ = allZ.max()! + 1
            
            var set = Set<GridCoordinate3D>()
            for x in minX...maxX {
                for y in minY...maxY {
                    for z in minZ...maxZ {
                        let coord = GridCoordinate3D(x: x, y: y, z: z)
                        set.insert(coord)
                    }
                }
            }
            
            return set
        }
        
        func activeNeighbors(of coord: GridCoordinate3D) -> Set<GridCoordinate3D> {
            return coord.neighbors.intersection(activeCoords)
        }
        
        func render() {
            let allZ = activeCoords.map(\.z)
            let minZ = allZ.min()!
            let maxZ = allZ.max()!
            
            for z in minZ...maxZ {
                print("z=\(z)")
                let grid = slice(z: z)
                print(GridRect.enclosing(grid).render({ grid.contains($0) ? "#" : "." }))
                print("")
            }
        }
        
        func slice(z: Int) -> Set<GridCoordinate> {
            let grid = activeCoords.filter({ $0.z == z }).map({ GridCoordinate(x: $0.x, y: $0.y) })
            return Set(grid)
        }
    }
    
    class Simulation4D {
        var activeCoords = Set<GridCoordinate4D>()
        
        func iterate() {
            let next = nextStep()
            activeCoords = next
        }
        
        func nextStep() -> Set<GridCoordinate4D> {
            var step = Set<GridCoordinate4D>()
            let coords = affectedCoords()
            for coord in coords {
                let neighbors = activeNeighbors(of: coord)
                if activeCoords.contains(coord) {
                    if neighbors.count == 2 || neighbors.count == 3 {
                        step.insert(coord)
                    }
                } else {
                    if neighbors.count == 3 {
                        step.insert(coord)
                    }
                }
                
            }
            return step
        }
        
        func affectedCoords() -> Set<GridCoordinate4D> {
            let allX = activeCoords.map(\.x)
            let minX = allX.min()! - 1
            let maxX = allX.max()! + 1
            
            let allY = activeCoords.map(\.y)
            let minY = allY.min()! - 1
            let maxY = allY.max()! + 1
            
            let allZ = activeCoords.map(\.z)
            let minZ = allZ.min()! - 1
            let maxZ = allZ.max()! + 1
            
            let allW = activeCoords.map(\.w)
            let minW = allW.min()! - 1
            let maxW = allW.max()! + 1
            
            var set = Set<GridCoordinate4D>()
            for x in minX...maxX {
                for y in minY...maxY {
                    for z in minZ...maxZ {
                        for w in minW...maxW {
                            let coord = GridCoordinate4D(x: x, y: y, z: z, w: w)
                            set.insert(coord)
                        }
                    }
                }
            }
            
            return set
        }
        
        func activeNeighbors(of coord: GridCoordinate4D) -> Set<GridCoordinate4D> {
            return coord.neighbors.intersection(activeCoords)
        }
        
        func render() {
            let allZ = activeCoords.map(\.z)
            let minZ = allZ.min()!
            let maxZ = allZ.max()!
            
            for z in minZ...maxZ {
                print("z=\(z)")
                let grid = slice(z: z)
                print(GridRect.enclosing(grid).render({ grid.contains($0) ? "#" : "." }))
                print("")
            }
        }
        
        func slice(z: Int) -> Set<GridCoordinate> {
            let grid = activeCoords.filter({ $0.z == z }).map({ GridCoordinate(x: $0.x, y: $0.y) })
            return Set(grid)
        }
    }
}

struct GridCoordinate3D: Hashable, Equatable {
    var x: Int = 0
    var y: Int = 0
    var z: Int = 0
    
    static let zero = GridCoordinate3D(x: 0, y: 0, z: 0)
    
    init(_ gridCoordinate: GridCoordinate) {
        self.init(x: gridCoordinate.x, y: gridCoordinate.y, z: 0)
    }
    
    init(x: Int, y: Int, z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    var neighbors: Set<GridCoordinate3D> {
        var set = Set<GridCoordinate3D>()
        for x in (x - 1)...(x + 1) {
            for y in (y - 1)...(y + 1) {
                for z in (z - 1)...(z + 1) {
                    let coord = GridCoordinate3D(x: x, y: y, z: z)
                    set.insert(coord)
                }
            }
        }
        set.remove(self)
        return set
    }
}

struct GridCoordinate4D: Hashable, Equatable {
    var x: Int = 0
    var y: Int = 0
    var z: Int = 0
    var w: Int = 0
    
    static let zero = GridCoordinate4D(x: 0, y: 0, z: 0, w: 0)
    
    init(_ gridCoordinate: GridCoordinate) {
        self.init(x: gridCoordinate.x, y: gridCoordinate.y, z: 0, w: 0)
    }
    
    init(x: Int, y: Int, z: Int, w: Int) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
    
    var neighbors: Set<GridCoordinate4D> {
        var set = Set<GridCoordinate4D>()
        for x in (x - 1)...(x + 1) {
            for y in (y - 1)...(y + 1) {
                for z in (z - 1)...(z + 1) {
                    for w in (w - 1)...(w + 1) {
                        let coord = GridCoordinate4D(x: x, y: y, z: z, w: w)
                        set.insert(coord)
                    }
                }
            }
        }
        set.remove(self)
        return set
    }
}
