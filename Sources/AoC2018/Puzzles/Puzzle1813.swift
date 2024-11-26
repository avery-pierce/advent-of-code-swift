
import Foundation
import AdventOfCode

class Puzzle1813: Puzzle {
    let name: String = "2018_13"
    
    func solveA(_ input: Input) -> String {
        let (tracks, carts) = parseInput(input)
        let sim = Simulation(trackPieces: tracks, carts: carts)
        sim.simulateUntilCollision()
        
        let coord = sim.collisionCoordinate!
        return "\(coord.x),\(coord.y)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    /->-\\
                    |   |  /----\\
                    | /-+--+-\\  |
                    | | |  | v  |
                    \\-+-/  \\-+--/
                      \\------/
                    """), expectedOutput: "7,3")
    ]
    
    func solveB(_ input: Input) -> String {
        let (tracks, carts) = parseInput(input)
        let sim = Simulation(trackPieces: tracks, carts: carts)
        sim.simulateUntilOneCartRemains()
        
        let cart = sim.carts[0]
        let coord = cart.coordinate
        return "\(coord.x),\(coord.y)"
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("""
                    />-<\\
                    |   |
                    | /<+-\\
                    | | | v
                    \\>+</ |
                      |   ^
                      \\<->/
                    """), expectedOutput: "6,4")
    ]
    
    class Simulation {
        var carts: [Cart]
        var trackPieces: [GridCoordinate: TrackPiece]
        var collisionCoordinate: GridCoordinate?
        
        init(trackPieces: [GridCoordinate: TrackPiece], carts: [Cart]) {
            self.trackPieces = trackPieces
            self.carts = carts
        }
        
        func tick() {
            sortCartsByTurnOrder()
            
            for cart in carts {
                guard !cart.crashed else { continue }
                
                cart.moveForward()
                guard let nextPiece = trackPieces[cart.coordinate] else {
                    print(cart.coordinate, cart.direction)
                    fatalError("off the track! \(cart)")
                }
                
                cart.arrivate(at: nextPiece)
                if collision(at: cart.coordinate) {
                    collisionCoordinate = cart.coordinate
                    carts(at: cart.coordinate).forEach({ $0.crashed = true })
                }
            }
            
            carts.removeAll(where: \.crashed)
        }
        
        func simulateUntilCollision() {
            var tickNumber = 0
            while collisionCoordinate == nil {
                tick()
                tickNumber += 1
            }
        }
        
        func simulateUntilOneCartRemains() {
            while carts.count > 1 {
                tick()
            }
        }
        
        func sortCartsByTurnOrder() {
            carts.sort { (left, right) -> Bool in
                if left.coordinate.y == right.coordinate.y {
                    return left.coordinate.x < right.coordinate.x
                } else {
                    return left.coordinate.y < right.coordinate.y
                }
            }
        }
        
        func carts(at coordinate: GridCoordinate) -> [Cart] {
            return carts.filter({ $0.coordinate == coordinate })
        }
        
        func collision(at coordinate: GridCoordinate) -> Bool {
            return carts(at: coordinate).count > 1
        }
    }
    
    enum Direction: Equatable, Hashable {
        case north
        case south
        case east
        case west
        
        var isHorizontal: Bool {
            return self == .east || self == .west
        }
        
        var isVertical: Bool {
            return !isHorizontal
        }
        
        static func from(char: Character) -> Direction! {
            switch char {
            case ">": return .east
            case "v": return .south
            case "<": return .west
            case "^": return .north
            default: return nil
            }
        }
        
        mutating func turnRight() {
            switch self {
            case .north: self = .east
            case .east: self = .south
            case .south: self = .west
            case .west: self = .north
            }
        }
        
        mutating func turnLeft() {
            switch self {
            case .north: self = .west
            case .west: self = .south
            case .south: self = .east
            case .east: self = .north
            }
        }
    }
    
    enum TurnDirection: Equatable, Hashable {
        case left
        case right
        case straight
    }
    
    class Cart {
        var direction: Direction
        var coordinate: GridCoordinate
        var nextTurn: TurnDirection = .left
        var crashed: Bool = false
        
        init(at coordinate: GridCoordinate, facing direction: Direction) {
            self.coordinate = coordinate
            self.direction = direction
        }
        
        func moveForward() {
            switch direction {
            case .north: coordinate.y -= 1
            case .south: coordinate.y += 1
            case .west: coordinate.x -= 1
            case .east: coordinate.x += 1
            }
        }
        
        func turnRight() {
            direction.turnRight()
//            print("\(coordinate) turned right to face \(direction)")
        }
        
        func turnLeft() {
            direction.turnLeft()
//            print("\(coordinate) turned left to face \(direction)")
        }
        
        func arriveAtIntersection() {
            switch nextTurn {
            case .left:
                turnLeft()
                nextTurn = .straight
            
            case .straight:
                nextTurn = .right
                
            case .right:
                turnRight()
                nextTurn = .left
            }
        }
        
        func arrivate(at piece: TrackPiece) {
            switch piece {
            case .intersection:
                arriveAtIntersection()
                
            case .cornerUp:
                if direction.isVertical {
                    turnRight()
                } else {
                    turnLeft()
                }
                
            case .cornerDown:
                if direction.isVertical {
                    turnLeft()
                } else {
                    turnRight()
                }
                
            case .vertical, .horizontal: break
            }
        }
    }
    
    enum TrackPiece {
        case horizontal // -
        case vertical   // |
        case cornerDown // \
        case cornerUp   // /
        case intersection // +
        
        static func from(char: Character) -> TrackPiece! {
            switch char {
            case "-": return .horizontal
            case "|": return .vertical
            case "\\": return .cornerDown
            case "/": return .cornerUp
            case "+": return .intersection
            default: return nil
            }
        }
    }
    
    func parseInput(_ input: Input) -> (tracks: [GridCoordinate: TrackPiece], carts: [Cart]) {
        var pieces = [GridCoordinate: TrackPiece]()
        var carts = [Cart]()
        
        for (y, line) in input.lines.enumerated() {
            for (x, char) in line.enumerated() {
                guard let result = parseCharacter(char) else { continue }
                let coordinate = GridCoordinate(x: x, y: y)
                
                pieces[coordinate] = result.trackPiece
                
                switch result {
                case .track: break
                case .cart(let direction):
                    carts.append(Cart(at: coordinate, facing: direction))
                }
            }
        }
        
        return (tracks: pieces, carts: carts)
    }
    
    enum ParsedCharacterResult {
        case cart(Direction)
        case track(TrackPiece)
        
        var trackPiece: TrackPiece {
            switch self {
            case .track(let t): return t
            case .cart(let d): return d.isVertical ? .vertical : .horizontal
            }
        }
    }
    
    func parseCharacter(_ char: Character) -> ParsedCharacterResult? {
        if char == " " {
            return nil
        } else if let trackPiece = TrackPiece.from(char: char) {
            return .track(trackPiece)
        } else if let direction = Direction.from(char: char) {
            return .cart(direction)
        } else {
            return nil
        }
    }
}
