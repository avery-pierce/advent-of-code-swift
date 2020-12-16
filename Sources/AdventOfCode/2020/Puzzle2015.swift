
import Foundation

class Puzzle2015: Puzzle {
    let name: String = "2020_15"
    
    func solveA(_ input: Input) -> String {
        let startingNumbers = input.text.split(separator: ",").map(String.init).compactMap(Int.init)
        
        let game = ElfGame(startingNumbers)
        game.play(until: 2020)
        
        return "\(game.spokenNumbers.last!)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("0,3,6"), expectedOutput: "436"),
        TestCase(TextInput("1,3,2"), expectedOutput: "1"),
        TestCase(TextInput("2,1,3"), expectedOutput: "10"),
        TestCase(TextInput("1,2,3"), expectedOutput: "27"),
        TestCase(TextInput("2,3,1"), expectedOutput: "78"),
        TestCase(TextInput("3,2,1"), expectedOutput: "438"),
        TestCase(TextInput("3,1,2"), expectedOutput: "1836"),
    ]
    
    func solveB(_ input: Input) -> String {
        let startingNumbers = input.text.split(separator: ",").map(String.init).compactMap(Int.init)
        
        let game = ElfGame(startingNumbers)
        game.play(until: 30000000)
        
        return "\(game.spokenNumbers.last!)"
    }
    
    var testCasesB: [TestCase] = [
//        TestCase(TextInput("0,3,6"), expectedOutput: "175594"),
//        TestCase(TextInput("1,3,2"), expectedOutput: "2578"),
//        TestCase(TextInput("2,1,3"), expectedOutput: "3544142"),
//        TestCase(TextInput("1,2,3"), expectedOutput: "261214"),
//        TestCase(TextInput("2,3,1"), expectedOutput: "6895259"),
//        TestCase(TextInput("3,2,1"), expectedOutput: "18"),
//        TestCase(TextInput("3,1,2"), expectedOutput: "362"),
    ]
    
    class ElfGame {
        private(set) var spokenNumbers = [Int]()
        private(set) var lastTimeSpoken = [Int: Int]()
        private(set) var lastNumber: Int! = nil
        
        init(_ startingNumbers: [Int]) {
            for num in startingNumbers {
                speakNumber(num)
            }
        }
        
        func play(until spokenNumber: Int) {
            while spokenNumbers.count < spokenNumber {
                takeTurn()
            }
        }
        
        func takeTurn() {
            let num = nextNumberFast()
            speakNumber(num)
        }
        
        func speakNumber(_ num: Int) {
            if let lastNumber = lastNumber {
                lastTimeSpoken[lastNumber] = spokenNumbers.count
            }
            
            spokenNumbers.append(num)
            lastNumber = num
        }
        
        func nextNumberSlow() -> Int {
            guard spokenNumbers.count > 0 else { fatalError("spoken numbers is empty") }
            
            let lastNumber = spokenNumbers.last!
            let slice = spokenNumbers[0..<(spokenNumbers.count-1)]
            
            // If this is the first time this number is spoken, the next number is 0
            if !slice.contains(lastNumber) {
                return 0
            }
            
            let lastIndex = slice.lastIndex(of: lastNumber)!
            return slice.count - lastIndex
        }
        
        func nextNumberFast() -> Int {
            let lastNumber = spokenNumbers.last!
            guard let lastIndex = lastTimeSpoken[lastNumber] else { return 0 }
//            print("count - lastIndex = \(spokenNumbers.count) - \(lastIndex) = \(spokenNumbers.count - lastIndex)")
            return spokenNumbers.count - lastIndex
        }
    }
}
