//
//  File.swift
//  
//
//  Created by Avery Pierce on 11/15/20.
//

import Foundation

public struct GridCoordinate: Hashable, Equatable {
    public var x: Int
    public var y: Int
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

public extension GridCoordinate {
    
    /// Creates a coodinate in the form `x, y`
    init(descriptor: String) {
        let coords = descriptor.split(separator: ",").map({ $0.trimmingCharacters(in: .whitespacesAndNewlines )})
        self.x = Int(coords[0])!
        self.y = Int(coords[1])!
    }
}

public extension GridCoordinate {
    
    /// alias to `y`
    var top: Int {
        get { y }
        set { y = newValue }
    }
    
    /// alias to `x`
    var left: Int {
        get { x }
        set { x = newValue }
    }
    
    init(left: Int, top: Int) {
        self.init(x: left, y: top)
    }
}

public extension GridCoordinate {
    func manhattanDistance(to coordinate: GridCoordinate) -> Int {
        let dx = abs(coordinate.x - self.x)
        let dy = abs(coordinate.y - self.y)
        return dx + dy
    }
}

public extension GridCoordinate {
    static var zero = GridCoordinate(x: 0, y: 0)
}

public extension GridCoordinate {
    // A sort function
    static func inReadingOrder(_ lhs: GridCoordinate, _ rhs: GridCoordinate) -> Bool {
        if lhs.y == rhs.y {
            return lhs.x < rhs.x
        } else {
            return lhs.y < rhs.y
        }
    }
}

public extension Array where Element == String {
    var characterGrid: [GridCoordinate: Character] {
        var result = [GridCoordinate: Character]()
        for (y, line) in self.enumerated() {
            for (x, character) in line.enumerated() {
                let coord = GridCoordinate(x: x, y: y)
                result[coord] = character
            }
        }
        return result
    }
}
