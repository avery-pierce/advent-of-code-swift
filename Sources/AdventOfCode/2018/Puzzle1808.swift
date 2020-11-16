
import Foundation

class Puzzle1808: Puzzle {
    let name: String = "2018_08"
    
    func solveA(_ input: Input) -> String {
        let numbers = input.text.split(separator: " ").map(String.init).compactMap(Int.init)
        let rootNode = NodeParser(numbers).parse()
        let all = allMetadataEntries(of: rootNode)
        let sum = all.reduce(0, +)
        return "\(sum)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"), expectedOutput: "138")
    ]
    
    func solveB(_ input: Input) -> String {
        let numbers = input.text.split(separator: " ").map(String.init).compactMap(Int.init)
        let rootNode = NodeParser(numbers).parse()
        return "\(rootNode.value)"
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2"), expectedOutput: "66")
    ]
    
    func allMetadataEntries(of node: Node) -> [Int] {
        var entries = [Int]()
        entries.append(contentsOf: node.metadataEntries)
        let childEntries = node.children.flatMap({ allMetadataEntries(of: $0) })
        entries.append(contentsOf: childEntries)
        return entries
    }
    
    struct Node {
        var children: [Node] = []
        var metadataEntries: [Int] = []
        
        var length: Int {
            let lengthOfChildren = children.map(\.length).reduce(0, +)
            return 2 + lengthOfChildren + metadataEntries.count
        }
        
        var value: Int {
            if children.isEmpty {
                return metadataEntries.reduce(0, +)
            } else {
                let values = metadataEntries.map { (childIndex) -> Int in
                    if (childIndex <= 0)  { return 0 }
                    if (childIndex > children.count) { return 0 }
                    return children[childIndex - 1].value
                }
                return values.reduce(0, +)
            }
        }
    }
    
    class NodeParser {
        let input: [Int]
        init(_ input: [Int]) {
            self.input = input
        }
        
        var numberOfChildren: Int {
            return input[0]
        }
        
        var numberOfMetadataEntries: Int {
            return input[1]
        }
        
        var cursor: Int = 2
        func parse() -> Node {
            var node = Node()
            for _ in (0..<numberOfChildren) {
                let childParser = NodeParser(Array(input[cursor...]))
                let childNode = childParser.parse()
                node.children.append(childNode)
                cursor += childNode.length
            }
            
            let endOfMetadata = cursor + numberOfMetadataEntries
            node.metadataEntries = Array(input[cursor..<endOfMetadata])
            return node
        }
    }
}
