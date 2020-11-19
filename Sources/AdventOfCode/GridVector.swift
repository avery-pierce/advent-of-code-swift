//
//  File.swift
//  
//
//  Created by Avery Pierce on 11/18/20.
//

import Foundation

struct GridVector {
    var dx: Int
    var dy: Int
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
