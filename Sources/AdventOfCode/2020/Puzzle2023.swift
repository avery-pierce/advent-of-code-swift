
import Foundation

class Puzzle2023: Puzzle {
    let name: String = "2020_23"
    
    func solveA(_ input: Input) -> String {
        let cups = input.text.map(String.init).compactMap(Int.init)
        let sim = CupSimulation(cups)
        for _ in (0..<100) {
            sim.doMove()
        }
        return sim.solutionA()
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("389125467"), expectedOutput: "67384529")
    ]
    
    func solveB(_ input: Input) -> String {
        var cups = input.text.map(String.init).compactMap(Int.init)
        cups.append(contentsOf: ((cups.max()! + 1)...1_000_000))
        
        let sim = CupSimulation(cups)
        sim.move(times: 10_000_000)
        return sim.solutionB()
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("389125467"), expectedOutput: "149245887792")
    ]
    
    class CupSimulation {
        var currentCup: Int
        let cupAfter: ClassyArray<Int>
        let highestCup: Int
        
        init(_ cups: [Int]) {
            cupAfter = ClassyArray(repeating: 0, count: cups.count + 1)
            for (i, cup) in cups.enumerated() {
                let nextCupIndex = (i + 1) % cups.count
                let nextCup = cups[nextCupIndex]
                cupAfter[cup] = nextCup
            }
            
            self.currentCup = cups[0]
            self.highestCup = cups.max()!
        }
        
        func destinationCup(excludingPickedUpCups pickedUpCups: [Int]) -> Int {
            var destination = currentCup - 1
            while pickedUpCups.contains(destination) || destination < 1 {
                destination -= 1
                if destination < 1 {
                    destination = highestCup
                }
            }
            
            return destination
        }
        
        func move(times: Int) {
            for _ in 0..<times {
                doMove()
            }
        }
        
        func doMove() {
            let firstThreeCups = [
                cupAfter[currentCup],
                cupAfter[cupAfter[currentCup]],
                cupAfter[cupAfter[cupAfter[currentCup]]],
            ]
            
            let destination = destinationCup(excludingPickedUpCups: firstThreeCups)
            let afterDestination = cupAfter[destination]
            
            // fill in the gap where the three cups used to be
            cupAfter[currentCup] = cupAfter[firstThreeCups[2]]
            
            // The destination cup now points to the first cup in the set we removed
            cupAfter[destination] = firstThreeCups[0]
            
            // The cup after the third picked up cup points to the cup that was previously after the destination cup
            cupAfter[firstThreeCups[2]] = afterDestination
            
            rotateCurrentCup()
        }
        
        func rotateCurrentCup() {
            currentCup = cupAfter[currentCup]
        }
        
        func solutionA() -> String {
            var output = [Int]()
            var nextCup = cupAfter[1]
            for _ in (0..<8) {
                output.append(nextCup)
                nextCup = cupAfter[nextCup]
            }
            
           let chars = output
                .compactMap(String.init)
                .map(Character.init)
            
            return String(chars)
        }
        
        func solutionB() -> String {
            let cupsAfter1 = [
                cupAfter[1],
                cupAfter[cupAfter[1]],
            ]
            let product = cupsAfter1.reduce(1, *)
            return "\(product)"
        }
    }
    
    class Classy<Element> {
        var value: Element
        init(_ value: Element) {
            self.value = value
        }
    }
    
    class ClassyArray<Element> {
        let array: [Classy<Element>]
        init(repeating initialValue: Element, count: Int) {
            array = Array(repeating: initialValue, count: count).map(Classy.init)
        }
        
        subscript(_ i: Int) -> Element {
            get { return array[i].value }
            set { array[i].value = newValue}
        }
    }
}
