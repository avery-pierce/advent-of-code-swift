
import Foundation

class Puzzle2009: Puzzle {
    let name: String = "2020_09"
    
    func solveA(_ input: Input) -> String {
        let ints = input.lines.compactMap(Int.init)
        
        // The example has a preable length of 5.
        let preambleLength = ints[0] == 35 ? 5 : 25
        let scanner = Scanner(ints, preambleLength: preambleLength)
        scanner.runUntilInvalid()
        return "\(scanner.valueAtCursor)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    35
                    20
                    15
                    25
                    47
                    40
                    62
                    55
                    65
                    95
                    102
                    117
                    150
                    182
                    127
                    219
                    299
                    277
                    309
                    576
                    """), expectedOutput: "127")
    ]
    
    func solveB(_ input: Input) -> String {
        let prevAnswer = Int(solveA(input))!
        let ints = input.lines.compactMap(Int.init)
        
        // The example has a preable length of 5.
        let preambleLength = ints[0] == 35 ? 5 : 25
        let scanner = Scanner(ints, preambleLength: preambleLength)
        
        let range = scanner.findContiguousRange(withSum: prevAnswer)
        let min = range.min()!
        let max = range.max()!
        return "\(min + max)"
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("""
                    35
                    20
                    15
                    25
                    47
                    40
                    62
                    55
                    65
                    95
                    102
                    117
                    150
                    182
                    127
                    219
                    299
                    277
                    309
                    576
                    """), expectedOutput: "62")
    ]
    
    class Scanner {
        var preambleLength: Int
        var input: [Int]
        var cursor: Int = 0
        init(_ input: [Int], preambleLength: Int = 25) {
            self.input = input
            self.preambleLength = preambleLength
        }
        
        var currentWindow: [Int] {
            let startIndex = cursor - preambleLength
            return Array(input[startIndex..<cursor])
        }
        
        var valueAtCursor: Int {
            return input[cursor]
        }
        
        var valueAtCursorIsValid: Bool {
            let win = currentWindow
            for x in win {
                for y in win {
                    if x == y { continue }
                    if x + y == valueAtCursor { return true }
                }
            }
            return false
        }
        
        func runUntilInvalid() {
            cursor = preambleLength
            while valueAtCursorIsValid && cursor < input.count {
                cursor += 1
            }
        }
        
        func findContiguousRange(withSum sum: Int) -> [Int] {
            for i in (0..<input.count) {
                cursor = i
                var testSum = [Int]()
                
                while testSum.reduce(0, +) < sum {
                    testSum.append(valueAtCursor)
                    cursor += 1
                }
                
                if (testSum.reduce(0, +) == sum) {
                    return testSum
                }
            }
            return []
        }
    }
}
