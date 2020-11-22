
import Foundation

class Puzzle1815: Puzzle {
    let name: String = "2018_15"
    
    func solveA(_ input: Input) -> String {
        let (battleField, combatants) = parseInput(input)
        let sim = BattleSimulation(battleField: battleField, combatants: combatants)
        return ""
    }
    
    var testCasesA: [TestCase] = [
        // Input test cases here
    ]
    
    func solveB(_ input: Input) -> String {
        return "unsolved"
    }
    
    var testCasesB: [TestCase] = [
        // Input test cases here
    ]
    
    func parseInput(_ input: Input) -> (battleField: [GridCoordinate: TileKind], combatants: [Combatant]) {
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
                    combatants.append(.elf(at: coord))
                    
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
        
        init(battleField: [GridCoordinate: TileKind], combatants: [Combatant]) {
            self.battleField = battleField
            self.combatants = combatants
        }
        
        var livingCombatants: [Combatant] { combatants.filter(\.isAlive) }
        var elves: [Combatant] { livingCombatants.filter(\.isElf) }
        var goblins: [Combatant] { livingCombatants.filter(\.isGoblin) }
        
        var winningTeam: Combatant.Alignment? {
            if elves.isEmpty { return .goblin }
            if goblins.isEmpty { return .elf }
            return nil
        }
        var isComplete: Bool { winningTeam != nil }
        
        func combatants(at coordinate: GridCoordinate) -> [Combatant] {
            return combatants.filter({ $0.coordinate == coordinate })
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
        
        func passableTiles(inRangeOf coordinate: GridCoordinate) -> [GridCoordinate] {
            let directions: [GridVector] = [.north, .south, .east, .west]
            let range = directions.map(coordinate.moved(by:))
            return range.filter(isTilePassable)
        }
        
        func isTilePassable(_ coordinate: GridCoordinate) -> Bool {
            guard let tile = battleField[coordinate], tile == .floor else { return false }
            return combatants(at: coordinate).count == 0
        }
        
        func stepsToReachTiles(from coordinate: GridCoordinate) -> [GridCoordinate: Int] {
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
                
                currentFrontier = nextFrontier
                stepCounter += 1
            }
            
            return steps
        }
        
        func battleUntilOneTeamRemains() {
            
        }
        
        func round() {
            sortCombatantsInReadingOrder()
            for combatant in combatants {
                let targets = enemyTargets(of: combatant)
                if targets.count == 0 {
                    return
                }
                
                let stepsAway = stepsToReachTiles(from: combatant.coordinate)
                let squaresInRangeOfTargets = targets.map(\.coordinate).flatMap(passableTiles(inRangeOf:))
                if squaresInRangeOfTargets.count == 0 {
                    continue
                }
                
                let reachableSquares = squaresInRangeOfTargets.filter({ stepsAway[$0] != nil })
                if reachableSquares.count == 0 {
                    continue
                }
                
                guard let distanceToClosestSquare = reachableSquares.map({ stepsAway[$0]! }).min() else {
                    continue
                }
                
                let closestSquares = reachableSquares
                    .filter({ stepsAway[$0] == distanceToClosestSquare })
                    .sorted(by: GridCoordinate.inReadingOrder)
                
                let selectedDestination = closestSquares[0]
                
            }
        }
        
        func sortCombatantsInReadingOrder() {
            combatants.sort(by: { GridCoordinate.inReadingOrder($0.coordinate, $1.coordinate) })
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
        var power: Int = 3
        var isAlive: Bool { hp > 0 }
        
        init(at coordinate: GridCoordinate, alignedWith alignment: Alignment) {
            self.coordinate = coordinate
            self.alignment = alignment
        }
        
        static func elf(at coordinate: GridCoordinate) -> Combatant {
            return Combatant(at: coordinate, alignedWith: .elf)
        }
        
        static func goblin(at coordinate: GridCoordinate) -> Combatant {
            return Combatant(at: coordinate, alignedWith: .goblin)
        }
    
        enum Alignment {
            case elf
            case goblin
        }
    }
}
