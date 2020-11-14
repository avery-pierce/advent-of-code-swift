
import Foundation

class Puzzle1801: Puzzle {
    let name: String = "2018_01"
    
    func solveA(_ input: Input) -> String {
        let ints = input.lines.compactMap(Int.init)
        let sum = ints.reduce(0, +)
        return "\(sum)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(LinesInput("+1, -2, +3, +1".split(separator: ",").map(String.init)), expectedOutput: "3"),
        TestCase(LinesInput("+1, +1, +1".split(separator: ",").map(String.init)), expectedOutput: "3"),
        TestCase(LinesInput("+1, +1, -2".split(separator: ",").map(String.init)), expectedOutput: "0"),
        TestCase(LinesInput("-1, -2, -3".split(separator: ",").map(String.init)), expectedOutput: "-6"),
    ]
    
    func solveB(_ input: Input) -> String {
        var counter = 0
        var state = 0
        var frequencies = Set<Int>([0])
        while true {
            let index = counter % input.lines.count
            let nextAdjustment = Int(input.lines[index])!
            state += nextAdjustment
            if frequencies.contains(state) {
                break
            }
            frequencies.insert(state)
            counter += 1
        }
        
        return "\(state)"
    }
    
    var testCasesB: [TestCase] = [
        TestCase(LinesInput("+1, -2, +3, +1".split(separator: ",").map(String.init)), expectedOutput: "2"),
        TestCase(LinesInput("+1, -1".split(separator: ",").map(String.init)), expectedOutput: "0"),
        TestCase(LinesInput("+3, +3, +4, -2, -4".split(separator: ",").map(String.init)), expectedOutput: "10"),
        TestCase(LinesInput("-6, +3, +8, +5, -6".split(separator: ",").map(String.init)), expectedOutput: "5"),
        TestCase(LinesInput("+7, +7, -2, -7, -4".split(separator: ",").map(String.init)), expectedOutput: "14"),
    ]
}
