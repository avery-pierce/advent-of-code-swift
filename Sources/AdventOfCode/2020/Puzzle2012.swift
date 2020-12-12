
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
            switch instruction.operation {
            case .N:
                location = location.moved(by: GridVector.north.multiplied(by: instruction.value))
            case .S:
                location = location.moved(by: GridVector.south.multiplied(by: instruction.value))
            case .E:
                location = location.moved(by: GridVector.east.multiplied(by: instruction.value))
            case .W:
                location = location.moved(by: GridVector.west.multiplied(by: instruction.value))
            case .L:
                let turns = instruction.value / 90
                for _ in 0..<turns {
                    turnLeft()
                }
            case .R:
                let turns = instruction.value / 90
                for _ in 0..<turns {
                    turnRight()
                }
            case .F:
                location = location.moved(by: facingDirection.multiplied(by: instruction.value))
            }
        }
        
        func turnLeft() {
            switch facingDirection {
            case .east:
                facingDirection = .north
            case .north:
                facingDirection = .west
            case .west:
                facingDirection = .south
            case .south:
                facingDirection = .east
            default:
                break
            }
        }
        
        func turnRight() {
            switch facingDirection {
            case .east:
                facingDirection = .south
            case .north:
                facingDirection = .east
            case .west:
                facingDirection = .north
            case .south:
                facingDirection = .west
            default:
                break
            }
        }
    }
    
    class ShipSimulation2 {
        var location: GridCoordinate = .zero
        var waypoint: GridVector = GridVector.north + GridVector.east.multiplied(by: 10)
        
        func perform(_ instruction: Instruction) {
            switch instruction.operation {
            case .N:
                waypoint = waypoint + GridVector.north.multiplied(by: instruction.value)
            case .S:
                waypoint = waypoint + GridVector.south.multiplied(by: instruction.value)
            case .E:
                waypoint = waypoint + GridVector.east.multiplied(by: instruction.value)
            case .W:
                waypoint = waypoint + GridVector.west.multiplied(by: instruction.value)
            case .L:
                let turns = instruction.value / 90
                for _ in 0..<turns {
                    turnLeft()
                }
            case .R:
                let turns = instruction.value / 90
                for _ in 0..<turns {
                    turnRight()
                }
            case .F:
                location = location.moved(by: waypoint.multiplied(by: instruction.value))
            }
        }
        
        func turnLeft() {
            var newWaypoint = waypoint
            newWaypoint.dx = waypoint.dy
            newWaypoint.dy = waypoint.dx * -1
            waypoint = newWaypoint
        }
        
        func turnRight() {
            var newWaypoint = waypoint
            newWaypoint.dx = waypoint.dy * -1
            newWaypoint.dy = waypoint.dx
            waypoint = newWaypoint
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
