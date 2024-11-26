
import Foundation
import AdventOfCode

class Puzzle2013: Puzzle {
    let name: String = "2020_13"
    
    func solveA(_ input: Input) -> String {
        let currentTime = Int(input.lines[0])!
        let schedules = input.lines[1].split(separator: ",").map(String.init)
        let ints = schedules.compactMap(Int.init)
        
        let pairs = ints.map({ return ($0, ($0 - currentTime % $0)) })
        let next = pairs.min(by: { $0.1 < $1.1 })!
        return "\(next.0 * next.1)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    939
                    7,13,x,x,59,x,31,19
                    """), expectedOutput: "295")
    ]
    
    func solveB(_ input: Input) -> String {
        let ints = input.lines[1]
            .split(separator: ",")
            .map(String.init)
            .enumerated()
            .compactMap { (i, x) -> (Int, offset: Int)? in
                guard let int = Int(x) else { return nil }
                return(int, offset: i)
            }
        
        let result = contestSolution(ints)
        return "\(result)"
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("""
                    939
                    7,13,x,x,59,x,31,19
                    """), expectedOutput: "1068781"),
        TestCase(TextInput("""
                    0
                    17,x,13,19
                    """), expectedOutput: "3417"),
        TestCase(TextInput("""
                    0
                    67,7,59,61
                    """), expectedOutput: "754018"),
        TestCase(TextInput("""
                    0
                    67,x,7,59,61
                    """), expectedOutput: "779210"),
        TestCase(TextInput("""
                    0
                    67,7,x,59,61
                    """), expectedOutput: "1261476"),
        TestCase(TextInput("""
                    0
                    1789,37,47,1889
                    """), expectedOutput: "1202161486"),
    ]
    
    func contestSolution(_ schedule: [(Int, offset: Int)]) -> Int {
        var checkingSchedule = [(Int, offset: Int)]()
        var s = 0
        var p = 1
        for bus in schedule {
            checkingSchedule.append(bus)
            let match = looper(checkingSchedule, startingAt: s, iteration: p)
            s = match
            p = p * bus.0
        }
        return s
    }
    
    /// isterate the schedule until the time meets the criteria set by the contest
    func looper(_ schedule: [(Int, offset: Int)], startingAt: Int = 0, iteration: Int) -> Int {
        var currentTime = startingAt
        while true {
            if check(currentTime, schedule: schedule) {
                return currentTime
            }
            currentTime += iteration
        }
    }
    
    /// Returns whether this time meets the criteria set by the contest
    func check(_ t: Int, schedule: [(Int, offset: Int)]) -> Bool {
        return schedule.allSatisfy { (time, offset) -> Bool in
            return (t + offset) % time == 0
        }
    }
}
