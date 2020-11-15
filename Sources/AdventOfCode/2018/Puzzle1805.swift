
import Foundation

class Puzzle1805: Puzzle {
    let name: String = "2018_05"
    
    func solveA(_ input: Input) -> String {
        let reactor = Reactor(input.text)
        reactor.completelyReducerPolymer()
        let reduced = reactor.polymer
        
        return "\(reduced.count):\(reduced)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("dabAcCaCBAcCcaDA"), expectedOutput: "10:dabCBAcaDA")
    ]
    
    func solveB(_ input: Input) -> String {
        let allUnits = Set(input.text.uppercased())
        
        let testPolymers = allUnits.map { (char) -> (Character, String) in
            let filteredPolymer = input.text.filter({ $0.uppercased() != String(char) })
            print("reducing \(char)")
            let reactor = Reactor(filteredPolymer)
            reactor.debugging = String(char) == "O"
            reactor.completelyReducerPolymer()
            
            return (char, reactor.polymer)
        }
        
        let shortestPolymer = testPolymers.min { (left, right) -> Bool in
            return left.1.count < right.1.count
        }!
        
        return "\(shortestPolymer.1.count):\(shortestPolymer.1)"
    }
    
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("dabAcCaCBAcCcaDA"), expectedOutput: "4:daDA")
    ]
    
    class Reactor {
        var polymer: String
        var cursor: String.Index
        var debugging: Bool = false
        
        var lookahead: String.Index? {
            polymer.index(cursor, offsetBy: 1, limitedBy: polymer.endIndex)!
        }
        
        init(_ polymer: String) {
            self.polymer = polymer
            self.cursor = polymer.startIndex
        }
        
        func completelyReducerPolymer() {
            var keepScanning: Bool
            repeat {
                keepScanning = scanThroughPolymerRemovingReactions()
            } while keepScanning
        }
        
        /// Returns true if there was at least one reaction this pass.
        func scanThroughPolymerRemovingReactions() -> Bool {
            print("\(polymer.count) Units")
            cursor = polymer.startIndex
            var foundReactionThisPass = false
            repeat {
                if checkForReaction() {
                    removePairAtCursor()
                    foundReactionThisPass = true
                } else {
                    moveCursor(1)
                }
            } while cursor < polymer.endIndex
            return foundReactionThisPass
        }
        
        func checkForReaction() -> Bool {
            guard let lookahead = lookahead, lookahead < polymer.endIndex else { return false }
            let char1 = polymer[cursor]
            let char2 = polymer[lookahead]
            return reacts(char1, char2)
        }
        
        func removePairAtCursor() {
            guard let lookahead = lookahead else { return }
            polymer.removeSubrange(cursor...lookahead)
            if cursor > polymer.startIndex {
                moveCursor(-1)
            }
        }
        
        func moveCursor(_ offset: String.IndexDistance) {
            cursor = polymer.index(cursor, offsetBy: offset)
        }
    }
    
    func recursivelyRemoveAllReactions(in string: String) -> String {
        let newString = removeAllReactions(in: string)
        
        if (newString == string) {
            // All done
            return string
        } else {
            // Go again
            print("\(newString.count) units")
            return recursivelyRemoveAllReactions(in: newString)
        }
    }
    
    func removeFirstReaction(in string: String) -> String {
        let ranges = allReactions(in: string)
        guard ranges.count > 0 else { return string }
        
        var newString = string
        newString.removeSubrange(ranges[0])
        return newString
    }
    
    func removeAllReactions(in string: String) -> String {
        let ranges = allReactions(in: string).reversed()
        guard ranges.count > 0 else { return string }
        
        var newString = string
        ranges.forEach { (range) in
            newString.removeSubrange(range)
        }
        return newString
    }
    
    func allReactions(in string: String) -> [ClosedRange<String.Index>] {
        var ranges = [ClosedRange<String.Index>]()
        var skipOne = false
        for (index, char) in string.enumerated() {
            if skipOne {
                skipOne = false
                continue
            }
            if index + 1 == string.count { break }
            
            let currentIndex = string.index(string.startIndex, offsetBy: index)
            let nextCharIndex = string.index(currentIndex, offsetBy: 1)
            let nextChar = string[nextCharIndex]
            if reacts(char, nextChar) {
                ranges.append(currentIndex...nextCharIndex)
                skipOne = true
            }
        }
        return ranges
    }
}

func reacts(_ char1: Character, _ char2: Character) -> Bool {
    return caseInsensitiveEqual(char1, char2) && isAlternatingCase(char1, char2)
}

func caseInsensitiveEqual(_ char1: Character, _ char2: Character) -> Bool {
    return char1.lowercased() == char2.lowercased()
}

func isAlternatingCase(_ char1: Character, _ char2: Character) -> Bool {
    let formA = char1.isLowercase && char2.isUppercase
    let formB = char1.isUppercase && char2.isLowercase
    return formA || formB
}
