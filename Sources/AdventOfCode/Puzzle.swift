//
//  File.swift
//  
//
//  Created by Avery Pierce on 11/14/20.
//
import Foundation

protocol Puzzle {
    var name: String { get }
    
    func solveA(_ input: Input) -> String
    var testCasesA: [TestCase] { get }

    func solveB(_ input: Input) -> String
    var testCasesB: [TestCase] { get }
}

extension Puzzle {
    var hasTests: Bool {
        return testCasesA.count + testCasesB.count > 0
    }
    
    var allTestsPass: Bool {
        let aPasses = testCasesA.allSatisfy { (test) -> Bool in
            return solveA(test.input) == test.expectedOutput
        }
        let bPasses = testCasesB.allSatisfy { (test) -> Bool in
            return solveB(test.input) == test.expectedOutput
        }
        
        return aPasses && bPasses
    }
}
