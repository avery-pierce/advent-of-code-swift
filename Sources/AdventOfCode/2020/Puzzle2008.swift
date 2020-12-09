
import Foundation

class Puzzle2008: Puzzle {
    let name: String = "2020_08"
    
    func solveA(_ input: Input) -> String {
        let operations = input.lines.map(Instruction.init)
        
        let prg = Program(operations)
        prg.runUntilRepeat()
        
        return "\(prg.accumulator)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    nop +0
                    acc +1
                    jmp +4
                    acc +3
                    jmp -3
                    acc -99
                    acc +1
                    jmp -4
                    acc +6
                    """), expectedOutput: "5")
    ]
    
    func solveB(_ input: Input) -> String {
        let operations = input.lines.map(Instruction.init)
        
        let alternatives = (0..<operations.count).compactMap { (index) -> [Instruction]? in
            let instruction = operations[index]
            if instruction.op == .acc { return nil }
            
            var alt = operations
            alt[index].op.flip()
            return alt
        }
        
        for alt in alternatives {
            let prg = Program(alt)
            if prg.terminatesNormally() {
                return "\(prg.accumulator)"
            }
        }
        return ""
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("""
                    nop +0
                    acc +1
                    jmp +4
                    acc +3
                    jmp -3
                    acc -99
                    acc +1
                    jmp -4
                    acc +6
                    """), expectedOutput: "8")
    ]
    
    enum Operation: String {
        case acc = "acc"
        case jmp = "jmp"
        case nop = "nop"
        
        mutating func flip() {
            switch self {
            case .jmp: self = .nop
            case .nop: self = .jmp
            default: break
            }
        }
        
        func flipped() -> Operation {
            var newOp = self
            newOp.flip()
            return newOp
        }
    }
    
    struct Instruction {
        var op: Operation
        var arg: Int
        
        init(_ string: String) {
            let result = regexParse("^(\\w{3}) ([\\+-]\\d+)$")(string)!
            self.op = Operation(rawValue: result[0])!
            self.arg = Int(result[1])!
        }
    }
    
    class Program {
        var instructions: [Instruction]
        var index = 0
        var accumulator = 0
        var processedInstructions = Set<Int>()
        
        init(_ instructions: [Instruction]) {
            self.instructions = instructions
        }
        
        func reset() {
            index = 0
            accumulator = 0
            processedInstructions = Set<Int>()
        }
        
        func runUntilRepeat() {
            reset()
            while !processedInstructions.contains(index) {
                processedInstructions.insert(index)
                execute(instructions[index])
            }
        }
        
        func terminatesNormally() -> Bool {
            reset()
            while !processedInstructions.contains(index) {
                processedInstructions.insert(index)
                execute(instructions[index])
                if index >= instructions.count {
                    print("index: \(index), accumulator: \(accumulator)")
                    return true
                }
            }
            return false
        }
        
        func hasInfiniteLoop() -> Bool {
            return !terminatesNormally()
        }
        
        func execute(_ instruction: Instruction) {
            switch instruction.op {
            case .acc:
                accumulator += instruction.arg
                index += 1
                
            case .jmp:
                index += instruction.arg
                
            case .nop:
                index += 1
            }
        }
    }
}
