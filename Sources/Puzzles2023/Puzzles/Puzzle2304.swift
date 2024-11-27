
import Foundation
import AdventOfCode

class Puzzle2304: Puzzle {
    let name: String = "2023_04"
    
    func solveA(_ input: Input) -> String {
        let score = input.lines
            .map(Scratcher.init(descriptor:))
            .map(\.score)
            .reduce(0, +)
        return String(score)
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
"""), expectedOutput: "13")
    ]
    
    func solveB(_ input: Input) -> String {
        let scratchers = input.lines
            .map(Scratcher.init(descriptor:))
        
        let solver = Solver(scratchers)
        solver.solve()
        
        return String(solver.finalCount)
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("""
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
"""), expectedOutput: "30")
    ]
    
    class Solver {
        var multiplier = Frequency<Int>()
        var scratchers: [Scratcher]
        
        init(_ scratchers: [Scratcher]) {
            self.scratchers = scratchers
        }
        
        func solve() {
            multiplier = Frequency<Int>()
            for scratcher in scratchers {
                multiplier[scratcher.id] += 1
                
                let mult = multiplier[scratcher.id]
                
                multiplier = multiplier + (scratcher.cardCopies * mult)
            }
        }
        
        var finalCount: Int {
            return multiplier.total
        }
    }
    
    struct Scratcher {
        let id: Int
        var winningNumbers: Set<Int>
        var myNumbers: Set<Int>
        
        init(descriptor: String) {
            let args = regexParse("Card\\s+(\\d+): (.*)\\|(.*)")(descriptor)!
            id = Int(args[0])!
            
            self.winningNumbers = Set(args[1]
                .split(separator: " ")
                .compactMap({ Int($0) }))
            
            self.myNumbers = Set(args[2]
                .split(separator: " ")
                .compactMap({ Int($0) }))
        }
        
        var matches: Int {
            let value = winningNumbers.intersection(myNumbers).count
            return value
        }
        
        var score: Int {
            guard matches > 0 else { return 0 }
            
            var value = 1
            
            for _ in (1..<matches) {
                value = value * 2
            }
            
            return value
        }
        
        var cardCopies: Frequency<Int> {
            var freq = Frequency<Int>()
            
            var spread = matches
            while spread > 0 {
                freq.increment(id + spread)
                spread -= 1
            }
            
            return freq
        }
    }
}
