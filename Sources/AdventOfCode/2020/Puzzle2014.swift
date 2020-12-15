
import Foundation

class Puzzle2014: Puzzle {
    let name: String = "2020_14"
    
    func solveA(_ input: Input) -> String {
        let instructions = input.lines.map(Instruction.init)
        let simulation = Simulation()
        for instruction in instructions {
            simulation.process(instruction)
        }
        
        let sum = simulation.mem.values.reduce(0, +)
        return "\(sum)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
                    mem[8] = 11
                    mem[7] = 101
                    mem[8] = 0
                    """), expectedOutput: "165")
    ]
    
    func solveB(_ input: Input) -> String {
        let instructions = input.lines.map(Instruction.init)
        let simulation = Simulation2()
        for instruction in instructions {
            simulation.process(instruction)
        }
        
        let sum = simulation.mem.values.reduce(0, +)
        return "\(sum)"
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("""
                    mask = 000000000000000000000000000000X1001X
                    mem[42] = 100
                    mask = 00000000000000000000000000000000X0XX
                    mem[26] = 1
                    """), expectedOutput: "208")
    ]
    
    class Simulation {
        var currentMask: String = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
        var mem = [Int: Int]()
        
        func process(_ instruction: Instruction) {
            switch instruction {
            case .setMask(let newMask):
                self.currentMask = newMask
                
            case .setMem(index: let index, value: let value):
                let maskedValue = mask(value, using: currentMask)
                mem[index] = maskedValue
            }
        }
    }
    
    class Simulation2 : Simulation {
        override func process(_ instruction: Puzzle2014.Instruction) {
            switch instruction {
            case .setMask(let newMask):
                self.currentMask = newMask
                
            case .setMem(index: let address, value: let value):
                let maskedMemoryAddress = maskAddr(address, using: currentMask)
                let resultAddresses = expandFloatingAddresses(maskedMemoryAddress)
                for addr in resultAddresses {
                    mem[addr] = value
                }
            }
        }
    }
    
    enum Instruction {
        case setMask(String)
        case setMem(index: Int, value: Int)
        
        init(_ descriptor: String) {
            let comps = descriptor.split(separator: " ")
            let value = String(comps[2])
            if (comps[0] == "mask") {
                self = .setMask(value)
            } else {
                let parsed = regexParse("mem\\[(\\d+)\\]")(String(comps[0]))!
                let index = Int(parsed[0])!
                let v = Int(value)!
                self = .setMem(index: index, value: v)
            }
        }
    }
}

fileprivate func mask(_ input: Int, using bitmask: String) -> Int {
    var masked = input
    masked = maskZeros(masked, using: bitmask)
    masked = maskOnes(masked, using: bitmask)
    return masked
}

fileprivate func maskZeros(_ input: Int, using bitmask: String) -> Int {
    let andMask = Int(bitmask.replacingOccurrences(of: "X", with: "1"), radix: 2)!
    return input & andMask
}

fileprivate func maskOnes(_ input: Int, using bitmask: String) -> Int {
    let andMask = Int(bitmask.replacingOccurrences(of: "X", with: "0"), radix: 2)!
    return input | andMask
}

fileprivate func maskAddr(_ input: Int, using bitmask: String) -> String {
    let shortBinaryString = String(input, radix: 2)
    let binaryString = insertLeadingZeros(shortBinaryString, toLength: bitmask.count)
    let chars = bitmask.enumerated().map { (i, char) -> String.Element in
        switch char {
        case "0":
            let index = binaryString.index(binaryString.startIndex, offsetBy: i)
            return binaryString[index]
        case "1": return "1"
        case "X": return "X"
        default: fatalError()
        }
    }
    return String(chars)
}

fileprivate func expandFloatingAddresses(_ input: String) -> [Int] {
    guard let i = input.firstIndex(of: "X") else { return [Int(input, radix: 2)!] }
    let j = input.index(after: i)
    let range = i..<j
    
    let zero = input.replacingCharacters(in: range, with: "0")
    let one = input.replacingCharacters(in: range, with: "1")
    return [zero, one].flatMap(expandFloatingAddresses)
}

fileprivate func insertLeadingZeros(_ input: String, toLength length: Int) -> String {
    var newString = input
    while newString.count < length {
        newString.insert("0", at: newString.startIndex)
    }
    return newString
}
