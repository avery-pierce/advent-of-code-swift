//
//  File.swift
//  
//
//  Created by Avery Pierce on 11/15/20.
//

import Foundation

struct GridCoordinate: Hashable, Equatable {
    var x: Int
    var y: Int
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

extension GridCoordinate {
    
    /// Creates a coodinate in the form `x, y`
    init(descriptor: String) {
        let coords = descriptor.split(separator: ",").map({ $0.trimmingCharacters(in: .whitespacesAndNewlines )})
        self.x = Int(coords[0])!
        self.y = Int(coords[1])!
    }
}

extension GridCoordinate {
    
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

extension GridCoordinate {
    func manhattanDistance(to coordinate: GridCoordinate) -> Int {
        let dx = abs(coordinate.x - self.x)
        let dy = abs(coordinate.y - self.y)
        return dx + dy
    }
}

extension GridCoordinate {
    static var zero = GridCoordinate(x: 0, y: 0)
}

extension GridCoordinate {
    // A sort function
    static func inReadingOrder(_ lhs: GridCoordinate, _ rhs: GridCoordinate) -> Bool {
        if lhs.y == rhs.y {
            return lhs.x < rhs.x
        } else {
            return lhs.y < rhs.y
        }
    }
}

extension Array where Element == String {
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
