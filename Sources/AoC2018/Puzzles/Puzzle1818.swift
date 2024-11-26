
import Foundation
import AdventOfCode

class Puzzle1818: Puzzle {
    let name: String = "2018_18"
    
    func solveA(_ input: Input) -> String {
        let initialState = parseInitialState(input)
        let sim = ForestSimulation(initialState)
        
        let numberOfCycles = 10
        for _ in (0..<numberOfCycles) {
            sim.iterate()
        }
        
        let allAcres = sim.allAcres
        return "\(allAcres[.tree] * allAcres[.lumberyard])"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    .#.#...|#.
                    .....#|##|
                    .|..|...#.
                    ..|#.....#
                    #.#|||#|#|
                    ...#.||...
                    .|....|...
                    ||...#|.#|
                    |.||||..|.
                    ...#.|..|.
                    """), expectedOutput: "1147")
    ]
    
    func solveB(_ input: Input) -> String {
        let initialState = parseInitialState(input)
        let sim = ForestSimulation(initialState)
        sim.iterateUntilRepeat()
        let state = sim.projectState(atIteration: 1_000_000_000)!
        let allAcres = Frequency(state.values)
        return "\(allAcres[.tree] * allAcres[.lumberyard])"
        
//        let simBruteForce = ForestSimulation(initialState)
//        print("Running brute force simulation")
//        let testIterations = 599
//        for i in (0..<testIterations) {
//            if i % 100 == 0 {
//                print("iteration \(i)")
//            }
//            simBruteForce.iterate()
//        }
//        print("Stopped with iterations = \(simBruteForce.iterations)")
//        let bruteForceState = simBruteForce.currentState
//        let projectedState = simBruteForce.projectState(atIteration: testIterations)
//
//        print("Matches? \(bruteForceState == projectedState ? "Yes!" : "no.")")
//        return ""
    }
    
    var testCasesB: [TestCase] = [
        // Input test cases here
    ]
    
    func parseInitialState(_ input: Input) -> [GridCoordinate: Acre] {
        var out = [GridCoordinate: Acre]()
        for (y, line) in input.lines.enumerated() {
            for (x, char) in line.enumerated() {
                let acre = Acre(rawValue: char)!
                let coord = GridCoordinate(x: x, y: y)
                out[coord] = acre
            }
        }
        return out
    }
    
    class ForestSimulation {
        var allPreviousStates: [[GridCoordinate: Acre]] = []
        
        var iterations = 0
        var firstRepeatedIteration: (iteration: Int, repeats: Int)? = nil
        
        var currentState: [GridCoordinate: Acre]
        lazy var boundingRect = GridRect.enclosing(Set(currentState.keys))
        var allAcres: Frequency<Acre> {
            return Frequency(currentState.values)
        }
        
        init(_ initialState: [GridCoordinate: Acre]) {
            self.currentState = initialState
        }
        
        func iterateUntilRepeat() {
            while firstRepeatedIteration == nil {
                iterate()
            }
        }
        
        func projectState(atIteration iteration: Int) -> [GridCoordinate: Acre]? {
            guard let firstRepeatedIteration = firstRepeatedIteration else { return nil }
            
            let loopingStates = Array(allPreviousStates[firstRepeatedIteration.repeats..<firstRepeatedIteration.iteration])
            print("Number of looping states = \(loopingStates.count)")
            let iterationsSinceRepeat = iteration - firstRepeatedIteration.repeats
            print("iterations since repeat: \(iterationsSinceRepeat)")
            let index = iterationsSinceRepeat % loopingStates.count
            print("Selecing index \(index)")
            
            return loopingStates[index]
        }
        
        func iterate() {
            let newState = nextIteration()
            allPreviousStates.append(currentState)
            iterations += 1
            currentState = newState
        }
        
        func nextIteration() -> [GridCoordinate: Acre] {
            // If the current state existed once before, the next state will be the occurrence immediately after it
            if let firstOccurrenceIndex = allPreviousStates.firstIndex(where: { $0 == currentState }) {
                print("Iteration #\(iterations) repeats iteration at \(firstOccurrenceIndex)")
                if (firstRepeatedIteration == nil ) {
                    firstRepeatedIteration = (iteration: iterations, repeats: firstOccurrenceIndex)
                }
                
                let next = firstOccurrenceIndex + 1
                if allPreviousStates.count < next {
                    return allPreviousStates[next]
                }
            }
            
            let newState = currentState.mapKeyedValues { (coord, acre) -> Acre in
                let adjacentAcres = acres(adjacentTo: coord)
                
                switch acre {
                case .open:
                    return adjacentAcres[.tree] >= 3 ? .tree : .open
                    
                case .tree:
                    return adjacentAcres[.lumberyard] >= 3 ? .lumberyard : .tree
                    
                case .lumberyard:
                    return adjacentAcres[.lumberyard] >= 1 && adjacentAcres[.tree] >= 1 ? .lumberyard : .open
                    
                }
            }
            return newState
        }
        
        func coordinates(adjacentTo coordinate: GridCoordinate) -> Set<GridCoordinate> {
            let directions: [GridVector] = [
                .north,
                .north + .east,
                .east,
                .south + .east,
                .south,
                .south + .west,
                .west,
                .north + .west,
            ]
            
            let coords = Set(directions.map(coordinate.moved(by:)))
            return coords.filter(boundingRect.encloses(_:))
        }
        
        func acres(adjacentTo coordinate: GridCoordinate) -> Frequency<Acre> {
            let coords = coordinates(adjacentTo: coordinate)
            let acres = coords.compactMap({ currentState[$0] })
            return Frequency(acres)
        }
        
        func render() -> String {
            return boundingRect.render({ currentState[$0]?.rawValue ?? " " })
        }
    }
    
    enum Acre: Character {
        case open = "."
        case tree = "|"
        case lumberyard = "#"
    }
}

extension Dictionary {
    func mapKeyedValues<T>(_ closure: (Key, Value) -> T) -> [Key: T] {
        var mapped = [Key: T]()
        for (key, value) in self {
            mapped[key] = closure(key, value)
        }
        return mapped
    }
}
