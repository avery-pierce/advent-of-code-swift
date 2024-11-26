//
//  File.swift
//  
//
//  Created by Avery Pierce on 11/14/20.
//
import Foundation

public protocol Puzzle {
    var name: String { get }
    
    func solveA(_ input: Input) -> String
    var testCasesA: [TestCase] { get }

    func solveB(_ input: Input) -> String
    var testCasesB: [TestCase] { get }
}

public extension Puzzle {
    var hasTests: Bool {
        return testCasesA.count + testCasesB.count > 0
    }
    
    var allATestsPass: Bool {
        return testCasesA.allSatisfy { (test) -> Bool in
            return solveA(test.input) == test.expectedOutput
        }
    }
    
    var allBTestsPass: Bool {
        return testCasesB.allSatisfy { (test) -> Bool in
            return solveB(test.input) == test.expectedOutput
        }
    }
    
    var allTestsPass: Bool {
        return allATestsPass && allBTestsPass
    }
}
