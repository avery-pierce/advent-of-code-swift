
import Foundation
import AdventOfCode

class Puzzle2302: Puzzle {
    let name: String = "2023_02"
    
    func solveA(_ input: Input) -> String {
        let games = input.lines.map({ Game(descriptor: $0) })
        
        let possibleGames = games.filter { game in
            return game.canBePlayed(with: bag(red: 12, green: 13, blue: 14))
        }
        
        let sum = possibleGames.map(\.id).reduce(0, +)
        return String(sum)
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
"""), expectedOutput: "8")
    ]
    
    func solveB(_ input: Input) -> String {
        let games = input.lines.map({ Game(descriptor: $0) })
        
        let sum = games
            .map(\.smallestPossibleBag)
            .map(computePower(of:))
            .reduce(0, +)
        
        return String(sum)
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("""
Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
"""), expectedOutput: "2286")
    ]
    
    enum Color: String {
        case red = "red"
        case blue = "blue"
        case green = "green"
    }
    
    func bag(red: Int, green: Int, blue: Int) -> Frequency<Color> {
        var freq = Frequency<Color>()
        freq[.blue] = blue
        freq[.green] = green
        freq[.red] = red
        return freq
    }
    
    func computePower(of pull: Frequency<Color>) -> Int {
        return pull[.red] * pull[.blue] * pull[.green]
    }

    struct Game {
        let id: Int
        var rounds: [Frequency<Color>]
        
        init(descriptor: String) {
            let values = regexParse("Game (\\d+): (.*)")(descriptor)!
            id = Int(values[0]) ?? 0
            rounds = values[1].split(separator: ";")
                .map({ $0.trimmingCharacters(in: .whitespaces) })
                .map({ Game.pull(descriptor: $0) })
        }
        
        func canBePlayed(with bag: Frequency<Color>) -> Bool {
            return rounds.allSatisfy { round in
                return bag[.red] >= round[.red] &&
                    bag[.blue] >= round[.blue] &&
                    bag[.green] >= round[.green]
            }
        }
        
        var smallestPossibleBag: Frequency<Color> {
            rounds.reduce(Frequency<Color>()) { partialResult, round in
                var freq = Frequency<Color>()
                freq[.red] = max(partialResult[.red], round[.red])
                freq[.blue] = max(partialResult[.blue], round[.blue])
                freq[.green] = max(partialResult[.green], round[.green])
                return freq
            }
        }
        
        static func pull(descriptor: String) -> Frequency<Color> {
            let parse = regexParse("(\\d+) (red|green|blue)")
            
            let draws = descriptor
                .split(separator: ",")
                .map({ $0.trimmingCharacters(in: .whitespaces) })
            
            var freq = Frequency<Color>()
            for draw in draws {
                let args = parse(draw)!
                let count = Int(args[0]) ?? 0
                let color = Color(rawValue: args[1])!
                freq[color] = count
            }
            
            return freq
        }
    }
}
