
import Foundation

class Puzzle2012: Puzzle {
    let name: String = "2020_12"
    
    func solveA(_ input: Input) -> String {
        let insts = input.lines.map(Instruction.init)
        let ship = ShipSimulation()
        for instruction in insts {
            ship.perform(instruction)
        }
        let result = ship.location.manhattanDistance(to: .zero)
        return "\(result)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    F10
                    N3
                    F7
                    R90
                    F11
                    """), expectedOutput: "25")
    ]
    
    func solveB(_ input: Input) -> String {
        let insts = input.lines.map(Instruction.init)
        let ship = ShipSimulation2()
        for instruction in insts {
            ship.perform(instruction)
        }
        let result = ship.location.manhattanDistance(to: .zero)
        return "\(result)"
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("""
                    F10
                    N3
                    F7
                    R90
                    F11
                    """), expectedOutput: "286")
    ]
    
    class ShipSimulation {
        var location: GridCoordinate = .zero
        var facingDirection: GridVector = .east
        
        func perform(_ instruction: Instruction) {
            let value = instruction.value
            switch instruction.operation {
            case .N:
                location.move(.north * value)
            case .S:
                location.move(.south * value)
            case .E:
                location.move(.east * value)
            case .W:
                location.move(.west * value)
            case .L:
                let turns = instruction.value / 90
                for _ in 0..<turns {
                    facingDirection.quarterTurnLeft()
                }
            case .R:
                let turns = instruction.value / 90
                for _ in 0..<turns {
                    facingDirection.quarterTurnRight()
                }
            case .F:
                location.move(facingDirection * value)
            }
        }
    }
    
    class ShipSimulation2 {
        var location: GridCoordinate = .zero
        var waypoint: GridVector = .north + (.east * 10)
        
        func perform(_ instruction: Instruction) {
            let value = instruction.value
            switch instruction.operation {
            case .N:
                waypoint += .north * value
            case .S:
                waypoint += .south * value
            case .E:
                waypoint += .east * value
            case .W:
                waypoint += .west * value
            case .L:
                let turns = instruction.value / 90
                for _ in 0..<turns {
                    waypoint.quarterTurnLeft()
                }
            case .R:
                let turns = instruction.value / 90
                for _ in 0..<turns {
                    waypoint.quarterTurnRight()
                }
            case .F:
                location.move(waypoint * value)
            }
        }
    }
    
    struct Instruction {
        enum Operation: String {
            case N
            case S
            case E
            case W
            case L
            case R
            case F
        }
        
        var operation: Operation
        var value: Int
        
        init(_ descriptor: String) {
            let parts = regexParse("^([NSEWLRF])(\\d+)")(descriptor)!
            self.operation = Operation(rawValue: parts[0])!
            self.value = Int(parts[1])!
        }
    }

}
