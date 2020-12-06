
import Foundation

class Puzzle2006: Puzzle {
    let name: String = "2020_06"
    
    func solveA(_ input: Input) -> String {
        let groups = input.lines.split(separator: "")
        let sets = groups.map { (group) -> Set<Character> in
            var set = Set<Character>()
            for member in group {
                set.insert(membersOf: member)
            }
            return set
        }
        let sum = sets.map(\.count).reduce(0, +)
        return "\(sum)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    abc
                    
                    a
                    b
                    c
                    
                    ab
                    ac
                    
                    a
                    a
                    a
                    a
                    
                    b
                    """), expectedOutput: "11")
    ]
    
    func solveB(_ input: Input) -> String {
        let groups = input.lines.split(separator: "")
        let sets = groups.map { (group) -> Set<Character> in
            var freq = Frequency<Character>()
            for member in group {
                freq.increment(membersOf: member)
            }
            
            let matches = freq.values(where: { $0 == group.count})
            return matches
        }
        
        
        let sum = sets.map(\.count).reduce(0, +)
        return "\(sum)"
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("""
                    abc
                    
                    a
                    b
                    c
                    
                    ab
                    ac
                    
                    a
                    a
                    a
                    a
                    
                    b
                    """), expectedOutput: "6")
    ]
}
