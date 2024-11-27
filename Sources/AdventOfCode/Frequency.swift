//
//  File.swift
//  
//
//  Created by Avery Pierce on 11/14/20.
//

import Foundation

public struct Frequency<T: Hashable> {
    private var counts = [T: Int]()
    
    public init() {}
    
    public init<S: Sequence>(_ sequence: S) where S.Element == T {
        for element in sequence {
            increment(element)
        }
    }
    
    public subscript(_ value: T) -> Int {
        get {
            return counts[value] ?? 0
        }
        set {
            counts[value] = newValue
        }
    }
    
    public mutating func increment(_ value: T) {
        self[value] += 1
    }
    
    public mutating func decrement(_ value: T) {
        self[value] = max(self[value] - 1, 0)
    }
    
    public var uniqueValues: Set<T> {
        return Set(counts.keys)
    }
    
    public var values: [T] {
        var vals = [T]()
        for (value, count) in counts {
            for _ in 1...count {
                vals.append(value)
            }
        }
        return vals
    }
    
    public func values(where predicate: (Int) -> Bool) -> Set<T> {
        return Set(counts.filter({ return predicate($0.value) }).keys)
    }
    
    public var mostFrequent: T? {
        return counts.max { (left, right) -> Bool in
            return left.value < right.value
        }?.key
    }
    
    public var total: Int {
        return counts.values.reduce(0, +)
    }
}

public extension Frequency {
    mutating func increment<C: Collection>(membersOf collection: C) where C.Element == T {
        for member in collection {
            increment(member)
        }
    }
    
    mutating func decrement<C: Collection>(membersOf collection: C) where C.Element == T {
        for member in collection {
            decrement(member)
        }
    }
}

public extension Frequency {
    static func + (left: Frequency<T>, right: Frequency<T>) -> Frequency<T> {
        var result = Frequency<T>()
        
        for (key, count) in left.counts {
            result[key] += count
        }
        
        for (key, count) in right.counts {
            result[key] += count
        }
        
        return result
    }
    
    static func * (left: Frequency<T>, right: Int) -> Frequency<T> {
        var result = Frequency<T>()
        
        for (key, count) in left.counts {
            result[key] = count * right
        }
        
        return result
    }
    
}
