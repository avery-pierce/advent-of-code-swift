//
//  File.swift
//  
//
//  Created by Avery Pierce on 11/18/20.
//

import Foundation

public class GridRenderer {
    public let coordinates: [GridCoordinate]
    public var rect: GridRect?
    public init(_ coordinates: [GridCoordinate], in rect: GridRect? = nil) {
        self.coordinates = coordinates
        self.rect = rect
    }
    
    public var emptyCellChar = Character(" ")
    public var filledCellChar = Character("#")
    
    public func render() -> String {
        let grid = rect ?? GridRect.enclosing(coordinates)
        
        print("grid complete: width: \(grid.size.width), \(grid.size.height)")
        
        let rows = (grid.minY...grid.maxY).map { (y) -> String in
            let chars = (grid.minX...grid.maxX).map { (x) -> Character in
                if coordinates.contains(GridCoordinate(x: x, y: y)) {
                    return filledCellChar
                } else {
                    return emptyCellChar
                }
            }
            return String(chars)
        }
        return rows.joined(separator: "\n")
    }
}
