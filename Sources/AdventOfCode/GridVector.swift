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

extension GridVector {
    func quarterTurnedLeft() -> GridVector {
        // Reminder: The grid is upside down.
        // North is -1, and South is +1
        var newVector = self
        newVector.dx = dy
        newVector.dy = dx * -1
        return newVector
    }
    
    mutating func quarterTurnLeft() {
        self = quarterTurnedLeft()
    }
    
    func quarterTurnedRight() -> GridVector {
        // Reminder: The grid is upside down.
        // North is -1, and South is +1
        var newVector = self
        newVector.dx = dy * -1
        newVector.dy = dx
        return newVector
    }
    
    mutating func quarterTurnRight() {
        self = quarterTurnedRight()
    }
}

extension GridCoordinate {
    func moved(_ vector: GridVector) -> GridCoordinate {
        var newCoord = self
        newCoord.x += vector.dx
        newCoord.y += vector.dy
        return newCoord
    }
    
    func moved(by vector: GridVector) -> GridCoordinate {
        return moved(vector)
    }
    
    mutating func move(_ vector: GridVector) {
        self = moved(by: vector)
    }
}

extension GridVector {
    static func + (left: GridVector, right: GridVector) -> GridVector {
        return GridVector(dx: left.dx + right.dx, dy: left.dy + right.dy)
    }
    
    static func += (left: inout GridVector, right: GridVector) {
        left = left + right
    }
    
    static func * (left: GridVector, right: Int) -> GridVector {
        return left.multiplied(by: right)
    }
    
    static func *= (left: inout GridVector, right: Int) {
        left = left * right
    }
}
