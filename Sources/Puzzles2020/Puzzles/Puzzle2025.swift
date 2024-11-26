
import Foundation
import AdventOfCode

class Puzzle2025: Puzzle {
    let name: String = "2020_25"
    
    func solveA(_ input: Input) -> String {
        let cardPubKey = Int(input.lines[0])!
        let doorPubKey = Int(input.lines[1])!
        let solver = EncryptionKeySolver(subjectNumber: 7, cardPublicKey: cardPubKey, doorPublicKey: doorPubKey)
        
        print("Card Loop Size: \(solver.cardLoopSize)")
        print("Door Loop Size: \(solver.doorLoopSize)")
        let key = solver.solve()
        print("EncryptionKey: \(key)")
        return "\(key)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    5764801
                    17807724
                    """), expectedOutput: "14897079")
    ]
    
    func solveB(_ input: Input) -> String {
        return "unsolved"
    }
    
    var testCasesB: [TestCase] = [
        // Input test cases here
    ]
    
    class EncryptionKeySolver {
        var cardPublicKey: Int
        var doorPublicKey: Int
        var subjectNumber: Int
        
        lazy var cardLoopSize: Int = {
           return findLoopSize(publicKey: cardPublicKey, subjectNumber: subjectNumber)
        }()
        lazy var doorLoopSize: Int = {
            return findLoopSize(publicKey: doorPublicKey, subjectNumber: subjectNumber)
        }()
        
        init(subjectNumber: Int, cardPublicKey: Int, doorPublicKey: Int) {
            self.cardPublicKey = cardPublicKey
            self.doorPublicKey = doorPublicKey
            self.subjectNumber = subjectNumber
        }
        
        func solve() -> Int {
            var check = 1
            print("cardPubKey: \(cardPublicKey)")
            for i in (0..<doorLoopSize) {
                check = iterateLoop(input: check, subjectNumber: cardPublicKey)
            }
            return check
        }
        
        func solve2() -> Int {
            var check = 1
            for i in (0..<(cardLoopSize + doorLoopSize)) {
                check = iterateLoop(input: check, subjectNumber: subjectNumber)
                print("Looping time: \(i + 1): \(check)")
            }
            return check
        }
    }
}

func findLoopSize(publicKey: Int, subjectNumber: Int) -> Int {
    var check = 1
    var loops = 0
    while check != publicKey {
        loops += 1
        check = iterateLoop(input: check, subjectNumber: subjectNumber)
    }
    return loops
}

func iterateLoop(input: Int, subjectNumber: Int) -> Int {
    let multiplied = input * subjectNumber
    return multiplied % 20201227
}
