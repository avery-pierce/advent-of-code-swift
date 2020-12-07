
import Foundation

let regex = try! NSRegularExpression(pattern: "\\(([NSEW]*)\\|([NSEW]*)(?:\\|([NSEW]*))?\\)", options: [])

class Puzzle1820: Puzzle {
    let name: String = "2018_20"
    
    func solveA(_ input: Input) -> String {
        let paths = uniquePaths(input.text)
        
        var shortestPathToReach = Frequency<GridCoordinate>()
        for path in paths {
            var currentLocation = GridCoordinate.zero
            let directions = path.map(vector(for:))
            for (i, direction) in directions.enumerated() {
                let steps = i
                currentLocation = currentLocation.moved(by: direction)
                if shortestPathToReach[currentLocation] == 0 && currentLocation != .zero {
                    shortestPathToReach[currentLocation] = steps
                } else if shortestPathToReach[currentLocation] > steps {
                    shortestPathToReach[currentLocation] = steps
                }
            }
        }
        
        let longestPath = shortestPathToReach.mostFrequent!
        let longest = shortestPathToReach[longestPath]
        return "\(longest)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("^WNE$"), expectedOutput: "3"),
        TestCase(TextInput("^ESSWWN(E|NNENN(EESS(WNSE|)SSS|WWWSSSSE(SW|NNNE)))$"), expectedOutput: "23"),
        TestCase(TextInput("^WSSEESWWWNW(S|NENNEEEENN(ESSSSW(NWSW|SSEN)|WSWWN(E|WWS(E|SS))))$"), expectedOutput: "31"),
        TestCase(TextInput("^WNE(|NN|EEE)$"), expectedOutput: "6"),
        TestCase(TextInput("^(E|SEN)$"), expectedOutput: "2"),
    ]
    
    func solveB(_ input: Input) -> String {
        return "unsolved"
    }
    
    var testCasesB: [TestCase] = [
        // Input test cases here
    ]
    
    func uniquePaths(_ directions: String) -> Set<String> {
        if (!directions.contains("(")) {
            return Set([directions])
        }
        
        let fullStringRange = NSRange(location: 0, length: directions.count)
        guard let firstMatch = regex.firstMatch(in: directions, options: [], range: fullStringRange) else {
            return Set()
        }
        
        let ranges = (0..<firstMatch.numberOfRanges).map { (index) in
            return firstMatch.range(at: index)
        }
        
        let nsString = NSString(string: directions)
       
        let placeholderRange = ranges[0]
        var set = Set<String>()
        for range in ranges[1...] {
            if range.location >= nsString.length { continue }
            
            let option = nsString.substring(with: range)
            let result = nsString.replacingCharacters(in: placeholderRange, with: option)
            set.insert(membersOf: uniquePaths(result))
        }
        
        return set
    }
    
    func findLongestPath(_ directions: String) -> String {
        if (!directions.contains("(")) {
            return directions
        }
        
        let fullStringRange = NSRange(location: 0, length: directions.count)
        guard let firstMatch = regex.firstMatch(in: directions, options: [], range: fullStringRange) else {
            return directions
        }
        
        let ranges = (0..<firstMatch.numberOfRanges).map { (index) in
            return firstMatch.range(at: index)
        }
        print(ranges)
        let nsString = NSString(string: directions)
        
        let placeholderRange = ranges[0]
        var longerRange: NSRange = (ranges[1].length > ranges[2].length) ? ranges[1] : ranges[2]
        if (ranges.count > 3 && ranges[3].length > longerRange.length) {
            longerRange = ranges[3]
        }
        
        let longerString = nsString.substring(with: longerRange)
        
        let result = nsString.replacingCharacters(in: placeholderRange, with: longerString)
        return findLongestPath(result)
    }
    
    func vector(for direction: Character) -> GridVector {
        switch direction {
        case "N": return .north
        case "S": return .south
        case "E": return .east
        case "W": return .south
        case "^": return GridVector(dx: 0, dy: 0)
        case "$": return GridVector(dx: 0, dy: 0)
        default: fatalError("Unknown direction \(direction)")
        }
    }
}
