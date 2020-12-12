//
//  File.swift
//  
//
//  Created by Avery Pierce on 11/18/20.
//

import Foundation

struct GridVector: Equatable, Hashable {
    var dx: Int
    var dy: Int
}

extension GridVector {
    static let north = GridVector(dx: 0, dy: -1)
    static let south = GridVector(dx: 0, dy: 1)
    static let east = GridVector(dx: 1, dy: 0)
    static let west = GridVector(dx: -1, dy: 0)
    
    static let up = north
    static let down = south
    static let left = west
    static let right = east
}

extension GridVector {
    func multiplied(by factor: Int) -> GridVector {
        var newVector = self
        newVector.dx = self.dx * factor
        newVector.dy = self.dy * factor
        return newVector
    }
}

extension GridCoordinate {
    func moved(by vector: GridVector) -> GridCoordinate {
        var newCoord = self
        newCoord.x += vector.dx
        newCoord.y += vector.dy
        return newCoord
    }
}

extension GridVector {
    static func + (left: GridVector, right: GridVector) -> GridVector {
        return GridVector(dx: left.dx + right.dx, dy: left.dy + right.dy)
    }
}
