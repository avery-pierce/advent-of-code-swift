
import Foundation

class Puzzle2016: Puzzle {
    let name: String = "2020_16"
    
    func solveA(_ input: Input) -> String {
        let (rules, _, nearbyTickets) = parseInput(input)
        let invalidValues = nearbyTickets.flatMap({ $0 }).filter({ !validate($0, against: rules) })
        let sum = invalidValues.reduce(0, +)
        return "\(sum)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    class: 1-3 or 5-7
                    row: 6-11 or 33-44
                    seat: 13-40 or 45-50
                    
                    your ticket:
                    7,1,14
                    
                    nearby tickets:
                    7,3,47
                    40,4,50
                    55,2,20
                    38,6,12
                    """), expectedOutput: "71")
    ]
    
    func solveB(_ input: Input) -> String {
        let (rules, myTicket, nearbyTickets) = parseInput(input)
        let validNearbyTickets = nearbyTickets.filter({ validate(ticket: $0, against: rules) })
        
        let truth = decodeTruth(validTickets: validNearbyTickets, rules: rules)
        
        let importantRules = rules.filter({ $0.name.hasPrefix("departure")})
        if importantRules.count == 0 { return "test" } // Test input doesn't have departure.
        
        let indexes = importantRules.map({ return truth[$0]! })
        let myValues = indexes.map({ myTicket[$0] })
        let product = myValues.reduce(1, *)
        return "\(product)"
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("""
                    class: 0-1 or 4-19
                    row: 0-5 or 8-19
                    seat: 0-13 or 16-19
                    
                    your ticket:
                    11,12,13
                    
                    nearby tickets:
                    3,9,18
                    15,1,5
                    5,14,9
                    """), expectedOutput: "test")
    ]
    
    func parseInput(_ input: Input) -> (rules: [Rule], myTicket: [Int], nearbyTickets: [[Int]]) {
        let sections = input.lines.split(separator: "").map(Array.init)
        
        let rules = sections[0].map(Rule.init)
        let myTicket = sections[1][1].split(separator: ",").map(String.init).compactMap(Int.init)
        let nearbyTickets = sections[2][1...].map({ $0.split(separator: ",").map(String.init).compactMap(Int.init) })
        
        return (rules: rules, myTicket: myTicket, nearbyTickets: nearbyTickets)
    }
    
    struct Rule: Hashable, Equatable {
        var name: String
        var ranges: [RuleRange]
        
        init(_ string: String) {
            let parts = regexParse("^(.*): (\\d+-\\d+) or (\\d+-\\d+)$")(string)!
            self.name = parts[0]
            self.ranges = parts[1...2].map(RuleRange.init)
        }
        
        func validate(_ value: Int) -> Bool {
            return ranges.contains(where: { $0.range.contains(value) })
        }
    }
    
    struct RuleRange: Hashable, Equatable {
        var lowerBound: Int
        var upperBound: Int
        var range: ClosedRange<Int> { lowerBound...upperBound }
        
        init(_ string: String) {
            let parts = regexParse("(\\d+)-(\\d+)")(string)!
            self.lowerBound = Int(parts[0])!
            self.upperBound = Int(parts[1])!
        }
    }
    
    func validate(_ value: Int, against rules: [Rule]) -> Bool {
        return rules.contains(where: { $0.validate(value) })
    }
    
    func validate(ticket: [Int], against rules: [Rule]) -> Bool {
        return ticket.allSatisfy({ validate($0, against: rules) })
    }
    
    func decodeTruth(validTickets: [[Int]], rules: [Rule]) -> [Rule: Int] {
        let inverted = invert(validTickets)
        var knownIndexes = [Rule: Int]()
        
        while (knownIndexes.keys.count < rules.count) {
            let delta = rules.count - knownIndexes.keys.count
            var unknownRules = Set(rules)
            unknownRules.remove(membersOf: knownIndexes.keys)
            
            var unknownIndexes = Set(inverted.keys)
            unknownIndexes.remove(membersOf: knownIndexes.values)
            
            for rule in unknownRules {
                let filtered = inverted
                    .filter({ (index, _) in unknownIndexes.contains(index) })
                    .filter({ (index, values) in
                        return values.allSatisfy({ rule.validate($0) })
                    })
                
                if filtered.keys.count == 1 {
                    let key = filtered.keys.first!
                    knownIndexes[rule] = key
                }
            }
            
            for index in unknownIndexes {
                let allValues = inverted[index]!
                let validRules = Array(unknownRules).filter({ rule in allValues.allSatisfy({ rule.validate($0) })})
                
                if validRules.count == 1 {
                    knownIndexes[validRules[0]] = index
                }
            }
            
            if delta == rules.count - knownIndexes.keys.count {
                print("endless loop... Is this solvable?")
                break
            }
        }
        
        return knownIndexes
    }
    
    func invert(_ tickets: [[Int]]) -> [Int: [Int]] {
        var indexedValues = [Int /* index */: [Int] /* values */]()
        for ticket in tickets {
            for (i, value) in ticket.enumerated() {
                var current = indexedValues[i] ?? []
                current.append(value)
                indexedValues[i] = current
            }
        }
        return indexedValues
    }
}
