
import Foundation

class Puzzle1809: Puzzle {
    let name: String = "2018_09"
    
    func solveA(_ input: Input) -> String {
//        return ""
        let words = input.text.split(separator: " ")
        let numberOfPlayers = Int(words[0])!
        let numberOfPoints = Int(words[6])!
        let game = MarbleGame(numberOfPlayers: numberOfPlayers, highestScoringMarble: numberOfPoints)
        game.playThrough()
        return "\(game.highestScore)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("9 players; last marble is worth 25 points"), expectedOutput: "32"),
        TestCase(TextInput("10 players; last marble is worth 1618 points"), expectedOutput: "8317"),
        TestCase(TextInput("13 players; last marble is worth 7999 points"), expectedOutput: "146373"),
        TestCase(TextInput("17 players; last marble is worth 1104 points"), expectedOutput: "2764"),
        TestCase(TextInput("21 players; last marble is worth 6111 points"), expectedOutput: "54718"),
        TestCase(TextInput("30 players; last marble is worth 5807 points"), expectedOutput: "37305"),
    ]
    
    func solveB(_ input: Input) -> String {
        let words = input.text.split(separator: " ")
        let numberOfPlayers = Int(words[0])!
        let numberOfPoints = Int(words[6])! * 100
        let game = MarbleGame(numberOfPlayers: numberOfPlayers, highestScoringMarble: numberOfPoints)
        game.playThrough()
        return "\(game.highestScore)"
    }
    
    var testCasesB: [TestCase] = [
        // Input test cases here
    ]
    
    struct CircularArray<T: Hashable & Equatable> {
        private(set) var array: [T]
        
        init(_ array: [T] = []) {
            self.array = array
        }
        
        subscript(_ index: Int) -> T {
            get {
                return array[resolve(index: index)]
            }
            set {
                array[resolve(index: index)] = newValue
            }
        }
        
        func resolve(index: Int) -> Int {
            guard array.count > 0 else { return 0 }
            var _index = index
            while _index <= 0 {
                _index += array.count
            }
            while _index >= array.count {
                _index -= array.count
            }
            return _index
        }
        
        mutating func insert(_ value: T, at index: Int) {
            array.insert(value, at: resolve(index: index))
        }
        
        mutating func remove(at index: Int) {
            array.remove(at: resolve(index: index))
        }
        
        func firstIndex(of element: T) -> Int? {
            return array.firstIndex(of: element)
        }
        
        var count: Int {
            return array.count
        }
    }
    
    struct Marble: Hashable, Equatable {
        var number: Int
        init(_ number: Int) {
            self.number = number
        }
    }
    
    class MarbleMat {
        var currentMarble: Marble!
        var currentMarbleIndex: Int! {
            get {
                return marbles.firstIndex(of: currentMarble)
            }
            set {
                guard let index = newValue else {
                    currentMarble = nil
                    return
                }
                
                currentMarble = marbles[index]
            }
        }
        var marbles: CircularArray<Marble>
        var drawPile: [Marble]
        
        init(numberOfMarbles: Int) {
            self.currentMarble = nil
            self.marbles = CircularArray()
            self.drawPile = (0..<numberOfMarbles).map(Marble.init)
        }
        
        // Adds a marble, and returns the number of points (if any) it awards.
        func addMarble() -> Int {
            guard let nextMarble = drawMarble() else { return 0 }
            if nextMarble.number == 0 {
                marbles.insert(nextMarble, at: 0)
                currentMarbleIndex = 0
                return 0
            }
            
            if (nextMarble.number % 23 == 0) {
                // Player keeps the marble
                let takeIndex = currentMarbleIndex - 7
                let nextCurrentMarble = marbles[takeIndex + 1]
                let scoringMarble = marbles[takeIndex]
                marbles.remove(at: takeIndex)
                currentMarble = nextCurrentMarble
                return nextMarble.number + scoringMarble.number
                
            } else {
                let insertIndex = currentMarbleIndex + 2
                marbles.insert(nextMarble, at: insertIndex)
                currentMarble = nextMarble
                return 0
            }
        }
        
        func drawMarble() -> Marble? {
            guard drawPile.count > 0 else { return nil }
            return drawPile.remove(at: 0)
        }
    }
    
    class MarbleGame {
        var numberOfPlayers: Int
        var highestScoringMarble: Int
        var scores: Frequency<Int> = Frequency()
        var gameMat: MarbleMat
        var turn: Int = 0
        
        init(numberOfPlayers: Int, highestScoringMarble: Int) {
            self.gameMat = MarbleMat(numberOfMarbles: highestScoringMarble + 1 /* marble "0" */)
            self.numberOfPlayers = numberOfPlayers
            self.highestScoringMarble = highestScoringMarble
        }
        
        func playThrough() {
            while turn <= highestScoringMarble {
                if (turn % 1000 == 0) {
//                    print("Turn #\(turn)/\(highestScoringMarble) (\(turn * 100/highestScoringMarble)%)")
                }
                let score = gameMat.addMarble()
                scores[currentPlayer] += score
                turn += 1
            }
        }
        
        var currentPlayer: Int {
            return turn % numberOfPlayers
        }
        
        var highestScore: Int {
            let playerIndex = scores.mostFrequent!
            return scores[playerIndex]
        }
    }
}
