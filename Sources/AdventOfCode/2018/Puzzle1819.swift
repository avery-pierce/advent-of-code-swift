
import Foundation

class Puzzle1819: Puzzle {
    let name: String = "2018_19"
    
    func solveA(_ input: Input) -> String {
        let computer = OpcodeComputer()
        var lines = input.lines
        let firstLine = lines.remove(at: 0)
        
        let register = Int(String(firstLine.split(separator: " ")[1]))
        computer.instructionPointerIndex = register
        
        let instructions = lines.map { (instructionDescriptor) -> OpcodeInstruction in
            let parts = instructionDescriptor.split(separator: " ").map(String.init)
            let opcode = Opcode(stringValue: parts[0])!
            
            let a = Int(parts[1])!
            let b = Int(parts[2])!
            let c = Int(parts[3])!
            return OpcodeInstruction(opcode: opcode, a: a, b: b, c: c)
        }
        
        computer.process(instructions)
        print(computer.register)
        return "\(computer.register[0])"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    #ip 0
                    seti 5 0 1
                    seti 6 0 2
                    addi 0 1 0
                    addr 1 2 3
                    setr 1 0 0
                    seti 8 0 4
                    seti 9 0 5
                    """), expectedOutput: "6")
    ]
    
    func solveB(_ input: Input) -> String {
        let computer = OpcodeComputer()
        computer.register[0] = 1
        var lines = input.lines
        let firstLine = lines.remove(at: 0)
        
        let register = Int(String(firstLine.split(separator: " ")[1]))
        computer.instructionPointerIndex = register
        
        let instructions = lines.map { (instructionDescriptor) -> OpcodeInstruction in
            let parts = instructionDescriptor.split(separator: " ").map(String.init)
            let opcode = Opcode(stringValue: parts[0])!
            
            let a = Int(parts[1])!
            let b = Int(parts[2])!
            let c = Int(parts[3])!
            return OpcodeInstruction(opcode: opcode, a: a, b: b, c: c)
        }
        
        computer.process(instructions)
        return "\(computer.register[0])"
    }
    
    var testCasesB: [TestCase] = [
        // Input test cases here
    ]
}
