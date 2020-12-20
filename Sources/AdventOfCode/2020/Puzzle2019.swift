
import Foundation

class Puzzle2019: Puzzle {
    let name: String = "2020_19"
    
    func solveA(_ input: Input) -> String {
        let groups = input.lines.split(separator: "").map(Array.init)
        let ruleBook = RuleBook(groups[0])
        let passedMessages = groups[1].filter({ ruleBook.validate($0, againstRuleNumber: 0) })
        return "\(passedMessages.count)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    0: "a"

                    a
                    b
                    aa
                    bb
                    ab
                    ba
                    """), expectedOutput: "1"),
        TestCase(TextInput("""
                    0: 1
                    1: "a"

                    a
                    b
                    aa
                    bb
                    ab
                    ba
                    """), expectedOutput: "1"),
        TestCase(TextInput("""
                    0: 1 1
                    1: "a"

                    a
                    b
                    aa
                    bb
                    ab
                    ba
                    """), expectedOutput: "1"),
        TestCase(TextInput("""
                    0: 1 | 2
                    1: "a"
                    2: "b"

                    a
                    b
                    aa
                    bb
                    ab
                    ba
                    """), expectedOutput: "2"),
        TestCase(TextInput("""
                    0: 1 1 | 2 2
                    1: "a"
                    2: "b"

                    a
                    b
                    aa
                    bb
                    ab
                    ba
                    """), expectedOutput: "2"),
        TestCase(TextInput("""
                    0: 3 | 4
                    1: "a"
                    2: "b"
                    3: 1 1 | 2 2
                    4: 1 2 | 2 1

                    a
                    b
                    aa
                    bb
                    ab
                    ba
                    """), expectedOutput: "4"),
        TestCase(TextInput("""
                    0: 4
                    1: "a"
                    2: "b"
                    3: 1 1 | 2 2
                    4: 1 2 | 2 1

                    a
                    b
                    aa
                    bb
                    ab
                    ba
                    """), expectedOutput: "2"),
        TestCase(TextInput("""
                    0: 4 1 5
                    1: 2 3 | 3 2
                    2: 4 4 | 5 5
                    3: 4 5 | 5 4
                    4: "a"
                    5: "b"

                    ababbb
                    bababa
                    abbbab
                    aaabbb
                    aaaabbb
                    """), expectedOutput: "2")
    ]
    
    func solveB(_ input: Input) -> String {
        let groups = input.lines.split(separator: "").map(Array.init)
        
        let ruleBook = RuleBook(groups[0])
        ruleBook.rules[8] = Rule("42 | 42 8")
        ruleBook.rules[11] = Rule("42 31 | 42 11 31")
        
        let messagesCount = groups[1].count
        let passedMessages = groups[1]
            .filter({ ruleBook.validate($0, againstRuleNumber: 0) })
        return "\(passedMessages.count)"
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("""
                    0: 8 11
                    8: 42 | 42 8
                    11: 42 31 | 42 11 31
                    42: "a"
                    31: "b"

                    aaaaaab
                    """), expectedOutput: "1"),
        TestCase(TextInput("""
                    0: 8 11
                    8: 42 | 42 8
                    11: 42 31 | 42 11 31
                    42: "a"
                    31: "b"

                    a
                    aaaaaaaaa
                    ab
                    aaaabbbb
                    aaaaaab
                    aaabbbbbb
                    """), expectedOutput: "1"),
        TestCase(TextInput("""
                    0: 8 11
                    1: "a"
                    2: 1 24 | 14 4
                    3: 5 14 | 16 1
                    4: 1 1
                    5: 1 14 | 15 1
                    6: 14 14 | 1 14
                    7: 14 5 | 1 21
                    8: 42 | 42 8
                    9: 14 27 | 1 26
                    10: 23 14 | 28 1
                    11: 42 31 | 42 11 31
                    12: 24 14 | 19 1
                    13: 14 3 | 1 12
                    14: "b"
                    15: 1 | 14
                    16: 15 1 | 14 14
                    17: 14 2 | 1 7
                    18: 15 15
                    19: 14 1 | 14 14
                    20: 14 14 | 1 15
                    21: 14 1 | 1 14
                    22: 14 14
                    23: 25 1 | 22 14
                    24: 14 1
                    25: 1 1 | 1 14
                    26: 14 22 | 1 20
                    27: 1 6 | 14 18
                    28: 16 1
                    31: 14 17 | 1 13
                    42: 9 14 | 10 1

                    abbbbbabbbaaaababbaabbbbabababbbabbbbbbabaaaa
                    bbabbbbaabaabba
                    babbbbaabbbbbabbbbbbaabaaabaaa
                    aaabbbbbbaaaabaababaabababbabaaabbababababaaa
                    bbbbbbbaaaabbbbaaabbabaaa
                    bbbababbbbaaaaaaaabbababaaababaabab
                    ababaaaaaabaaab
                    ababaaaaabbbaba
                    baabbaaaabbaaaababbaababb
                    abbbbabbbbaaaababbbbbbaaaababb
                    aaaaabbaabaaaaababaa
                    aaaabbaaaabbaaa
                    aaaabbaabbaaaaaaabbbabbbaaabbaabaaa
                    babaaabbbaaabaababbaabababaaab
                    aabbbbbaabbbaaaaaabbbbbababaaaaabbaaabba
                    """), expectedOutput: "12"),
        TestCase(TextInput("""
                    0: 8 11
                    1: "a"
                    2: 1 24 | 14 4
                    3: 5 14 | 16 1
                    4: 1 1
                    5: 1 14 | 15 1
                    6: 14 14 | 1 14
                    7: 14 5 | 1 21
                    8: 42 | 42 8
                    9: 14 27 | 1 26
                    10: 23 14 | 28 1
                    11: 42 31 | 42 11 31
                    12: 24 14 | 19 1
                    13: 14 3 | 1 12
                    14: "b"
                    15: 1 | 14
                    16: 15 1 | 14 14
                    17: 14 2 | 1 7
                    18: 15 15
                    19: 14 1 | 14 14
                    20: 14 14 | 1 15
                    21: 14 1 | 1 14
                    22: 14 14
                    23: 25 1 | 22 14
                    24: 14 1
                    25: 1 1 | 1 14
                    26: 14 22 | 1 20
                    27: 1 6 | 14 18
                    28: 16 1
                    31: 14 17 | 1 13
                    42: 9 14 | 10 1

                    babbbbaabbbbbabbbbbbaabaaabaaa
                    """), expectedOutput: "1"),
    ]
    
    class RuleBook {
        var rules: [Int: Rule]
        private var mem = Dictionary<String, Bool>()
        
        init(_ rules: [Int: Rule]) {
            self.rules = rules
        }
        
        init(_ rules: [String]) {
            var ruleBook = [Int: Rule]()
            rules.compactMap(regexParse("^(\\d+):(.+)$")).forEach { (group) in
                let ruleId = Int(group[0])!
                let rule = Rule(group[1])
                ruleBook[ruleId] = rule
            }
            self.rules = ruleBook
        }
        
        func validate(_ string: String, againstRuleNumber ruleNum: Int) -> Bool {
            guard let rule = rules[ruleNum] else { return false }
            let result = validate(string, againstRule: rule)
            return result
        }
        
        func validate(_ string: String, againstRule rule: Rule) -> Bool {
            let str = hashString(of: string, rule: rule)
            if let cached = mem[str] {
                return cached
            }
            
            let result = validateSlow(string, againstRule: rule)
            mem[str] = result
            return result
        }
        
        func hashString(of string: String, rule: Rule) -> String {
            return "\(string)...\(rule.description)"
        }
        
        func validateSlow(_ string: String, againstRule rule: Rule) -> Bool {
            switch rule {
            case .const(let constant):
                return string == constant
                
            case .alias(let otherRuleNum):
                return validate(string, againstRuleNumber: otherRuleNum)
                
            case .branch(let branches):
                return branches.contains(where: { validate(string, againstRule: $0) })
                
            case .sequence(let orderedRules):
                return validate(string, aganistSequence: orderedRules)
            }
        }
        
        func validate(_ string: String, aganistSequence sequence: [Rule]) -> Bool {
            guard sequence.count > 0 else { return false }
            guard sequence.count > 1 else { return validate(string, againstRule: sequence[0]) }
            guard string.count >= sequence.count else { return false }
            
            var nextCharIndex = string.startIndex
            while nextCharIndex < string.endIndex {
                let firstPart = String(string[string.startIndex...nextCharIndex])
                nextCharIndex = string.index(after: nextCharIndex)
                
                if validate(firstPart, againstRule: sequence[0]) {
                    let theRest = String(string[nextCharIndex...])
                    if validate(theRest, aganistSequence: Array(sequence[1...])) {
                        return true
                    }
                }
            }
            
            return false
        }
    }
    
    enum Rule: Hashable {
        case const(String)
        case alias(Int)
        case sequence([Rule])
        case branch([Rule])
        
        init(_ string: String) {
            let chomped = string.trimmingCharacters(in: .whitespacesAndNewlines)
            if let matches = regexParse("^\"(\\w+)\"$")(chomped), matches.count > 0 {
                self = .const(matches[0])
                return
            }
            
            if let matches = regexParse("^(\\d+)$")(chomped), matches.count > 0 {
                self = .alias(Int(matches[0])!)
                return
            }
            
            let splitBranches = chomped.split(separator: "|").map(String.init)
            if splitBranches.count > 1 {
                let branches = splitBranches.map(Rule.init)
                self = .branch(branches)
                return
            }
            
            let splitSequence = chomped.split(separator: " ").map(String.init)
            let sequence = splitSequence.map(Rule.init)
            self = .sequence(sequence)
        }
        
        var description: String {
            switch self {
            case .const(let value): return "\"\(value)\""
            case .alias(let value): return "\(value)"
            case .sequence(let seq): return seq.map(\.description).joined(separator: " ")
            case .branch(let seq): return seq.map(\.description).joined(separator: " | ")
            }
        }
    }
}
