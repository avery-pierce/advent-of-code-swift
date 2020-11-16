
import Foundation

class Puzzle1809: Puzzle {
    let name: String = "2018_09"
    
    func solveA(_ input: Input) -> String {
        return "unsolved"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("10 players; last marble is worth 1618 points"), expectedOutput: "8317"),
        TestCase(TextInput("13 players; last marble is worth 7999 points"), expectedOutput: "146373"),
        TestCase(TextInput("17 players; last marble is worth 1104 points"), expectedOutput: "2764"),
        TestCase(TextInput("21 players; last marble is worth 6111 points"), expectedOutput: "54718"),
        TestCase(TextInput("30 players; last marble is worth 5807 points"), expectedOutput: "37305"),
    ]
    
    func solveB(_ input: Input) -> String {
        return "unsolved"
    }
    
    var testCasesB: [TestCase] = [
        // Input test cases here
    ]
}
