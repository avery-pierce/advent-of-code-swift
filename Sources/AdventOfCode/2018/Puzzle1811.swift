
import Foundation

class Puzzle1811: Puzzle {
    let name: String = "2018_11"
    
    func solveA(_ input: Input) -> String {
        let gridSerialNumber = Int(input.text)!
        let powerGrid = buildPowerGrid(serialNumber: gridSerialNumber)
        let highestPower = maxPowerLevel(forSquareSize: 3, in: powerGrid)
        return "\(highestPower.0): \(highestPower.1)"
    }
    
    var testCasesA: [TestCase] = [
        // Input test cases here
    ]
    
    func solveB(_ input: Input) -> String {
        let gridSerialNumber = Int(input.text)!
        let powerGrid = buildPowerGrid(serialNumber: gridSerialNumber)
        let maxPerSize = (1...300).map { (gridSize) -> (GridCoordinate, size: Int, powerLevel: Int) in
            print("Computing grid size \(gridSize)...")
            let highestPowerLevel = maxPowerLevel(forSquareSize: gridSize, in: powerGrid)
            print("max: \(highestPowerLevel.0): \(highestPowerLevel.1)")
            return (highestPowerLevel.0, size: gridSize, powerLevel: highestPowerLevel.1)
        }
        
        let overallMax = maxPerSize.max(by: { $0.2 < $1.2 })!
        return "\(overallMax)"
    }
    
    var testCasesB: [TestCase] = [
        // Input test cases here
    ]
    
    let grid = GridRect(x1: 1, y1: 1, x2: 300, y2: 300)
    
    func computeFuelLevel(at coordinate: GridCoordinate, serialNumber: Int) -> Int {
        let rackID = coordinate.x + 10
        var powerLevel = rackID * coordinate.y
        powerLevel += serialNumber
        powerLevel = powerLevel * rackID
        powerLevel = hundredsDigit(of: powerLevel)
        powerLevel -= 5
        return powerLevel
    }
    
    func hundredsDigit(of number: Int) -> Int {
        if number < 100 { return 0 }
        let stringified = String(String(number).reversed())
        let hundredsChar = String(stringified.characters[2])
        return Int(hundredsChar)!
    }
    
    func buildPowerGrid(serialNumber: Int) -> [GridCoordinate: Int] {
        var powerLevels: [GridCoordinate: Int] = [:]
        
        for coord in grid.coordinates {
            let fuel = computeFuelLevel(at: coord, serialNumber: serialNumber)
            powerLevels[coord] = fuel
        }
        
        return powerLevels
    }
    
    func maxPowerLevel(forSquareSize squareSize: Int, in powerLevels: [GridCoordinate: Int]) -> (GridCoordinate, Int) {
        let powers = grid.coordinates.compactMap { coord -> (GridCoordinate, Int)? in
            let region = GridRect(coord, GridSize(width: squareSize, height: squareSize))
            if (region.maxX > 300 || region.maxY > 300) { return nil }
            let combinedPowerLevel = region.coordinates.reduce(0) { (prevResult, nextCoord) -> Int in
                let powerLevel = powerLevels[nextCoord] ?? -1000
                return prevResult + powerLevel
            }
            return (coord, combinedPowerLevel)
        }
        
        let highestPower = powers.max(by: { $0.1 < $1.1 })!
        return highestPower
    }
    
    func maxPowerLevel(forSquareSize squareSize: Int, serialNumber: Int) -> (GridCoordinate, Int) {
        var powerLevels: [GridCoordinate: Int] = [:]
        
        for coord in grid.coordinates {
            let fuel = computeFuelLevel(at: coord, serialNumber: serialNumber)
            powerLevels[coord] = fuel
        }
        
        return maxPowerLevel(forSquareSize: squareSize, in: powerLevels)
    }
}

extension String {
    var characters: [Character] {
        let length = self.count
        return (0..<length).map { (offset) -> Character in
            let index = self.index(self.startIndex, offsetBy: offset)
            return self[index]
        }
    }
}
