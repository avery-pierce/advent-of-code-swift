
import Foundation
import AdventOfCode

class Puzzle2001: Puzzle {
    let name: String = "2020_01"
    
    func solveA(_ input: Input) -> String {
        let ints = input.lines.compactMap(Int.init)
        for a in ints {
            for b in ints {
                if a != b && a + b == 2020 {
                    return "\(a*b)"
                }
            }
        }
        return "??"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    1721
                    979
                    366
                    299
                    675
                    1456
                    """), expectedOutput: "514579")
    ]
    
    func solveB(_ input: Input) -> String {
        let ints = input.lines.compactMap(Int.init)
        for a in ints {
            for b in ints {
                if a != b {
                    for c in ints {
                        if a != c && b != c && a + b + c == 2020 {
                            return "\(a * b * c)"
                        }
                    }
                }
            }
        }
        return ""
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("""
                    1721
                    979
                    366
                    299
                    675
                    1456
                    """), expectedOutput: "241861950")
    ]
}
