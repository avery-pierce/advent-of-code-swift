
import Foundation
import AdventOfCode

class Puzzle2024: Puzzle {
    let name: String = "2020_24"
    
    func solveA(_ input: Input) -> String {
        let directions = input.lines.map { (line) -> [HexMovement] in
            let parser = HexMovementParser(line)
            parser.parse()
            return parser.output
        }
        
        let destinations = directions.map({ sequence -> GridVector in
            let movements = sequence.map(\.vector)
            return movements.reduce(GridVector(dx: 0, dy: 0), +)
        })
        
        let freq = Frequency(destinations)
        let result = freq.values(where: { $0 % 2 == 1}).count
        
        return "\(result)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    sesenwnenenewseeswwswswwnenewsewsw
                    neeenesenwnwwswnenewnwwsewnenwseswesw
                    seswneswswsenwwnwse
                    nwnwneseeswswnenewneswwnewseswneseene
                    swweswneswnenwsewnwneneseenw
                    eesenwseswswnenwswnwnwsewwnwsene
                    sewnenenenesenwsewnenwwwse
                    wenwwweseeeweswwwnwwe
                    wsweesenenewnwwnwsenewsenwwsesesenwne
                    neeswseenwwswnwswswnw
                    nenwswwsewswnenenewsenwsenwnesesenew
                    enewnwewneswsewnwswenweswnenwsenwsw
                    sweneswneswneneenwnewenewwneswswnese
                    swwesenesewenwneswnwwneseswwne
                    enesenwswwswneneswsenwnewswseenwsese
                    wnwnesenesenenwwnenwsewesewsesesew
                    nenewswnwewswnenesenwnesewesw
                    eneswnwswnwsenenwnwnwwseeswneewsenese
                    neswnwewnwnwseenwseesewsenwsweewe
                    wseweeenwnesenwwwswnew
                    """), expectedOutput: "10")
    ]
    
    func solveB(_ input: Input) -> String {
        let directions = input.lines.map { (line) -> [HexMovement] in
            let parser = HexMovementParser(line)
            parser.parse()
            return parser.output
        }
        
        let destinations = directions.map({ sequence -> GridVector in
            let movements = sequence.map(\.vector)
            return movements.reduce(GridVector(dx: 0, dy: 0), +)
        })
        
        let coords = destinations.map({ GridCoordinate.zero.moved($0) })
        let freq = Frequency(coords)
        let blackCoords = freq.values(where: { $0 % 2 == 1})
        
        let simulation = HexArtSimulator(blackCoords: blackCoords)
        for _ in (0..<100) {
            simulation.iterate()
        }
        
        return "\(simulation.blackCoords.count)"
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("""
                    sesenwnenenewseeswwswswwnenewsewsw
                    neeenesenwnwwswnenewnwwsewnenwseswesw
                    seswneswswsenwwnwse
                    nwnwneseeswswnenewneswwnewseswneseene
                    swweswneswnenwsewnwneneseenw
                    eesenwseswswnenwswnwnwsewwnwsene
                    sewnenenenesenwsewnenwwwse
                    wenwwweseeeweswwwnwwe
                    wsweesenenewnwwnwsenewsenwwsesesenwne
                    neeswseenwwswnwswswnw
                    nenwswwsewswnenenewsenwsenwnesesenew
                    enewnwewneswsewnwswenweswnenwsenwsw
                    sweneswneswneneenwnewenewwneswswnese
                    swwesenesewenwneswnwwneseswwne
                    enesenwswwswneneswsenwnewswseenwsese
                    wnwnesenesenenwwnenwsewesewsesesew
                    nenewswnwewswnenesenwnesewesw
                    eneswnwswnwsenenwnwnwwseeswneewsenese
                    neswnwewnwnwseenwseesewsenwsweewe
                    wseweeenwnesenwwwswnew
                    """), expectedOutput: "2208")
    ]
    
    enum HexMovement {
        case ne
        case e
        case se
        
        case nw
        case w
        case sw
        
        var vector: GridVector {
            switch self {
            case .ne: return .north + .east
            case .e: return .east * 2
            case .se: return .south + .east
    
            case .nw: return .north + .west
            case .w: return .west * 2
            case .sw: return .south + .west
            }
        }
    }
    
    class HexMovementParser {
        var input: String
        var output = [HexMovement]()
        
        init(_ input: String) {
            self.input = input
        }
        
        func parse() {
            while !input.isEmpty {
                captureNext()
            }
        }
        
        private func captureNext() {
            guard let nextChar = input.first else { return }
            switch nextChar {
            case "e", "w": captureNextSingleChar()
            case "n", "s": captureNextTwoChars()
            default: fatalError("bad input \(nextChar)")
            }
        }
        
        func popFirst() -> Character {
            return input.remove(at: input.startIndex)
        }
        
        private func captureNextTwoChars() {
            let firstChar = popFirst()
            let secondChar = popFirst()
            switch (firstChar, secondChar) {
            case ("n", "e"): output.append(.ne)
            case ("n", "w"): output.append(.nw)
            case ("s", "e"): output.append(.se)
            case ("s", "w"): output.append(.sw)
            default: fatalError("bad input for two chars: \(firstChar)\(secondChar)")
            }
        }
        
        private func captureNextSingleChar() {
            let nextChar = popFirst()
            switch nextChar {
            case "e": output.append(.e)
            case "w": output.append(.w)
            default: fatalError("Only valid chars are e and w")
            }
        }
    }
    
    class HexArtSimulator {
        var blackCoords: Set<GridCoordinate>
        init(blackCoords: Set<GridCoordinate>) {
            self.blackCoords = blackCoords
        }
        
        func iterate() {
            blackCoords = nextIteration()
        }
        
        func nextIteration() -> Set<GridCoordinate> {
            return allAffectedCoords().filter { coord -> Bool in
                let isBlack = blackCoords.contains(coord)
                
                let allNeighbors = neighbors(of: coord)
                let blackNeighborsCount = allNeighbors.filter(blackCoords.contains).count
                
                if isBlack {
                    // Any black tile with zero or more than 2 black tiles immediately adjacent to it is flipped to white.
                    return blackNeighborsCount == 1 || blackNeighborsCount == 2
                } else {
                    // Any white tile with exactly 2 black tiles immediately adjacent to it is flipped to black.
                    return blackNeighborsCount == 2
                }
            }
        }
        
        func allAffectedCoords() -> Set<GridCoordinate> {
            var rect = GridRect.enclosing(blackCoords)
            
            // Expand the rect to include all tiles *adjacent* to black tiles too
            rect.origin.x -= 2
            rect.origin.y -= 1
            rect.size.width += 4
            rect.size.height += 2
            
            return rect.coordinates.filter(isValidHexCoord(_:))
        }
        
        func isValidHexCoord(_ gridCoord: GridCoordinate) -> Bool {
            return abs(gridCoord.x + gridCoord.y) % 2 == 0
        }
        
        func neighbors(of coord: GridCoordinate) -> Set<GridCoordinate> {
            let allDirections: [HexMovement] = [.ne, .e, .se, .nw, .w, .sw]
            return Set(allDirections.map({ coord.moved($0.vector) }))
        }
    }
}
