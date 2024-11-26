
import Foundation
import AdventOfCode

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
        
        let rules = input.lines.map(Rule.init(descriptor:))
        let graph = Graph(rules)
        let dispatcher = WorkDispatcher(graph, numberOfWorkers: numWorkers, baseWorkTimePerStep: baseWorkTimePerStep)
        dispatcher.completeAllWork()
        
        return "\(dispatcher.clock)"
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
    
    class WorkDispatcher {
        var graph: Graph
        var numberOfWorkers: Int
        var baseWorkTimePerStep: Int
        var clock = 0
        
        struct Worker {
            var step: String
            var completedBy: Int
        }
        var workers = [Worker]()
        var activeWorkers: [Worker] {
            workers.filter({ !isComplete($0) })
        }
        var availableCapacity: Int {
            return numberOfWorkers - activeWorkers.count
        }
        
        init(_ graph: Graph, numberOfWorkers: Int, baseWorkTimePerStep: Int) {
            self.graph = graph
            self.numberOfWorkers = numberOfWorkers
            self.baseWorkTimePerStep = baseWorkTimePerStep
        }
        
        func timeToComplete(_ step: String) -> Int {
            let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
            let index = alphabet.firstIndex(of: Character(step))!
            return alphabet.distance(from: alphabet.startIndex, to: index) + 1 + baseWorkTimePerStep
        }
        
        func advanceClock() {
            clock += 1
        }
        
        func isComplete(_ worker: Worker) -> Bool {
            return clock >= worker.completedBy
        }
        
        func markTasksAsCompleted() {
            let completeWorkers = workers.filter({ isComplete($0) })
            completeWorkers.forEach({ graph.completeStep($0.step) })
        }
        
        func isStepAssigned(_ step: String) -> Bool {
            let assignedWorker = workers.first(where: { $0.step == step })
            return assignedWorker != nil
        }
        
        var availableWork: [String] {
            return graph.unblockedSteps.filter({ !isStepAssigned($0) })
        }
        
        var nextTask: String? {
            guard availableWork.count > 0 else { return nil }
            return availableWork[0]
        }
        
        func assignWorkers() {
            while availableCapacity > 0 && availableWork.count > 0 {
                dispatchWorker()
            }
        }
        
        func dispatchWorker() {
            let task = nextTask!
            let completion = clock + timeToComplete(task)
            let newWorker = Worker(step: task, completedBy: completion)
            workers.append(newWorker)
        }
        
        func completeAllWork() {
            assignWorkers()
            repeat {
                advanceClock()
                markTasksAsCompleted()
                assignWorkers()
            } while !graph.incompleteSteps.isEmpty
        }
    }
    
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
