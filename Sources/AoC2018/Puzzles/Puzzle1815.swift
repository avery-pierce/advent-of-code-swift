
import Foundation
import AdventOfCode

class Puzzle1815: Puzzle {
    let name: String = "2018_15"
    
    func solveA(_ input: Input) -> String {
        let (battleField, combatants) = parseInput(input)
        let sim = BattleSimulation(battleField: battleField, combatants: combatants)
        sim.battleUntilOneTeamRemains()
        
        print("Rounds: \(sim.rounds), HP sum: \(sim.livingCombatants.map(\.hp).reduce(0, +)), winner: \(sim.winningTeam.debugDescription)")
        print("outcome: \(sim.computeOutcome())")
        return "\(sim.computeOutcome())"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    #######
                    #.G...#
                    #...EG#
                    #.#.#G#
                    #..G#E#
                    #.....#
                    #######
                    """), expectedOutput: "27730"),
        TestCase(TextInput("""
                    #######
                    #G..#E#
                    #E#E.E#
                    #G.##.#
                    #...#E#
                    #...E.#
                    #######
                    """), expectedOutput: "36334"),
        TestCase(TextInput("""
                    #######
                    #E..EG#
                    #.#G.E#
                    #E.##E#
                    #G..#.#
                    #..E#.#
                    #######
                    """), expectedOutput: "39514"),
        TestCase(TextInput("""
                    #######
                    #E.G#.#
                    #.#G..#
                    #G.#.G#
                    #G..#.#
                    #...E.#
                    #######
                    """), expectedOutput: "27755"),
        TestCase(TextInput("""
                    #######
                    #.E...#
                    #.#..G#
                    #.###.#
                    #E#G#G#
                    #...#G#
                    #######
                    """), expectedOutput: "28944"),
        TestCase(TextInput("""
                    #########
                    #G......#
                    #.E.#...#
                    #..##..G#
                    #...##..#
                    #...#...#
                    #.G...G.#
                    #.....G.#
                    #########
                    """), expectedOutput: "18740"),
    ]
    
    func solveB(_ input: Input) -> String {
        
        var testPowerLevel = 4
        while true {
            print("Starting battle at power level \(testPowerLevel)")
            let (battleField, combatants) = parseInput(input, elfPowerLevel: testPowerLevel)
            let sim = BattleSimulation(battleField: battleField, combatants: combatants)
            sim.battleUntilOneElfDiesOrElvesWin()
            
            if sim.deadElves.count == 0 && sim.winningTeam == .elf {
                print("Power level: \(testPowerLevel), Rounds: \(sim.rounds), HP sum: \(sim.livingCombatants.map(\.hp).reduce(0, +)), winner: \(sim.winningTeam.debugDescription)")
                print("outcome: \(sim.computeOutcome())")
                return "\(sim.computeOutcome())"
                
            } else {
                testPowerLevel += 1
            }
        }
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("""
                    #######
                    #.G...#
                    #...EG#
                    #.#.#G#
                    #..G#E#
                    #.....#
                    #######
                    """), expectedOutput: "4988"),
        TestCase(TextInput("""
                    #######
                    #E..EG#
                    #.#G.E#
                    #E.##E#
                    #G..#.#
                    #..E#.#
                    #######
                    """), expectedOutput: "31284"),
        TestCase(TextInput("""
                    #######
                    #E.G#.#
                    #.#G..#
                    #G.#.G#
                    #G..#.#
                    #...E.#
                    #######
                    """), expectedOutput: "3478"),
        TestCase(TextInput("""
                    #######
                    #.E...#
                    #.#..G#
                    #.###.#
                    #E#G#G#
                    #...#G#
                    #######
                    """), expectedOutput: "6474"),
        TestCase(TextInput("""
                    #########
                    #G......#
                    #.E.#...#
                    #..##..G#
                    #...##..#
                    #...#...#
                    #.G...G.#
                    #.....G.#
                    #########
                    """), expectedOutput: "1140"),
    ]
    
    func parseInput(_ input: Input, elfPowerLevel: Int = 3) -> (battleField: [GridCoordinate: TileKind], combatants: [Combatant]) {
        var battleField = [GridCoordinate: TileKind]()
        var combatants = [Combatant]()
        
        for (y, line) in input.lines.enumerated() {
            for (x, char) in line.enumerated() {
                let coord = GridCoordinate(x: x, y: y)
                battleField[coord] = char == "#" ? .wall : .floor
                
                switch char {
                case "G":
                    combatants.append(.goblin(at: coord))
                    
                case "E":
                    combatants.append(.elf(at: coord, powerLevel: elfPowerLevel))
                    
                default:
                    break
                }
            }
        }
        
        return (battleField: battleField, combatants: combatants)
    }
    
    enum TileKind {
        case wall
        case floor
    }
    
    class BattleSimulation {
        var battleField: [GridCoordinate: TileKind]
        var combatants: [Combatant]
        var rounds: Int = 0
        
        init(battleField: [GridCoordinate: TileKind], combatants: [Combatant]) {
            self.battleField = battleField
            self.combatants = combatants
        }
        
        var livingCombatants: [Combatant] { combatants.filter(\.isAlive) }
        var deadCombatants: [Combatant] { combatants.filter(\.isDead)}
        var elves: [Combatant] { livingCombatants.filter(\.isElf) }
        var goblins: [Combatant] { livingCombatants.filter(\.isGoblin) }
        var deadElves: [Combatant] { deadCombatants.filter(\.isElf) }
        
        var winningTeam: Combatant.Alignment? {
            if elves.isEmpty { return .goblin }
            if goblins.isEmpty { return .elf }
            return nil
        }
        var isComplete: Bool { winningTeam != nil }
        
        func combatants(at coordinate: GridCoordinate) -> [Combatant] {
            return livingCombatants.filter({ $0.coordinate == coordinate })
        }
        
        /// Returns this combatants *targets*, or enemies.
        /// If the combatant is an elf, this returns all goblins.
        /// If the combatant is a goblin, this returns all elves.
        func enemyTargets(of combatant: Combatant) -> [Combatant] {
            switch combatant.alignment {
            case .elf: return goblins
            case .goblin: return elves
            }
        }
        
        func tilesInRange(of coordinate: GridCoordinate) -> [GridCoordinate] {
            let directions: [GridVector] = [.north, .south, .east, .west]
            let range = directions.map(coordinate.moved(by:))
            return range
        }
        
        func passableTiles(inRangeOf coordinate: GridCoordinate) -> [GridCoordinate] {
            let range = tilesInRange(of: coordinate)
            return range.filter(isTilePassable)
        }
        
        func isTilePassable(_ coordinate: GridCoordinate) -> Bool {
            guard let tile = battleField[coordinate], tile == .floor else { return false }
            return combatants(at: coordinate).count == 0
        }
        
        func combatantsInRange(of coordinate: GridCoordinate) -> [Combatant] {
            return tilesInRange(of: coordinate).flatMap(combatants(at:))
        }
        
        func enemiesInRange(of combatant: Combatant) -> [Combatant] {
            return combatantsInRange(of: combatant.coordinate)
                .filter({ $0.alignment != combatant.alignment })
        }
        
        func targetedEnemy(of combatant: Combatant) -> Combatant? {
            let rangeEnemies = enemiesInRange(of: combatant)
            return rangeEnemies.min { (lhsEnemy, rhsEnemy) -> Bool in
                if (lhsEnemy.hp == rhsEnemy.hp) {
                    return GridCoordinate.inReadingOrder(lhsEnemy.coordinate, rhsEnemy.coordinate)
                } else {
                    return lhsEnemy.hp < rhsEnemy.hp
                }
            }
        }
        
        func stepsToReachTiles(from coordinate: GridCoordinate, stoppingAt targetCoordinate: GridCoordinate? = nil) -> [GridCoordinate: Int] {
            var steps = [GridCoordinate: Int]()
            steps[coordinate] = 0
            
            var currentFrontier = Set(arrayLiteral: coordinate)
            var stepCounter = 1
            while true {
                let reachableWithAnotherStep = currentFrontier.flatMap(passableTiles(inRangeOf:))
                let nextFrontier = Set(reachableWithAnotherStep.filter({ steps[$0] == nil }))
                if nextFrontier.isEmpty { break }
                
                for newCoord in nextFrontier {
                    steps[newCoord] = stepCounter
                }
                
                // Stop early if we have the target coordinate
                if let target = targetCoordinate, steps[target] != nil {
                    break
                }
                
                currentFrontier = nextFrontier
                stepCounter += 1
            }
            
            return steps
        }
        
        func battleUntilOneTeamRemains() {
            rounds = 0
            print("Start")
            print(renderState())
            while !isComplete {
                round()
                print("")
                print("After round \(rounds)")
                print(renderState())
            }
        }
        
        func battleUntilOneElfDiesOrElvesWin() {
            rounds = 0
            print("Start")
            print(renderState())
            while !isComplete && deadElves.count == 0 {
                round()
                print("")
                print("After round \(rounds)")
                print(renderState())
            }
        }
        
        func round() {
            
            sortCombatantsInReadingOrder()
            for combatant in combatants {
                
                guard combatant.isAlive else {
                    continue
                }

                let targets = enemyTargets(of: combatant)
                if targets.count == 0 {
                    return // The battle ends. One team has died.
                }
                
                movePhase(for: combatant, targets: targets)
                
                // Battle phase
                guard let target = targetedEnemy(of: combatant) else { continue }
                combatant.attack(target)
            }
            rounds += 1
        }
        
        func movePhase(for combatant: Combatant, targets: [Combatant]) {
            
            // If there's an enemy in range, don't move
            guard enemiesInRange(of: combatant).isEmpty else { return }
            
            // Movement phase
            let stepsAway = stepsToReachTiles(from: combatant.coordinate)
            let squaresInRangeOfTargets = targets.map(\.coordinate).flatMap(passableTiles(inRangeOf:))
            if squaresInRangeOfTargets.count == 0 {
                return
            }
            
            let reachableSquares = squaresInRangeOfTargets.filter({ stepsAway[$0] != nil })
            if reachableSquares.count == 0 {
                return
            }
            
            guard let distanceToClosestSquare = reachableSquares.map({ stepsAway[$0]! }).min() else {
                return
            }
            
            let closestSquares = reachableSquares
                .filter({ stepsAway[$0] == distanceToClosestSquare })
                .sorted(by: GridCoordinate.inReadingOrder)
            
            let selectedDestination = closestSquares[0]
            move(combatant, oneStepTowards: selectedDestination)
        }
        
        func sortCombatantsInReadingOrder() {
            combatants.sort(by: { GridCoordinate.inReadingOrder($0.coordinate, $1.coordinate) })
        }
        
        func move(_ combatant: Combatant, oneStepTowards destination: GridCoordinate) {
            let options = passableTiles(inRangeOf: combatant.coordinate)
            let stepsToReachDestination = options.compactMap { (origin) -> (coordinate: GridCoordinate, length: Int)? in
                guard let length = stepsToReachTiles(from: origin, stoppingAt: destination)[destination] else { return nil }
                return (coordinate: origin, length: length)
            }
            
            guard let minLength = stepsToReachDestination.map(\.length).min() else { return }
            
            let selectedCoordinate = stepsToReachDestination
                .filter({ $0.length == minLength })
                .map(\.coordinate)
                .min(by: GridCoordinate.inReadingOrder(_:_:))!
            
            combatant.coordinate = selectedCoordinate
        }
        
        func computeOutcome() -> Int {
            let hpSumOfRemainingUnits = livingCombatants.map(\.hp).reduce(0, +)
            return hpSumOfRemainingUnits * rounds
        }
        
        func renderState() -> String {
            let coords = Array(battleField.keys)
            let rect = GridRect.enclosing(coords)
            
            let lines = (rect.minY...rect.maxY).map { (y) -> String in
                return (rect.minX...rect.maxX)
                    .map({ GridCoordinate(x: $0, y: y) })
                    .map(renderCoordinate(_:))
                    .map(String.init)
                    .joined()
            }
            return lines.joined(separator: "\n")
        }
        
        func renderCoordinate(_ coordinate: GridCoordinate) -> Character {
            let fighters = combatants(at: coordinate)
            if let fighter = fighters.first {
                switch fighter.alignment {
                case .elf: return "E"
                case .goblin: return "G"
                }
            }
            
            let tile = battleField[coordinate] ?? .wall
            switch tile {
            case .floor: return "."
            case .wall: return "#"
            }
        }
    }
    
    struct Path {
        var coordinates: [GridCoordinate]
        init(_ coordinates: [GridCoordinate]) {
            self.coordinates = coordinates
        }
        
        var length: Int { coordinates.count }
        var stepsRequired: Int { length - 1 } // The path includes the origin, which doesn't count as a step.
        var firstStep: GridCoordinate? {
            guard stepsRequired > 0 else { return nil }
            return coordinates[1]
        }
        
        func prepending(_ coordinate: GridCoordinate) -> Path {
            var newCoordinates = coordinates
            newCoordinates.insert(coordinate, at: 0)
            return Path(newCoordinates)
        }
        
        
    }
    
    class Combatant {
        var coordinate: GridCoordinate
        var alignment: Alignment
        
        var isElf: Bool {
            return alignment == .elf
        }
        
        var isGoblin: Bool {
            return alignment == .goblin
        }
        
        var hp: Int = 200
        var power: Int
        var isAlive: Bool { hp > 0 }
        var isDead: Bool { return !isAlive }
        
        init(at coordinate: GridCoordinate, alignedWith alignment: Alignment, powerLevel: Int = 3) {
            self.coordinate = coordinate
            self.alignment = alignment
            self.power = powerLevel
        }
        
        static func elf(at coordinate: GridCoordinate, powerLevel: Int) -> Combatant {
            return Combatant(at: coordinate, alignedWith: .elf, powerLevel: powerLevel)
        }
        
        static func goblin(at coordinate: GridCoordinate) -> Combatant {
            return Combatant(at: coordinate, alignedWith: .goblin)
        }
        
        func attack(_ target: Combatant) {
            target.hp -= power
        }
    
        enum Alignment {
            case elf
            case goblin
        }
    }
}
