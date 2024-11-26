
import Foundation
import AdventOfCode

class Puzzle2301: Puzzle {
    let name: String = "2023_01"
    
    func solveA(_ input: Input) -> String {
        let final = input.lines.map(formNumber(from:)).reduce(0, +)
        return String(final)
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
1abc2
pqr3stu8vwx
a1b2c3d4e5f
treb7uchet
"""), expectedOutput: "142")
    ]
    
    func solveB(_ input: Input) -> String {
        let final = input.lines
            .map(bValue(from:))
            .reduce(0, +)
        
        return String(final)
    }
    
    func formNumber(from string: String) -> Int {
        let allInts = ints(from: string)
        let tens = allInts.first!
        let ones = allInts.last!
        
        return (tens * 10) + ones
    }
    
    func ints(from string: String) -> [Int] {
        return string.compactMap({ Int(String($0)) })
    }

    func bValue(from string: String) -> Int {
        return (firstNumber(from: string) * 10) + lastNumber(from: string)
    }
    
    func firstNumber(from string: String) -> Int {
        let scanner = Scanner(string)

        while scanner.canMoveForward {
            guard let nextChar = try? scanner.readChars(1) else {
                break
            }

            if let numeric = Int(nextChar) {
                return numeric
            }
            
            for (name, num) in numbers {
                if scanner.check(name) {
                    return num
                }
            }
            
            scanner.forward()
        }
        
        return 0
    }
    
    func lastNumber(from string: String) -> Int {
        let scanner = Scanner(string)
        scanner.cursor = string.endIndex

        while scanner.canMoveBackward {
            scanner.backward()

            guard let nextChar = try? scanner.readChars(1) else {
                break
            }

            if let numeric = Int(nextChar) {
                return numeric
            }
            
            for (name, num) in numbers {
                if scanner.check(name) {
                    return num
                }
            }
        }
        
        return 0
    }
    
    let numbers = [
        "one": 1,
        "two": 2,
        "three": 3,
        "four": 4,
        "five": 5,
        "six": 6,
        "seven": 7,
        "eight": 8,
        "nine": 9
    ]
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("""
two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen
"""), expectedOutput: "281"),
        TestCase(TextInput("two1nine"), expectedOutput: "29"),
        TestCase(TextInput("eightwothree"), expectedOutput: "83"),
        TestCase(TextInput("abcone2threexyz"), expectedOutput: "13"),
        TestCase(TextInput("xtwone3four"), expectedOutput: "24"),
        TestCase(TextInput("4nineeightseven2"), expectedOutput: "42"),
        TestCase(TextInput("zoneight234"), expectedOutput: "14"),
        TestCase(TextInput("7pqrstsixteen"), expectedOutput: "76")
    ]
    
    class Scanner {
        let text: String
        var cursor: String.Index
        
        init(_ text: String) {
            self.text = text
            self.cursor = text.startIndex
        }
        
        func reset() {
            cursor = text.startIndex
        }
        
        func forward() {
            cursor = text.index(after: cursor)
        }
        
        var canMoveForward: Bool {
            cursor < text.endIndex
        }
        
        func backward() {
            cursor = text.index(before: cursor)
        }
        
        var canMoveBackward: Bool {
            cursor > text.startIndex
        }
        
        func scan(to fragment: String) -> Bool {
            cursor = text.startIndex
            
            while cursor < text.endIndex {
                if check(fragment) {
                    return true
                }
                cursor = text.index(after: cursor)
            }
            
            return false
        }
        
        func check(_ fragment: String) -> Bool {
            guard let value = try? readChars(fragment.count) else {
                return false
            }
            return fragment == String(value)
        }
        
        func readChars(_ count: Int) throws -> some StringProtocol {
            guard let endIndex = text.index(cursor, offsetBy: count, limitedBy: text.endIndex) else {
                throw E()
            }
            return text[cursor..<endIndex]
        }
    }
    
    struct E: Error {
        
    }
}
