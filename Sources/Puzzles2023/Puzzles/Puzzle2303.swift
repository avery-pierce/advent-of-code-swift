
import Foundation
import AdventOfCode

class Puzzle2303: Puzzle {
    let name: String = "2023_03"
    
    func solveA(_ input: Input) -> String {
        let schematic = Schematic(input.grid)
        return String(schematic.sumOfPartNumbers)
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
"""), expectedOutput: "4361")
    ]
    
    func solveB(_ input: Input) -> String {
        let schematic = Schematic(input.grid)
        return String(schematic.sumGearRatios)
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("""
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
"""), expectedOutput: "467835")
    ]
    
    class Schematic {
        let contents: [GridCoordinate: Character]
        let grid: GridRect
        
        init(_ contents: [GridCoordinate: Character]) {
            self.contents = contents
            self.grid = .enclosing(Set(contents.keys))
        }
        
        var sumOfPartNumbers: Int {
            partNumbers.reduce(0, +)
        }
    
        var partNumbers: [Int] {
            partNumberLocations
                .map { frame in
                    return partNumber(at: frame.coordinates.first!)!
                }
        }
        
        var partNumberLocations: Set<GridRect> {
            numberLocations
                .filter { rect in
                    rect.coordinates.contains(where: { isAdjacentToSymbol(at: $0) })
                }
        }
        
        var numberLocations: Set<GridRect> {
            let frames = grid.coordinates.compactMap { partNumberFrame(at: $0) }
            return Set(frames)
        }
        
        func partNumberFrame(at coord: GridCoordinate) -> GridRect? {
            guard isNumber(at: coord) else {
                // This is not a part number
                return nil
            }
            
            var leftMax = coord
            while isNumber(at: leftMax) {
                leftMax.move(.left)
            }
            // We overshoot by one
            leftMax.move(.right)
            
            var rightMax = coord
            while isNumber(at: rightMax) {
                rightMax.move(.right)
            }
            // We overshoot by one
            rightMax.move(.left)
            
            return .enclosing([leftMax, rightMax])
        }
        
        func partNumber(at coord: GridCoordinate) -> Int? {
            guard let frame = partNumberFrame(at: coord) else { return nil }
            
            let string = (frame.minX...frame.maxX)
                .map({ GridCoordinate(x: $0, y: frame.minY) })
                .compactMap({ contents[$0] })
            
            return Int(String(string))
        }
        
        func isNumber(at coord: GridCoordinate) -> Bool {
            guard let char = contents[coord] else { return false }
            return Int(String(char)) != nil
        }
        
        func isSymbol(at coord: GridCoordinate) -> Bool {
            guard let char = contents[coord] else { return false }
            return char != "." && !isNumber(at: coord)
        }
        
        func isAdjacentToSymbol(at coord: GridCoordinate) -> Bool {
            return cellsAdjacent(to: coord).contains(where: { isSymbol(at: $0 )})
        }
        
        func cellsAdjacent(to coord: GridCoordinate) -> Set<GridCoordinate> {
            let adjacentDirections: [GridVector] = [
                .up + .left,
                .up,
                .up + .right,
                .right,
                .down + .right,
                .down,
                .down + .left,
                .left,
            ]
            
            let adjacentCells = adjacentDirections.map({ coord.moved(by: $0) })
            return Set(adjacentCells)
        }
        
        var sumGearRatios: Int {
            return gearRatios.reduce(0, +)
        }
        
        var gearRatios: [Int] {
            allAsterisks
                .compactMap { coord -> Int? in
                    // A gear has exactly 2 adjacent part numbers
                    let adjacentFrames = cellsAdjacent(to: coord)
                        .compactMap({ partNumberFrame(at: $0) })
                    
                    let dedupe = Set(adjacentFrames)
                    guard dedupe.count == 2 else { return nil }
                    
                    let numbers = dedupe.map({ partNumber(at: $0.coordinates.first!)! })
                    return numbers[0] * numbers[1]
                }
        }
        
        var allAsterisks: Set<GridCoordinate> {
            var coords = Set<GridCoordinate>()
            for (coord, char) in contents {
                if char == Character("*") {
                    coords.insert(coord)
                }
            }
            return coords
        }
    }
}
