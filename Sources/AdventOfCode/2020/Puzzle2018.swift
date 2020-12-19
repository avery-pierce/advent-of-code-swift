
import Foundation

class Puzzle2018: Puzzle {
    let name: String = "2020_18"
    
    func solveA(_ input: Input) -> String {
        let sum = input.lines.map(solve(expression:)).reduce(0, +)
        return "\(sum)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("1 + 2"), expectedOutput: "3"),
        TestCase(TextInput("2 * 4"), expectedOutput: "8"),
        TestCase(TextInput("2 * (5 + 4)"), expectedOutput: "18"),
        TestCase(TextInput("2 * 3 + (4 * 5)"), expectedOutput: "26"),
        TestCase(TextInput("5 + (8 * 3 + 9 + 3 * 4 * 3)"), expectedOutput: "437"),
        TestCase(TextInput("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))"), expectedOutput: "12240"),
        TestCase(TextInput("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2"), expectedOutput: "13632"),
    ]
    
    func solveB(_ input: Input) -> String {
        let sum = input.lines.map(solve2(expression:)).reduce(0, +)
        return "\(sum)"
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("2 * 3 + (4 * 5)"), expectedOutput: "46"),
        TestCase(TextInput("5 + (8 * 3 + 9 + 3 * 4 * 3)"), expectedOutput: "1445"),
        TestCase(TextInput("5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))"), expectedOutput: "669060"),
        TestCase(TextInput("((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2"), expectedOutput: "23340"),
    ]
    
    func solve(expression: String) -> Int {
        if let group = regexParseRange("(\\(([^\\(\\)]+)\\))")(expression), !group.isEmpty {
            let (_, wrapRange) = group[0]
            let (subExpression, _) = group[1]
            
            let result = solve(expression: subExpression)
            let nsString = NSString(string: expression)
            let replaced = nsString.replacingCharacters(in: wrapRange, with: "\(result)")
            return solve(expression: replaced)
        }
        
        if let firstOperator = regexParseRange("^((\\d+)\\s([\\+\\*])\\s(\\d+))")(expression), !firstOperator.isEmpty {
            let (_, wrapRange) = firstOperator[0]
            let result = compute(firstOperator[1...].map(\.0))
            
            let nsString = NSString(string: expression)
            let replaced = nsString.replacingCharacters(in: wrapRange, with: "\(result)")
            return solve(expression: replaced)
        }
        
        guard let output = Int(expression) else {
            print(expression)
            return 0
        }
        return output
    }
    
    func solve2(expression: String) -> Int {
        if let group = regexParseRange("(\\(([^\\(\\)]+)\\))")(expression), !group.isEmpty {
            let (_, wrapRange) = group[0]
            let (subExpression, _) = group[1]
            
            let result = solve2(expression: subExpression)
            let nsString = NSString(string: expression)
            let replaced = nsString.replacingCharacters(in: wrapRange, with: "\(result)")
            return solve2(expression: replaced)
        }
        
        if let firstAddition = regexParseRange("((\\d+)\\s(\\+)\\s(\\d+))")(expression), !firstAddition.isEmpty {
            let (_, wrapRange) = firstAddition[0]
            let result = compute(firstAddition[1...].map(\.0))
            
            let nsString = NSString(string: expression)
            let replaced = nsString.replacingCharacters(in: wrapRange, with: "\(result)")
            return solve2(expression: replaced)
        }
        
        if let firstOperator = regexParseRange("^((\\d+)\\s(\\*)\\s(\\d+))")(expression), !firstOperator.isEmpty {
            let (_, wrapRange) = firstOperator[0]
            let result = compute(firstOperator[1...].map(\.0))
            
            let nsString = NSString(string: expression)
            let replaced = nsString.replacingCharacters(in: wrapRange, with: "\(result)")
            return solve2(expression: replaced)
        }
        
        guard let output = Int(expression) else {
            print(expression)
            return 0
        }
        return output
    }
    
    func compute(_ parts: [String]) -> Int {
        guard parts.count >= 3 else { fatalError() }
        
        switch parts[1] {
        case "+":
            return Int(parts[0])! + Int(parts[2])!
        case "*":
            return Int(parts[0])! * Int(parts[2])!
        default:
            fatalError("unsupported operation: \(parts[1])")
        }
    }
}

func regexParseRange(_ string: String) -> (String) -> [(String, NSRange)]? {
    let regex = try! NSRegularExpression(pattern: string, options: [])
    
    return { (_ input: String) -> [(String, NSRange)]? in
        let range = NSRange(location: 0, length: input.count)
        guard let match = regex.firstMatch(in: input, options: [], range: range) else { return nil }
        var ranges = (0..<match.numberOfRanges).map { (index) -> NSRange in
            return match.range(at: index)
        }
        
        ranges.removeFirst()
        
        let nsString = NSString(string: input)
        return ranges.compactMap { (range) -> (String, NSRange)? in
            guard range.location < nsString.length else { return nil }
            return (nsString.substring(with: range), range)
        }
    }
}
