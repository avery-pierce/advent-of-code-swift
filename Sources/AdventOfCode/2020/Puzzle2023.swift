
import Foundation

class Puzzle2023: Puzzle {
    let name: String = "2020_23"
    
    func solveA(_ input: Input) -> String {
        let sim = CupSimulation(input.text)
        sim.do100Moves()
        return sim.result
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("389125467"), expectedOutput: "67384529")
    ]
    
    func solveB(_ input: Input) -> String {
        var cups = input.text.map(String.init).compactMap(Int.init)
        cups.append(contentsOf: ((cups.max()! + 1)..<1_000_000))
        let sim = CupSimulation(cups)
        
        for i in 0..<10_000_000 {
            sim.doMove()
            if i % 10_000 == 0 {
                print("Move \(i)")
            }
        }
        
        return ""
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("389125467"), expectedOutput: "149245887792")
    ]
    
    class CupSimulation {
        var cups: [Int]
        var currentCup: Int
        
        convenience init(_ string: String) {
            let cups = string.map(String.init).compactMap(Int.init)
            self.init(cups)
        }
        
        init(_ cups: [Int]) {
            self.cups = cups
            self.currentCup = cups[0]
        }
        
        var indexOfCurrentCup: Int {
            cups.firstIndex(of: currentCup)!
        }
        
        var indexAfterCurrentCup: Int {
            normalize(index: indexOfCurrentCup + 1)
        }
        
        var destinationCup: Int {
            return cups[destinationCupIndex]
        }
        
        var destinationCupIndex: Int {
            var expectedCup = currentCup
            while true {
                expectedCup -= 1
                if (expectedCup < 1) {
                    expectedCup = 9
                }
                
                if let index = cups.firstIndex(of: expectedCup) {
                    return index
                }
            }
        }
        
        func do100Moves() {
            for _ in 0..<100 {
                doMove()
            }
        }
        
        func doMove() {
//            print("Cups: \(renderCups)")
            
            let firstThreeCups = [
                cups.remove(at: indexAfterCurrentCup),
                cups.remove(at: indexAfterCurrentCup),
                cups.remove(at: indexAfterCurrentCup),
            ]
            
//            print("Taking 3 cups: \(firstThreeCups)")
//            print("Destination Cup: \(destinationCup)")
            
            let indexAfterDestination = normalize(index: destinationCupIndex + 1)
            cups.insert(contentsOf: firstThreeCups, at: indexAfterDestination)
            rotateCurrentCup()
        }
        
        func rotateCurrentCup() {
            currentCup = cups[indexAfterCurrentCup]
        }
        
        func cup(at index: Int) -> Int {
            cups[normalize(index: index)]
        }
        
        func normalize(index: Int) -> Int {
            index % cups.count
        }
        
        var renderCups: String {
            cups.map({ $0 == currentCup ? "(\($0))" : " \($0) "}).joined()
        }
        
        var result: String {
            let indexOf1 = cups.firstIndex(of: 1)!
            let chars = ((indexOf1 + 1)..<(indexOf1 + cups.count))
                .map(normalize(index:))
                .map({ cups[$0] })
                .compactMap(String.init)
                .map(Character.init)
            
            return String(chars)
        }
    }
}
