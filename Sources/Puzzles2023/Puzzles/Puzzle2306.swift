
import Foundation
import AdventOfCode

class Puzzle2306: Puzzle {
    let name: String = "2023_06"
    
    func solveA(_ input: Input) -> String {
        let races = Race.from(input.lines)
        let product = races
            .map(\.winningCombinations)
            .reduce(1, *)

        return String(product)
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
Time:      7  15   30
Distance:  9  40  200
"""), expectedOutput: "288")
    ]
    
    func solveB(_ input: Input) -> String {
        let value = Race.flatten(input.lines).winningCombinations
        return String(value)
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("""
Time:      7  15   30
Distance:  9  40  200
"""), expectedOutput: "71503")
    ]
    
    struct Race {
        var time: Int
        var distance: Int
        
        static func from(_ input: [String]) -> [Race] {
            let times = input[0].split(separator: " ")
                .map(String.init)
                .compactMap(Int.init)
            
            let distances = input[1].split(separator: " ")
                .map(String.init)
                .compactMap(Int.init)
            
            return zip(times, distances).map(Race.init)
        }
        
        static func flatten(_ input: [String]) -> Race {
            let timeString = input[0].split(separator: " ")
                .map(String.init)
                .compactMap(Int.init)
                .map(String.init)
                .joined()
            
            let time = Int(timeString)
            
            let distanceString = input[1].split(separator: " ")
                .map(String.init)
                .compactMap(Int.init)
                .map(String.init)
                .joined()
            
            let distance = Int(distanceString)
            
            return Race(time: time!, distance: distance!)
        }
        
        init(time: Int, distance: Int) {
            self.time = time
            self.distance = distance
        }
        
        var winningCombinations: Int {
            (0..<time)
                .map(distanceTraveled(whileHolding:))
                .filter({ $0 > distance })
                .count
        }
        
        func distanceTraveled(whileHolding duration: Int) -> Int {
            let speed = duration // 1 mm per ms
            let remainingTime = time - duration
            
            return speed * remainingTime
        }
    }
}
