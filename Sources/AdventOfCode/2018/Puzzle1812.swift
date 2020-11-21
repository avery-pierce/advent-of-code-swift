
import Foundation

class Puzzle1812: Puzzle {
    let name: String = "2018_12"
    
    func solveA(_ input: Input) -> String {
        let (initialState, rules) = parseInput(input: input)
        let ruleBook = RuleBook(rules)
        
        var iteration = initialState
        
        let bunchOfEmptyPots = (0..<30).map({ _ in Pot.empty })
        let indexOffset = bunchOfEmptyPots.count
        iteration.insert(contentsOf: bunchOfEmptyPots, at: 0)
        iteration.append(contentsOf: bunchOfEmptyPots)
        
        print("\(render(iteration)) :0")
        for i in (1...20) {
            let nextIteration = iterate(from: iteration, ruleBook: ruleBook)
            iteration = nextIteration
            print("\(render(iteration)) :\(i)")
        }
        
        let sum = sumOfFilledPots(iteration, indexOffset: indexOffset)
        
        return "\(sum)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    initial state: #..#.#..##......###...###
                    
                    ...## => #
                    ..#.. => #
                    .#... => #
                    .#.#. => #
                    .#.## => #
                    .##.. => #
                    .#### => #
                    #.#.# => #
                    #.### => #
                    ##.#. => #
                    ##.## => #
                    ###.. => #
                    ###.# => #
                    ####. => #
                    """), expectedOutput: "325")
    ]
    
    func solveB(_ input: Input) -> String {
        return "unsolved"
    }
    
    var testCasesB: [TestCase] = [
        // Input test cases here
    ]
    
    func parseInput(input: Input) -> (initialState: [Pot], rules: [Rule]) {
        let firstRow = input.lines.first!
        let firstRowParts = firstRow.split(separator: " ")
        let initialStateString = firstRowParts[2]
        let initialState = initialStateString.map(Pot.init)
        
        let rules = input.lines[1...].map(Rule.init(descriptor:))
        return (initialState: initialState, rules: rules)
    }
    
    struct Rule {
        let pots: [Pot]
        let result: Pot
        
        init(when pots: [Pot], output: Pot) {
            self.pots = pots
            self.result = output
        }
        
        init(descriptor: String) {
            let parts = descriptor.split(separator: " ")
            let input = parts[0]
            self.pots = input.map(Pot.init)
            self.result = Pot(descriptor: String(parts[2]))
        }
        
        func matches(_ range: [Pot]) -> Bool {
            return range == pots
        }
    }
    
    struct RuleBook {
        var rules: [Rule]
        init(_ rules: [Rule]) {
            self.rules = rules
        }
        
        func returnValue(for pots: [Pot]) -> Pot {
            return findRule(for: pots)?.result ?? .empty
        }
        
        func findRule(for pots: [Pot]) -> Rule? {
            return rules.first(where: { $0.pots == pots })
        }
    }
    
    enum Pot: Equatable {
        case filled
        case empty
        
        var isFilled: Bool {
            return self == .filled
        }
        
        init(descriptor: String) {
            if descriptor == "#" {
                self = .filled
            } else {
                self = .empty
            }
        }
        
        init(descriptor: Character) {
            let str = String(descriptor)
            self.init(descriptor: str)
        }
        
        var char: Character {
            switch self {
            case .empty: return "."
            case .filled: return "#"
            }
        }
    }
    
    func iterate(from state: [Pot], ruleBook: RuleBook) -> [Pot] {
        var newState = [Pot]()
        let rowLength = state.count
        for (index, pot) in state.enumerated() {
            let startIndex = index - 2
            let endIndex = index + 2
            if startIndex < 0 || endIndex >= rowLength {
                newState.append(pot)
                continue
            }
            
            let window = Array(state[startIndex...endIndex])
            let newValue = ruleBook.returnValue(for: window)
            newState.append(newValue)
        }
        
        return newState
    }
    
    func render(_ pots: [Pot]) -> String {
        return String(pots.map(\.char))
    }
    
    func sumOfFilledPots(_ pots: [Pot], indexOffset: Int) -> Int {
        let scores = pots.enumerated().map { (index, pot) -> Int in
            return pot.isFilled ? index - indexOffset : 0
        }
        return scores.reduce(0, +)
    }
}
