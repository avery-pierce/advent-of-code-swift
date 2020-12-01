//
//  File.swift
//  
//
//  Created by Avery Pierce on 11/25/20.
//

import Foundation

enum Opcode: Int, CaseIterable {
    init?(stringValue: String) {
        switch stringValue {
        case "addr": self = .addr
        case "addi": self = .addi
            
        case "mulr": self = .mulr
        case "muli": self = .muli
            
        case "banr": self = .banr
        case "bani": self = .bani
            
        case "borr": self = .borr
        case "bori": self = .bori
            
        case "setr": self = .setr
        case "seti": self = .seti
            
        case "gtir": self = .gtir
        case "grri": self = .gtri
        case "gtrr": self = .gtrr
            
        case "eqir": self = .eqir
        case "eqri": self = .eqri
        case "eqrr": self = .eqrr
            
        default: return nil
        }
    }
    
    case addr = 4
    case addi = 9
    
    case mulr = 11
    case muli = 13
    
    case banr = 8
    case bani = 15
    
    case borr = 1
    case bori = 12
    
    case setr = 10
    case seti = 5
    
    case gtir = 2
    case gtri = 7
    case gtrr = 0
    
    case eqir = 14
    case eqri = 3
    case eqrr = 6
}

struct OpcodeInstruction {
    var opcode: Opcode
    var a: Int
    var b: Int
    var c: Int
    
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

class OpcodeComputer {
    var instructionPointerIndex: Int? = nil
    var register: [Int] = [0, 0, 0, 0, 0, 0]
    
    func process(_ instructions: [OpcodeInstruction]) {
        if let ip = instructionPointerIndex {
            while true {
                let instruction = instructions[instructionIndex!]
                process(instruction)
                
                let nextIndex = instructionIndex! + 1
                guard nextIndex >= 0 && nextIndex < instructions.count else { break }
                register[ip] += 1
            }
        } else {
            for instruction in instructions {
                process(instruction)
            }
        }
    }
    
    var instructionIndex: Int? {
        guard let index = instructionPointerIndex else { return nil }
        return register[index]
    }
    
    func process(_ instruction: OpcodeInstruction) {
        register = instruction.apply(to: register)
    }
    
    func incrementInstructionPointerIfNeeded() {
        guard let index = instructionPointerIndex else { return }
        register[index] += 1
    }
}
