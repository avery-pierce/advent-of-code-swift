
import Foundation

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
    
    struct OpcodeInstruction {
        var opcode: Opcode
        var a: Int
        var b: Int
        var c: Int
        
        static func from(_ instruction: UnknownOpcodeInstruction) -> OpcodeInstruction {
            return OpcodeInstruction(opcode: Opcode(instruction.opcode), a: instruction.a, b: instruction.b, c: instruction.c)
        }
        
        static func allVariations(of instruction: UnknownOpcodeInstruction) -> [OpcodeInstruction] {
            return Opcode.allCases.map { (opcode) -> OpcodeInstruction in
                return OpcodeInstruction(opcode: opcode, a: instruction.a, b: instruction.b, c: instruction.c)
            }
        }
        
        func apply(to register: [Int]) -> [Int] {
            var reg = register
            
            switch opcode {
            case .addr:
                reg[c] = reg[a] + reg[b]
            case .addi:
                reg[c] = reg[a] + b
                
            case .mulr:
                reg[c] = reg[a] * reg[b]
            case .muli:
                reg[c] = reg[a] * b
                
            case .banr:
                reg[c] = reg[a] & reg[b]
            case .bani:
                reg[c] = reg[a] & b
                
            case .borr:
                reg[c] = reg[a] | reg[b]
            case .bori:
                reg[c] = reg[a] | b
                
            case .setr:
                reg[c] = reg[a]
            case .seti:
                reg[c] = a
                
            case .gtir:
                reg[c] = a > reg[b] ? 1 : 0
            case .gtri:
                reg[c] = reg[a] > b ? 1 : 0
            case .gtrr:
                reg[c] = reg[a] > reg[b] ? 1 : 0
                
            case .eqir:
                reg[c] = a == reg[b] ? 1 : 0
            case .eqri:
                reg[c] = reg[a] == b ? 1 : 0
            case .eqrr:
                reg[c] = reg[a] == reg[b] ? 1 : 0
            }
            
            return reg
        }
    }
    
    enum Opcode: CaseIterable {
        static let lookup: [Int: Opcode] = [
            0: .gtrr,
            1: .borr,
            2: .gtir,
            3: .eqri,
            4: .addr,
            5: .seti,
            6: .eqrr,
            7: .gtri,
            8: .banr,
            9: .addi,
            10: .setr,
            11: .mulr,
            12: .bori,
            13: .muli,
            14: .eqir,
            15: .bani,
        ]
        
        static var allUnknownCases: [Opcode] {
            let allKnownCases = Set(lookup.values)
            return allCases.filter({ !allKnownCases.contains($0) })
        }
        
        init(_ int: Int) {
            self = Opcode.lookup[int]!
        }
        
        case addr
        case addi
        
        case mulr
        case muli
        
        case banr
        case bani
        
        case borr
        case bori
        
        case setr
        case seti
        
        case gtir
        case gtri
        case gtrr
        
        case eqir
        case eqri
        case eqrr
        
        
    }
}
