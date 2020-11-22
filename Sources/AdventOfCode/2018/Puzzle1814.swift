
import Foundation

class Puzzle1814: Puzzle {
    let name: String = "2018_14"
    
    func solveA(_ input: Input) -> String {
        let simulation = Simulation()
        
        let cycles = Int(input.text)!
        while simulation.scores.count < cycles + 10 {
            simulation.tick()
        }
        
        let result = simulation.scores[cycles..<(cycles+10)].map(String.init).joined()
        return result
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("9"), expectedOutput: "5158916779"),
        TestCase(TextInput("5"), expectedOutput: "0124515891"),
        TestCase(TextInput("18"), expectedOutput: "9251071085"),
        TestCase(TextInput("2018"), expectedOutput: "5941429882"),
    ]
    
    func solveB(_ input: Input) -> String {
        let check = input.text.map({ Int(String($0)) })
        let simulation = Simulation()
        
        while true {
            simulation.tick()
            
            let scoreCount = simulation.scores.count
            if scoreCount < check.count { continue }
            
            let startIndex = scoreCount - check.count
            let subrange = Array(simulation.scores[startIndex..<scoreCount])
            if (subrange == check) {
                return "\(startIndex)"
            }
            
            if scoreCount - 1 < check.count { continue }
            
            let altSubrange = Array(simulation.scores[(startIndex-1)..<(scoreCount-1)])
            if (altSubrange == check) {
                return "\(startIndex-1)"
            }
        }
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("51589"), expectedOutput: "9"),
        TestCase(TextInput("15891"), expectedOutput: "10"),
        TestCase(TextInput("01245"), expectedOutput: "5"),
        TestCase(TextInput("92510"), expectedOutput: "18"),
        TestCase(TextInput("59414"), expectedOutput: "2018"),
    ]
    
    class Simulation {
        var scores: [Int] = [3, 7]
        var firstElfIndex = 0
        var secondElfIndex = 1
        
        func tick() {
            let combination = combineRecipes()
            addToScoreboard(combinedRecipe: combination)
            moveElvesToNextRecipe()
        }
        
        func combineRecipes() -> Int {
            return scores[firstElfIndex] + scores[secondElfIndex]
        }
        
        func addToScoreboard(combinedRecipe: Int) {
            let newScores = digits(of: combinedRecipe)
            scores.append(contentsOf: newScores)
        }
        
        func moveElvesToNextRecipe() {
            let firstElfScore = scores[firstElfIndex]
            let firstElfMovement = firstElfScore + 1
            firstElfIndex = normalizeIndex(firstElfIndex + firstElfMovement)
            
            let secondElfScore = scores[secondElfIndex]
            let secondElfMovement = secondElfScore + 1
            secondElfIndex = normalizeIndex(secondElfIndex + secondElfMovement)
        }
        
        func normalizeIndex(_ index: Int) -> Int {
            return index % scores.count
        }
    }
}

func digits(of number: Int) -> [Int] {
    if (number < 10) {
        return [number]
    }
    
    let onesDigit = number % 10
    let multipleOfTen = number - onesDigit
    let poweredDown = multipleOfTen / 10
    
    var result = digits(of: poweredDown)
    result.append(onesDigit)
    return result
}
