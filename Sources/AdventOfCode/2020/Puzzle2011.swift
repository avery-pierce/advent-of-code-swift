
import Foundation

class Puzzle2011: Puzzle {
    let name: String = "2020_11"
    
    func solveA(_ input: Input) -> String {
        let grid = input.grid.mapValues { (char) -> Space in
            switch char {
            case "L": return .emptySeat
            default: return .floor
            }
        }
        
        let sim = SeatSimulation(grid)
        sim.runUntilNoChanges()
        let freq = Frequency(sim.state.values)
        
        return "\(freq[.filledSeat])"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    L.LL.LL.LL
                    LLLLLLL.LL
                    L.L.L..L..
                    LLLL.LL.LL
                    L.LL.LL.LL
                    L.LLLLL.LL
                    ..L.L.....
                    LLLLLLLLLL
                    L.LLLLLL.L
                    L.LLLLL.LL
                    """), expectedOutput: "37")
    ]
    
    func solveB(_ input: Input) -> String {
        return "unsolved"
    }
    
    var testCasesB: [TestCase] = [
        // Input test cases here
    ]
    
    class SeatSimulation {
        var state: [GridCoordinate: Space]
        init(_ initialState: [GridCoordinate: Space]) {
            self.state = initialState
        }
        
        func runUntilNoChanges() {
            while true {
                let prevState = state
                iterate()
                if prevState == state {
                    return
                }
            }
        }
        
        func iterate() {
            var nextState = state
            for (coord, _) in state {
                nextState[coord] = newState(of: coord)
            }
            state = nextState
        }
        
        func coords(adjacentTo coord: GridCoordinate) -> Set<GridCoordinate> {
            let allDirections: [GridVector] = [
                .up,
                .down,
                .left,
                .right,
                .up + .left,
                .up + .right,
                .down + .left,
                .down + .right,
            ]
            let coords = allDirections.map(coord.moved(by:))
            return Set(coords)
        }
        
        func seats(adjacentTo coord: GridCoordinate) -> Frequency<Space> {
            return Frequency(coords(adjacentTo: coord).map(seat(at:)))
        }
        
        func seat(at coord: GridCoordinate) -> Space {
            return state[coord] ?? .floor
        }
        
        func newState(of coord: GridCoordinate) -> Space {
            let thisSeat = seat(at: coord)
            let adjacentSeats = seats(adjacentTo: coord)
            
            if (thisSeat == .emptySeat && adjacentSeats[.filledSeat] == 0) {
                return .filledSeat
            }
            
            if (thisSeat == .filledSeat && adjacentSeats[.filledSeat] >= 4) {
                return .emptySeat
            }
            
            return thisSeat
        }
    }
    
    enum Space {
        case floor
        case emptySeat
        case filledSeat
    }
}
