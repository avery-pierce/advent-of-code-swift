
import Foundation

class Puzzle2010: Puzzle {
    let name: String = "2020_10"
    
    func solveA(_ input: Input) -> String {
        var ints = input.lines.compactMap(Int.init).sorted()
        ints.insert(0, at: 0)
        let builtin = ints.max()! + 3
        ints.append(builtin)
        
        let d = deltas(ints)
        let freq = Frequency(d)
        return "\(freq[1] * freq[3])"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    16
                    10
                    15
                    5
                    1
                    11
                    7
                    19
                    6
                    12
                    4
                    """), expectedOutput: "\(7 * 5)"),
        TestCase(TextInput("""
                    28
                    33
                    18
                    42
                    31
                    14
                    46
                    20
                    48
                    47
                    24
                    23
                    49
                    45
                    19
                    38
                    39
                    11
                    1
                    32
                    25
                    35
                    8
                    17
                    7
                    9
                    4
                    2
                    34
                    10
                    3
                    """), expectedOutput: "\(22 * 10)")
    ]
    
    func solveB(_ input: Input) -> String {
        var ints = input.lines.compactMap(Int.init).sorted()
        ints.insert(0, at: 0)
        let builtin = ints.max()! + 3
        ints.append(builtin)
        
        let d = deltas(ints)
        
        let groups = d.split(separator: 3)
        
        let countPermutations = groups.map { (group) -> Int in
            var acc = 1
            if group.count >= 2 { acc += 1 }
            if group.count >= 3 { acc += 2 }
            if group.count >= 4 { acc += 3 }
            if group.count >= 5 {
                // Puzzle input doesn't have any groups longer than 4
                fatalError()
            }
            return acc
        }
        return "\(countPermutations.reduce(1, *))"
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("""
                    16
                    10
                    15
                    5
                    1
                    11
                    7
                    19
                    6
                    12
                    4
                    """), expectedOutput: "8"),
        TestCase(TextInput("""
                    28
                    33
                    18
                    42
                    31
                    14
                    46
                    20
                    48
                    47
                    24
                    23
                    49
                    45
                    19
                    38
                    39
                    11
                    1
                    32
                    25
                    35
                    8
                    17
                    7
                    9
                    4
                    2
                    34
                    10
                    3
                    """), expectedOutput: "19208")
    ]
    
    func deltas(_ ints: [Int]) -> [Int] {
        var d = [Int]()
        for (i, x) in ints.enumerated() {
            guard i + 1 < ints.count else { break }
            let y = ints[i + 1]
            d.append(y - x)
        }
        return d
    }
}
