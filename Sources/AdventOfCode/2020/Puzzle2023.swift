
import Foundation

class Puzzle2023: Puzzle {
    let name: String = "2020_23"
    
    func solveA(_ input: Input) -> String {
        let cups = input.text.map(String.init).compactMap(Int.init)
        let sim = CupSimulation2(cups)
        for _ in (0..<100) {
            sim.doMove()
        }
        return sim.solve1()
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("389125467"), expectedOutput: "67384529")
    ]
    
    func solveB(_ input: Input) -> String {
        var cups = input.text.map(String.init).compactMap(Int.init)
        cups.append(contentsOf: ((cups.max()! + 1)..<1_000_000))
        print("Number of cups", cups.count)
        
        let sim = CupSimulation2(cups)
        
        for i in 0..<10_000_000 {
            sim.doMove()
            if i % 100 == 0 {
                print("Move \(i)")
            }
        }
        
        return ""
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("389125467"), expectedOutput: "149245887792")
    ]
    
    class CupSimulation2 {
        var currentCup: Int
        var cupAfter: [Int /* this cup */: Int /* Next cup */]
        var highestCup: Int
        
        init(_ cups: [Int]) {
            cupAfter = [:]
            for (i, cup) in cups.enumerated() {
                let nextCupIndex = (i + 1) % cups.count
                let nextCup = cups[nextCupIndex]
                cupAfter[cup] = nextCup
            }
            
            self.currentCup = cups[0]
            self.highestCup = cups.max()!
        }
        
        func destinationCup(excludingPickedUpCups pickedUpCups: [Int]) -> Int {
            var expectedCup = currentCup
            while true {
                expectedCup -= 1
                if (expectedCup < 1) {
                    expectedCup = highestCup
                }
                
                if (!pickedUpCups.contains(expectedCup)) {
                    return expectedCup
                }
            }
        }
        
        func doMove() {
            let firstThreeCups = [
                cupAfter[currentCup]!,
                cupAfter[cupAfter[currentCup]!]!,
                cupAfter[cupAfter[cupAfter[currentCup]!]!]!,
            ]
            
            let destination = destinationCup(excludingPickedUpCups: firstThreeCups)
            let afterDestination = cupAfter[destination]
            
//            print("Taking 3 cups: \(firstThreeCups)")
//            print("Destination Cup: \(destination)")
            
            
            // fill in the gap where the three cups used to be
            cupAfter[currentCup] = cupAfter[firstThreeCups[2]]
            
            // The destination cup now points to the first cup in the set we removed
            cupAfter[destination] = firstThreeCups[0]
            
            // The cup after the third picked up cup points to the cup that was previously after the destination cup
            cupAfter[firstThreeCups[2]] = afterDestination
            
            rotateCurrentCup()
        }
        
        func rotateCurrentCup() {
            currentCup = cupAfter[currentCup]!
        }
        
        func solve1() -> String {
            var output = [Int]()
            var nextCup = cupAfter[1]!
            for _ in (0..<8) {
                output.append(nextCup)
                nextCup = cupAfter[nextCup]!
            }
            
           let chars = output
                .compactMap(String.init)
                .map(Character.init)
            
            return String(chars)
        }
        
        var result: String {
            let cupsAfter1 = [
                cupAfter[1]!,
                cupAfter[cupAfter[1]!]!,
            ]
            let product = cupsAfter1.reduce(1, *)
            return "\(product)"
        }
    }
}
