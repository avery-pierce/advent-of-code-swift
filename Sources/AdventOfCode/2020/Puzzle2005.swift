
import Foundation

class Puzzle2005: Puzzle {
    let name: String = "2020_05"
    
    func solveA(_ input: Input) -> String {
        let seats = input.lines.map(Seat.init)
        let maxSeatId = seats.map(\.seatID).max()!
        return "\(maxSeatId)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("BFFFBBFRRR"), expectedOutput: "567"),
        TestCase(TextInput("FFFBBBFRRR"), expectedOutput: "119"),
        TestCase(TextInput("BBFFBBFRLL"), expectedOutput: "820"),
        TestCase(TextInput("""
                    BFFFBBFRRR
                    FFFBBBFRRR
                    BBFFBBFRLL
                    """), expectedOutput: "820")
    ]
    
    func solveB(_ input: Input) -> String {
        let seats = input.lines.map(Seat.init)
        let allIds = Set(seats.map(\.seatID))
        let sorted = seats.sorted(by: { $0.seatID < $1.seatID })
        
        let seatBeforeMine = sorted.first { (seat) -> Bool in
            let nextSeatId = seat.seatID + 1
            let followingSeatId = seat.seatID + 2
            return !allIds.contains(nextSeatId) && allIds.contains(followingSeatId)
        }
        return "\(seatBeforeMine!.seatID + 1)"
    }
    
    var testCasesB: [TestCase] = [
        // Input test cases here
    ]
    
    struct Seat {
        var row: Int
        var column: Int
        
        init(_ descriptor: String) {
            let startIndex = descriptor.startIndex
            let colIndex = descriptor.index(startIndex, offsetBy: 7)
            let rowString = descriptor[startIndex..<colIndex]
            let seatString = descriptor[colIndex...]
            
            self.row = Seat.parseRow(rowString)!
            self.column = Seat.parseColumn(seatString)!
        }
        
        static func parseRow<S: StringProtocol>(_ string: S) -> Int? {
            let binaryString = string.map({ $0 == "B" ? "1" : "0" }).joined()
            return Int(binaryString, radix: 2)
        }
        
        static func parseColumn<S: StringProtocol>(_ string: S) -> Int? {
            let binaryString = string.map({ $0 == "R" ? "1" : "0" }).joined()
            return Int(binaryString, radix: 2)
        }
        
        var seatID: Int {
            return (row * 8) + column
        }
    }
}
