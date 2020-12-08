
import Foundation

class Puzzle2007: Puzzle {
    let name: String = "2020_07"
    
    func solveA(_ input: Input) -> String {
        let rules = input.lines.map(Rule.init)
        let containers = BagFinder(rules).potentialBagContainers(for: "shiny gold")
        return "\(containers.count)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    light red bags contain 1 bright white bag, 2 muted yellow bags.
                    dark orange bags contain 3 bright white bags, 4 muted yellow bags.
                    bright white bags contain 1 shiny gold bag.
                    muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
                    shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
                    dark olive bags contain 3 faded blue bags, 4 dotted black bags.
                    vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
                    faded blue bags contain no other bags.
                    dotted black bags contain no other bags.
                    """), expectedOutput: "4")
    ]
    
    func solveB(_ input: Input) -> String {
        let rules = input.lines.map(Rule.init)
        let nestedBagCount = BagFinder(rules).countBagsContained(in: "shiny gold")
        return "\(nestedBagCount)"
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("""
                    light red bags contain 1 bright white bag, 2 muted yellow bags.
                    dark orange bags contain 3 bright white bags, 4 muted yellow bags.
                    bright white bags contain 1 shiny gold bag.
                    muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
                    shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
                    dark olive bags contain 3 faded blue bags, 4 dotted black bags.
                    vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
                    faded blue bags contain no other bags.
                    dotted black bags contain no other bags.
                    """), expectedOutput: "32"),
        TestCase(TextInput("""
                    shiny gold bags contain 2 dark red bags.
                    dark red bags contain 2 dark orange bags.
                    dark orange bags contain 2 dark yellow bags.
                    dark yellow bags contain 2 dark green bags.
                    dark green bags contain 2 dark blue bags.
                    dark blue bags contain 2 dark violet bags.
                    dark violet bags contain no other bags.
                    """), expectedOutput: "126")
    ]
    
    struct Rule {
        var container: String
        var contained: [String: Int]
        
        init(_ text: String) {
            let parser = regexParse("^([\\w\\s]+) bags? contains? (?:(\\d+) ([\\w\\s]+) bags?(?:, (\\d+) ([\\w\\s]+) bags?)?(?:, (\\d+) ([\\w\\s]+) bags?)?(?:, (\\d+) ([\\w\\s]+) bags?)?|no other bags).$")
            guard let groups = parser(text) else {
                fatalError("Could not parse \(text)")
            }
            container = groups[0]
            
            contained = [:]
            if (groups.count > 1) {
                contained[groups[2]] = Int(groups[1])!
            }
            if (groups.count > 3) {
                contained[groups[4]] = Int(groups[3])!
            }
            if (groups.count > 5) {
                contained[groups[6]] = Int(groups[5])!
            }
            if (groups.count > 7) {
                contained[groups[8]] = Int(groups[7])!
            }
        }
        
        func contains(_ bagType: String) -> Bool {
            return contained.keys.contains(bagType)
        }
    }
    
    class BagFinder {
        let rules: [Rule]
        init(_ rules: [Rule]) {
            self.rules = rules
        }
        
        func potentialBagContainers(for bagType: String) -> Set<String> {
            var set = Set<String>()
            let directContainers = rules.filter({ $0.contains(bagType) }).map(\.container)
            set.insert(membersOf: directContainers)
            
            let nestedContainers = set.flatMap(potentialBagContainers(for:))
            set.insert(membersOf: nestedContainers)
            return set
        }
        
        func countBagsContained(in bagType: String) -> Int {
            var counter = 0
            let directlyContained = rules
                .filter({ $0.container == bagType })
                .map(\.contained)
                .reduce(Frequency<String>(), { (freq, next) in
                    var newFreq = freq
                    for (key, value) in next {
                        newFreq[key] += value
                    }
                    return newFreq
                })
            
            for bag in directlyContained.uniqueValues {
                let nestedBags = countBagsContained(in: bag) + 1 // add the bag itself
                counter += nestedBags * directlyContained[bag]
            }
            
            return counter
        }
    }
}
