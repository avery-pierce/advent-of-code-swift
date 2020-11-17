import Foundation
import ArgumentParser

struct AdventOfCode: ParsableCommand {
    
    static let inputCacheFolderPath = "./inputCache"
    
    @Flag(name: .shortAndLong, help: "List all the puzzles")
    var list = false
    
    @Argument(help: "The puzzle to execute")
    var puzzle: String?
    
    mutating func run() throws {
        if list {
            // Output a list of loaded puzzles, and exit
            printAllPuzzles()
            return
        }
        
        guard let puzzle = puzzle else {
            throw PlainError("Please enter a puzzle name. Use --list to list puzzles")
        }
        
        guard let selectedPuzzle = selectPuzzle(named: puzzle) else {
            throw PlainError("Could not find a puzzle named \(puzzle). Use --list to list puzzles")
        }
        
        printSolution(to: selectedPuzzle)
    }
    
    func printAllPuzzles() {
        print("Puzzles loaded:")
        let puzzles = gatherPuzzles()
        puzzles.forEach { (puzzle) in
            if puzzle.hasTests {
                print("  \(puzzle.name): \(puzzle.allTestsPass ? "✅" : "❌")")
            } else {
                print("  \(puzzle.name)")
            }
        }
    }
    
    func printSolution(to puzzle: Puzzle) {
        print("Solving \(puzzle.name)")
        let puzzleInput = getInput(for: puzzle)
        
        if puzzle.testCasesA.count > 0 {
            print("Running test cases on A:")
            printTestResults(for: puzzle.testCasesA, using: puzzle.solveA(_:))
        }
        
        if (puzzle.allATestsPass) {
            print("Solving A:")
            print("==========")
            let solutionA = puzzle.solveA(puzzleInput)
            print(solutionA)
        } else {
            print("Test cases failed. Not attempting to solve")
        }
        
        print("")
        
        if puzzle.testCasesB.count > 0 {
            print("Running test cases on B:")
            printTestResults(for: puzzle.testCasesB, using: puzzle.solveB(_:))
        }
        if (puzzle.allBTestsPass) {
            print("Solving B:")
            print("==========")
            let solutionB = puzzle.solveB(puzzleInput)
            print(solutionB)
        } else {
            print("Test cases failed. Not attempting to solve")
        }
    }
    
    func getInput(for puzzle: Puzzle) -> Input {
        let destinationPath = "\(AdventOfCode.inputCacheFolderPath)/\(puzzle.name).input.txt"
        if (FileManager.default.fileExists(atPath: destinationPath)) {
            return FileInput(path: destinationPath)
        }
        
        let input = STDIN()
        let data = input.data
        
        createInputCacheFolderIfNeeded()
        guard FileManager.default.createFile(atPath: destinationPath, contents: data, attributes: nil) else {
            fatalError("unable to write cache file")
        }
        return input
    }
    
    func createInputCacheFolderIfNeeded() {
        guard FileManager.default.fileExists(atPath: AdventOfCode.inputCacheFolderPath) else {
            try! FileManager.default.createDirectory(atPath: AdventOfCode.inputCacheFolderPath, withIntermediateDirectories: true, attributes: nil)
            return
        }
    }
    
    func printTestResults(for tests: [TestCase], using solver: (Input) -> String) {
        for (i, test) in tests.enumerated() {
            let startTime = Date()
            let result = solver(test.input)
            let endTime = Date()
            let duration = endTime.timeIntervalSince(startTime)
            let passes = result == test.expectedOutput
            print("\(i): \(passes ? "✅" : "❌") (\(formatDuration(duration)))")
            if !passes {
                print("  expected: \(test.expectedOutput)")
                print("    actual: \(result)")
            }
        }
    }
}

AdventOfCode.main()

func formatDuration(_ duration: TimeInterval) -> String {
    if (duration < 1) {
        let ms = duration * 1000
        
        return "\(round(ms)) ms"
    } else if (duration < 60) {
        return "\(roundToDecimalPlaces(duration, decimalPlaces: 2)) s"
    } else {
        let mins = duration / 60
        return "\(roundToDecimalPlaces(mins, decimalPlaces: 2))"
    }
}

func roundToDecimalPlaces(_ number: Double, decimalPlaces: Int) -> Double {
    let multiplier = Double(10 ^ decimalPlaces)
    let shiftedNumber = number * multiplier
    let rounded = round(shiftedNumber)
    return rounded / multiplier
}

func selectPuzzle(named name: String) -> Puzzle? {
    return gatherPuzzles().first(where: { $0.name == name })
}

func gatherPuzzles() -> [Puzzle] {
    return [
        Puzzle1801(),
        Puzzle1802(),
        Puzzle1803(),
        Puzzle1804(),
        Puzzle1805(),
        Puzzle1806(),
        Puzzle1807(),
        Puzzle1808(),
        Puzzle1809(),
        Puzzle1810(),
        Puzzle1811(),
        Puzzle1812(),
        Puzzle1813(),
        Puzzle1814(),
        Puzzle1815(),
        Puzzle1816(),
        Puzzle1817(),
        Puzzle1818(),
        Puzzle1819(),
        Puzzle1820(),
        Puzzle1821(),
        Puzzle1822(),
        Puzzle1823(),
        Puzzle1824(),
        Puzzle1825(),

        Puzzle1901(),
        Puzzle1902(),
        Puzzle1903(),
        Puzzle1904(),
        Puzzle1905(),
        Puzzle1906(),
        Puzzle1907(),
        Puzzle1908(),
        Puzzle1909(),
        Puzzle1910(),
        Puzzle1911(),
        Puzzle1912(),
        Puzzle1913(),
        Puzzle1914(),
        Puzzle1915(),
        Puzzle1916(),
        Puzzle1917(),
        Puzzle1918(),
        Puzzle1919(),
        Puzzle1920(),
        Puzzle1921(),
        Puzzle1922(),
        Puzzle1923(),
        Puzzle1924(),
        Puzzle1925(),

        Puzzle2001(),
        Puzzle2002(),
        Puzzle2003(),
        Puzzle2004(),
        Puzzle2005(),
        Puzzle2006(),
        Puzzle2007(),
        Puzzle2008(),
        Puzzle2009(),
        Puzzle2010(),
        Puzzle2011(),
        Puzzle2012(),
        Puzzle2013(),
        Puzzle2014(),
        Puzzle2015(),
        Puzzle2016(),
        Puzzle2017(),
        Puzzle2018(),
        Puzzle2019(),
        Puzzle2020(),
        Puzzle2021(),
        Puzzle2022(),
        Puzzle2023(),
        Puzzle2024(),
        Puzzle2025(),
    ]
}

struct PlainError: Error {
    var message: String
    init(_ message: String) {
        self.message = message
    }
}


