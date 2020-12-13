
import Foundation

class Puzzle2013: Puzzle {
    let name: String = "2020_13"
    
    func solveA(_ input: Input) -> String {
        let currentTime = Int(input.lines[0])!
        let schedules = input.lines[1].split(separator: ",").map(String.init)
        let ints = schedules.compactMap(Int.init)
        
        let pairs = ints.map({ return ($0, ($0 - currentTime % $0)) })
        print(pairs)
        let next = pairs.min(by: { $0.1 < $1.1 })!
        print(next)
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
        
        let result = t2(ints)
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
    
    func looper(_ schedule: [(Int, offset: Int)], startingAt: Int = 0, iteration: Int) -> Int {
        var currentTime = startingAt
        while true {
            if check(currentTime, schedule: schedule) {
                return currentTime
            }
            currentTime += iteration
        }
    }
    
    func t1(_ schedule: [(Int, offset: Int)]) -> Int {
        let firstResult = schedule[0].0
        return looper(schedule, iteration: firstResult)
    }
    
    func t2(_ schedule: [(Int, offset: Int)]) -> Int {
        let firstResult = schedule[0].0
        let first2 = Array(schedule[0...1])
        let s2 = looper(first2, startingAt: 0, iteration: firstResult)
        let p2 = first2.map(\.0).reduce(1, *)
        guard schedule.count > 2 else { return s2 }
        
        let first3 = Array(schedule[0...2])
        let s3 = looper(first3, startingAt: s2, iteration: p2)
        let p3 = first3.map(\.0).reduce(1, *)
        guard schedule.count > 3 else { return s3 }
        
        let first4 = Array(schedule[0...3])
        let s4 = looper(first4, startingAt: s3, iteration: p3)
        let p4 = first4.map(\.0).reduce(1, *)
        guard schedule.count > 4 else  { return s4 }
        
        let first5 = Array(schedule[0...4])
        let s5 = looper(first5, startingAt: s4, iteration: p4)
        let p5 = first5.map(\.0).reduce(1, *)
        guard schedule.count > 5 else  { return s5 }
        
        let first6 = Array(schedule[0...5])
        let s6 = looper(first6, startingAt: s5, iteration: p5)
        let p6 = first6.map(\.0).reduce(1, *)
        guard schedule.count > 6 else  { return s6 }
        
        let first7 = Array(schedule[0...6])
        let s7 = looper(first7, startingAt: s6, iteration: p6)
        let p7 = first6.map(\.0).reduce(1, *)
        guard schedule.count > 7 else  { return s7 }
        
        let first8 = Array(schedule[0...7])
        let s8 = looper(first8, startingAt: s7, iteration: p7)
        let p8 = first6.map(\.0).reduce(1, *)
        guard schedule.count > 8 else  { return s8 }
        
        let first9 = Array(schedule[0...8])
        let s9 = looper(first9, startingAt: s8, iteration: p8)
        let p9 = first6.map(\.0).reduce(1, *)
        guard schedule.count > 9 else  { return s9 }
        
        return 0
        
    }
    
    // first3: [(17, offset: 0), (13, offset: 2), (19, offset: 3)], s2: 102, p2: 221, s3: 3417

    
    func check(_ t: Int, schedule: [(Int, offset: Int)]) -> Bool {
        return schedule.allSatisfy { (time, offset) -> Bool in
            return (t + offset) % time == 0
        }
    }
}
