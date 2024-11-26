
import Foundation
import AdventOfCode

class Puzzle1816: Puzzle {
    let name: String = "2018_16"
    
    func solveA(_ input: Input) -> String {
        let (section1, _) = parseInput(input)
        let threeOrMore = section1.filter { (test) -> Bool in
            let allPossibilities = OpcodeInstruction.allVariations(of: test.instruction)
            let validPossibilities = allPossibilities.filter { (instruction) -> Bool in
                let actual = instruction.apply(to: test.before)
                return actual == test.after
            }
            return validPossibilities.count >= 3
        }
        return "\(threeOrMore.count)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    Before: [3, 2, 1, 1]
                    9 2 1 2
                    After:  [3, 2, 2, 1]
                    
                    9 2 1 2
                    """), expectedOutput: "1")
    ]
    
    func solveB(_ input: Input) -> String {
        let (_, section2) = parseInput(input)
        let result = section2.reduce([0, 0, 0, 0], { $1.apply(to: $0) })
        return result.map(String.init).joined(separator: ", ")
    }
    
    var testCasesB: [TestCase] = [
        // Input test cases here
    ]
    
    func parseInput(_ input: Input) -> (section1: [OpcodeTest], section2: [OpcodeInstruction]) {
        var groups = input.lines.split(separator: "")
        let programInput = groups.popLast()
        print("Trials: \(groups.count)")
        
        let tests = groups.map(Array.init).enumerated().map { (index, opcodeTestLines) -> OpcodeTest in
            let beforeRegister = OpcodeTest.parseRegisterLine(opcodeTestLines[0])
            let opcodeInstruction = UnknownOpcodeInstruction(descriptor: opcodeTestLines[1])
            let afterRegister = OpcodeTest.parseRegisterLine(opcodeTestLines[2])
            return OpcodeTest(before: beforeRegister, after: afterRegister, instruction: opcodeInstruction)
        }
        
        let program = Array(programInput!)
            .map(UnknownOpcodeInstruction.init(descriptor:))
            .map(OpcodeInstruction.from(_:))
        
        return (section1: tests, section2: program)
    }
    
    struct OpcodeTest {
        var before: [Int]
        var after: [Int]
        var instruction: UnknownOpcodeInstruction
        
        static func parseRegisterLine(_ string: String) -> [Int] {
            let startIndex = string.index(string.startIndex, offsetBy: 9)
            let endIndex = string.index(startIndex, offsetBy: 9)
            let range = string[startIndex...endIndex]
            print(range)
            let numbers = range.split(separator: ",").map(String.init).map({ $0.trimmingCharacters(in: .whitespaces) }).compactMap(Int.init)
            return numbers
        }
    }
    
    struct UnknownOpcodeInstruction {
        var opcode: Int
        var a: Int
        var b: Int
        var c: Int
        
        init(_ args: [Int]) {
            guard args.count == 4 else {
                fatalError("Incorrect number of opcode arguments")
            }
            
            opcode = args[0]
            a = args[1]
            b = args[2]
            c = args[3]
        }
        
        init(descriptor: String) {
            print("desc: \(descriptor)")
            let numbers = descriptor.split(separator: " ").map(String.init).compactMap(Int.init)
            self.init(numbers)
        }
    }
}

extension OpcodeInstruction {
    static func from(_ instruction: Puzzle1816.UnknownOpcodeInstruction) -> OpcodeInstruction {
        return OpcodeInstruction(opcode: Opcode(rawValue: instruction.opcode)!, a: instruction.a, b: instruction.b, c: instruction.c)
    }
    
    static func allVariations(of instruction: Puzzle1816.UnknownOpcodeInstruction) -> [OpcodeInstruction] {
        return Opcode.allCases.map { (opcode) -> OpcodeInstruction in
            return OpcodeInstruction(opcode: opcode, a: instruction.a, b: instruction.b, c: instruction.c)
        }
    }
}
