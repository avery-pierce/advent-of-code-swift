//
//  File.swift
//  
//
//  Created by Avery Pierce on 11/25/20.
//

import Foundation

enum Opcode: Int, CaseIterable {
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
    var register: [Int] = [0, 0, 0, 0, 0, 0]
    
    func process(_ instructions: [OpcodeInstruction]) {
        register = instructions.reduce(register, opcodeReducer(previousRegister:nextInstruction:))
    }
    
    func opcodeReducer(previousRegister: [Int], nextInstruction: OpcodeInstruction) -> [Int] {
        return nextInstruction.apply(to: previousRegister)
    }
}
