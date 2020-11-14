
import Foundation

class Puzzle1804: Puzzle {
    let name: String = "2018_04"
    
    func solveA(_ input: Input) -> String {
        let logBook = LogBook(input)
        let sleepiestGuard = logBook.sleepiestGuardId
        var sleepingSeconds = Frequency<Int>()
        logBook.allShifts(forGuard: sleepiestGuard).forEach { (shift) in
            shift.secondsAsleep.forEach({ sleepingSeconds.increment($0) })
        }
        
        let result = sleepiestGuard * sleepingSeconds.mostFrequent!
        return "\(result)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    [1518-11-01 00:00] Guard #10 begins shift
                    [1518-11-01 00:05] falls asleep
                    [1518-11-01 00:25] wakes up
                    [1518-11-01 00:30] falls asleep
                    [1518-11-01 00:55] wakes up
                    [1518-11-01 23:58] Guard #99 begins shift
                    [1518-11-02 00:40] falls asleep
                    [1518-11-02 00:50] wakes up
                    [1518-11-03 00:05] Guard #10 begins shift
                    [1518-11-03 00:24] falls asleep
                    [1518-11-03 00:29] wakes up
                    [1518-11-04 00:02] Guard #99 begins shift
                    [1518-11-04 00:36] falls asleep
                    [1518-11-04 00:46] wakes up
                    [1518-11-05 00:03] Guard #99 begins shift
                    [1518-11-05 00:45] falls asleep
                    [1518-11-05 00:55] wakes up
                    """), expectedOutput: "240")
    ]
    
    func solveB(_ input: Input) -> String {
        let logBook = LogBook(input)
        let allGuards = logBook.allGuards
        
        let chosenGuard = allGuards.max { (leftGuard, rightGuard) -> Bool in
            let leftGuardShifts = logBook.allShifts(forGuard: leftGuard)
            let leftGuardSecondFrequency = Frequency<Int>(leftGuardShifts.flatMap(\.secondsAsleep))
            let leftChosenSecond = leftGuardSecondFrequency.mostFrequent ?? 0
            
            let rightGuardShifts = logBook.allShifts(forGuard: rightGuard)
            let rightGuardSecondFequency = Frequency<Int>(rightGuardShifts.flatMap(\.secondsAsleep))
            let rightChosenSecond = rightGuardSecondFequency.mostFrequent ?? 0
            
            return leftGuardSecondFrequency[leftChosenSecond] < rightGuardSecondFequency[rightChosenSecond]
        }!
        
        let chosenGuardShifts = logBook.allShifts(forGuard: chosenGuard)
        let chosenGuardSecondFrequency = Frequency<Int>(chosenGuardShifts.flatMap(\.secondsAsleep))
        let chosenGuardChosenSecond = chosenGuardSecondFrequency.mostFrequent!
        
        let output = chosenGuard * chosenGuardChosenSecond
        return "\(output)"
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("""
                    [1518-11-01 00:00] Guard #10 begins shift
                    [1518-11-01 00:05] falls asleep
                    [1518-11-01 00:25] wakes up
                    [1518-11-01 00:30] falls asleep
                    [1518-11-01 00:55] wakes up
                    [1518-11-01 23:58] Guard #99 begins shift
                    [1518-11-02 00:40] falls asleep
                    [1518-11-02 00:50] wakes up
                    [1518-11-03 00:05] Guard #10 begins shift
                    [1518-11-03 00:24] falls asleep
                    [1518-11-03 00:29] wakes up
                    [1518-11-04 00:02] Guard #99 begins shift
                    [1518-11-04 00:36] falls asleep
                    [1518-11-04 00:46] wakes up
                    [1518-11-05 00:03] Guard #99 begins shift
                    [1518-11-05 00:45] falls asleep
                    [1518-11-05 00:55] wakes up
                    """), expectedOutput: "4455")
    ]
    
    struct Log {
        var dateString: String
        var event: Event
        
        enum Event {
            case beginShift(Int)
            case fallsAlseep
            case wakesUp
            
            init(descriptor: String) {
                if descriptor == "falls asleep" {
                    self = .fallsAlseep
                } else if descriptor == "wakes up" {
                    self = .wakesUp
                } else {
                    let parts = descriptor.split(separator: " ")
                    let guardString = parts[1]
                    
                    let guardId = Int(guardString[guardString.index(after: guardString.startIndex)...])!
                    self = .beginShift(guardId)
                }
            }
        }
        
        init(_ descriptor: String) {
            let dateStartIndex = descriptor.startIndex
            let dateEndIndex = descriptor.index(dateStartIndex, offsetBy: 18)
            self.dateString = String(descriptor[dateStartIndex...dateEndIndex])
            
            let guardStartIndex = descriptor.index(dateEndIndex, offsetBy: 1)
            let eventString = String(descriptor[guardStartIndex...])
            self.event = Event(descriptor: eventString)
        }
        
        var secondsComponent: Int {
            let indexOfColon = dateString.lastIndex(of: ":")!
            let secondStartIndex = dateString.index(after: indexOfColon)
            let secondEndIndex = dateString.index(secondStartIndex, offsetBy: 2)
            return Int(dateString[secondStartIndex..<secondEndIndex])!
        }
    }
    
    struct LogBook {
        var logEntries: [Log]
        
        init(_ input: Input) {
            let sortedLines = input.lines.sorted()
            self.logEntries = sortedLines.map(Log.init)
        }
        
        var shifts: [Shift] {
            var _shifts = [Shift]()
            var currentShift: Shift?
            
            for log in logEntries {
                switch log.event {
                case .fallsAlseep, .wakesUp:
                    currentShift?.logEntries.append(log)
                    
                case .beginShift(let guardId):
                    // A new shift begins
                    if let currentShift = currentShift {
                        _shifts.append(currentShift)
                    }
                    currentShift = Shift(guardOnDuty: guardId, logEntries: [])
                }
            }
            
            if let currentShift = currentShift {
                _shifts.append(currentShift)
            }
            return _shifts
        }
        
        var allGuards: Set<Int> {
            return Set(shifts.map(\.guardOnDuty))
        }
        
        func allShifts(forGuard guardId: Int) -> [Shift] {
            return shifts.filter({ $0.guardOnDuty == guardId })
        }
        
        var sleepiestGuardId: Int {
            return allGuards.max { (leftGuardID, rightGuardID) -> Bool in
                let leftTimeAsleep = timeGuardSpendAsleep(leftGuardID)
                let rightTimeAsleep = timeGuardSpendAsleep(rightGuardID)
                return leftTimeAsleep < rightTimeAsleep
            }!
        }
        
        func timeGuardSpendAsleep(_ guardId: Int) -> Int {
            return allShifts(forGuard: guardId).map({ $0.timeAsleep }).reduce(0, +)
        }
    }
    
    struct Shift {
        var guardOnDuty: Int
        var logEntries: [Log]
        
        var secondsAsleep: [Int] {
            var seconds = [Int]()
            var fellAsleepTime = 0
            for log in logEntries {
                switch log.event {
                case .fallsAlseep:
                    fellAsleepTime = log.secondsComponent
                    
                case .wakesUp:
                    let wakeUpTime = log.secondsComponent
                    seconds.append(contentsOf: (fellAsleepTime..<wakeUpTime))
                    
                case .beginShift:
                    fellAsleepTime = 0
                    
                }
            }
            
            return seconds
        }
        
        var timeAsleep: Int {
            return secondsAsleep.count
        }
    }
    

}
