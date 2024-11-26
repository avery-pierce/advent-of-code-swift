
import Foundation
import AdventOfCode

class Puzzle1802: Puzzle {
    let name: String = "2018_02"
    
    func solveA(_ input: Input) -> String {
        let letterFrequencies = input.lines.map(Frequency<Character>.init)
        let containsDuplicate = letterFrequencies.filter({ $0.values(where: { $0 == 2 }).count > 0 })
        let containsTriplicate = letterFrequencies.filter({ $0.values(where: { $0 == 3 }).count > 0 })
        
        let checksum = containsDuplicate.count * containsTriplicate.count
        return "\(checksum)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(LinesInput([
            "abcdef",
            "bababc",
            "abbcde",
            "abcccd",
            "aabcdd",
            "abcdee",
            "ababab",
        ]), expectedOutput: "12")
    ]
    
    func solveB(_ input: Input) -> String {
        for (outerIndex, binIdA) in input.lines.enumerated() {
            for binIdB in input.lines[outerIndex...] {
                let charPairs = zip(binIdA, binIdB)
                let exactMatches = charPairs.filter({ $0.0 == $0.1 })
                if exactMatches.count == binIdA.count - 1 {
                    let commonChars = exactMatches.map({ $0.0 })
                    return String(commonChars)
                }
            }
        }
        return "not found"
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("""
                    abcde
                    fghij
                    klmno
                    pqrst
                    fguij
                    axcye
                    wvxyz
                    """),
                 expectedOutput: "fgij")
    ]
}

