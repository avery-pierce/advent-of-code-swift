
import Foundation

class Puzzle1807: Puzzle {
    let name: String = "2018_07"
    
    func solveA(_ input: Input) -> String {
        let rules = input.lines.map(Rule.init(descriptor:))
        let graph = Graph(rules)
        
        var output = ""
        repeat {
            let nextStep = graph.nextStep
            output += nextStep
            graph.completeStep(nextStep)
        } while !graph.incompleteSteps.isEmpty
        
        return output
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    Step C must be finished before step A can begin.
                    Step C must be finished before step F can begin.
                    Step A must be finished before step B can begin.
                    Step A must be finished before step D can begin.
                    Step B must be finished before step E can begin.
                    Step D must be finished before step E can begin.
                    Step F must be finished before step E can begin.
                    """), expectedOutput: "CABDFE")
    ]
    
    func solveB(_ input: Input) -> String {
        let isTesting = input.lines.count == 7
        let numWorkers = isTesting ? 2 : 5
        let baseWorkTimePerStep = isTesting ? 0 : 60
        
        return "unsolved"
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("""
                    Step C must be finished before step A can begin.
                    Step C must be finished before step F can begin.
                    Step A must be finished before step B can begin.
                    Step A must be finished before step D can begin.
                    Step B must be finished before step E can begin.
                    Step D must be finished before step E can begin.
                    Step F must be finished before step E can begin.
                    """), expectedOutput: "15")
    ]
    
    class Graph {
        var rules: [Rule]
        var completedSteps: Set<String> = Set()
        
        lazy var allSteps: Set<String> = {
            var allSteps = Set<String>()
            for rule in rules {
                allSteps.insert(rule.before)
                allSteps.insert(rule.after)
            }
            return allSteps
        }()
        
        var incompleteSteps: Set<String> {
            return allSteps.subtracting(completedSteps)
        }
        
        init(_ rules: [Rule]) {
            self.rules = rules
        }
        
        var nextStep: String {
            return unblockedSteps.sorted()[0]
        }
        
        var unblockedSteps: [String] {
            return allSteps
                .filter({ isStepUnblocked($0) })
                .filter({ !completedSteps.contains($0) })
        }
        
        func isStepUnblocked(_ step: String) -> Bool {
            let rulesBlockingStep = rules
                .filter({ $0.after == step })
                .filter({ !completedSteps.contains($0.before) })
            
            return rulesBlockingStep.count == 0
        }
        
        func completeStep(_ step: String) {
            completedSteps.insert(step)
        }
    }
    
    struct Rule {
        var before: String
        var after: String
        
        init(before: String, after: String) {
            self.before = before
            self.after = after
        }
        
        init(descriptor: String) {
            let words = descriptor.split(separator: " ")
            self.before = String(words[1])
            self.after = String(words[7])
        }
    }
}
