//
//  File.swift
//  
//
//  Created by Avery Pierce on 11/14/20.
//

import Foundation

struct Frequency<T: Hashable> {
    private var counts = [T: Int]()
    
    init() {}
    
    init<S: Sequence>(_ sequence: S) where S.Element == T {
        for element in sequence {
            increment(element)
        }
    }
    
    subscript(_ value: T) -> Int {
        get {
            return counts[value] ?? 0
        }
        set {
            counts[value] = newValue
        }
    }
    
    mutating func increment(_ value: T) {
        self[value] += 1
    }
    
    mutating func decrement(_ value: T) {
        self[value] = max(self[value] - 1, 0)
    }
    
    var uniqueValues: Set<T> {
        return Set(counts.keys)
    }
    
    var values: [T] {
        var vals = [T]()
        for (value, count) in counts {
            for _ in 1...count {
                vals.append(value)
            }
        }
        return vals
    }
    
    func values(where predicate: (Int) -> Bool) -> Set<T> {
        return Set(counts.filter({ return predicate($0.value) }).keys)
    }
    
    var mostFrequent: T? {
        return counts.max { (left, right) -> Bool in
            return left.value < right.value
        }?.key
    }
}
