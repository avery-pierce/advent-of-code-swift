
import Foundation
import AdventOfCode

class Puzzle2002: Puzzle {
    let name: String = "2020_02"
    
    func solveA(_ input: Input) -> String {
        let validations = input.lines.map(PasswordValidation.init(descriptor:))
        let valids = validations.filter(\.isValid)
        return "\(valids.count)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    1-3 a: abcde
                    1-3 b: cdefg
                    2-9 c: ccccccccc
                    """), expectedOutput: "2")
    ]
    
    func solveB(_ input: Input) -> String {
        let validations = input.lines.map(PasswordValidation.init(descriptor:))
        let valids = validations.filter(\.isValid2)
        return "\(valids.count)"
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("""
                    1-3 a: abcde
                    1-3 b: cdefg
                    2-9 c: ccccccccc
                    """), expectedOutput: "1")
    ]
    
    struct PasswordValidation {
        let minOccurrences: Int
        let maxOccurrences: Int
        let char: Character
        let password: String
        
        init(descriptor: String) {
            let parts = descriptor.split(separator: ":")
            self.password = String(parts[1].trimmingCharacters(in: .whitespaces))
            
            let firstParts = parts[0].split(separator: " ")
            self.char = firstParts[1].first!
            
            let rangeParts = firstParts[0].split(separator: "-")
            self.minOccurrences = Int(String(rangeParts[0]))!
            self.maxOccurrences = Int(String(rangeParts[1]))!
        }
        
        var isValid: Bool {
            let freq = Frequency(password)
            return freq[char] >= minOccurrences && freq[char] <= maxOccurrences
        }
        
        var isInvalid: Bool {
            return !isValid
        }
        
        var isValid2: Bool {
            let startIndex = password.index(password.startIndex, offsetBy: minOccurrences - 1)
            let endIndex = password.index(password.startIndex, offsetBy: maxOccurrences - 1)
            if password[startIndex] == char && password[endIndex] == char { return false }
            if password[startIndex] == char || password[endIndex] == char { return true }
            return false
        }
    }
}
