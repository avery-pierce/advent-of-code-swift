
import Foundation
import AdventOfCode

class Puzzle2003: Puzzle {
    let name: String = "2020_03"
    
    func solveA(_ input: Input) -> String {
        let trees = parse(input)
        let scanner = Scanner(trees: trees)
        let slope = GridVector(dx: 3, dy: 1)
        let result = scanner.count(forSlope: slope)
        return "\(result)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    ..##.......
                    #...#...#..
                    .#....#..#.
                    ..#.#...#.#
                    .#...##..#.
                    ..#.##.....
                    .#.#.#....#
                    .#........#
                    #.##...#...
                    #...##....#
                    .#..#...#.#
                    """), expectedOutput: "7")
    ]
    
    func solveB(_ input: Input) -> String {
        let trees = parse(input)
        let scanner = Scanner(trees: trees)
        let slopes = [
            GridVector(dx: 1, dy: 1),
            GridVector(dx: 3, dy: 1),
            GridVector(dx: 5, dy: 1),
            GridVector(dx: 7, dy: 1),
            GridVector(dx: 1, dy: 2),
        ]
        let crashes = slopes.map { (slope) -> Int in
            return scanner.count(forSlope: slope)
        }
        let result = crashes.reduce(1, *)
        return "\(result)"
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("""
                    ..##.......
                    #...#...#..
                    .#....#..#.
                    ..#.#...#.#
                    .#...##..#.
                    ..#.##.....
                    .#.#.#....#
                    .#........#
                    #.##...#...
                    #...##....#
                    .#..#...#.#
                    """), expectedOutput: "336")
    ]
    
    class Scanner {
        var start = GridCoordinate.zero
        var trees: Set<GridCoordinate>
        lazy var boundingBox: GridRect = {
            var grid = GridRect.enclosing(trees)
            grid.size.width += 1
            grid.size.height += 1
            return grid
        }()
        
        init(start: GridCoordinate = .zero, trees: Set<GridCoordinate>) {
            self.start = start
            self.trees = trees
        }
        
        func count(forSlope slope: GridVector) -> Int {
            let intersected = intersectedCoords(forSlope: slope)
            return intersected.filter(treeExists(at:)).count
        }
        
        func intersectedCoords(forSlope slope: GridVector) -> Set<GridCoordinate> {
            var intersected = Set<GridCoordinate>()
            var nextCoordinate = GridCoordinate.zero
            while nextCoordinate.y <= boundingBox.height {
                intersected.insert(nextCoordinate)
                nextCoordinate = nextCoordinate.moved(by: slope)
            }
            return intersected
        }
        
        func treeExists(at coordinate: GridCoordinate) -> Bool {
            let checkCoord = normalize(coordinate)
            return trees.contains(checkCoord)
        }
        
        func normalize(_ coordinate: GridCoordinate) -> GridCoordinate {
            let x = coordinate.x % boundingBox.width
            let checkCoord = GridCoordinate(x: x, y: coordinate.y)
            return checkCoord
        }
    }
    
    func parse(_ input: Input) -> Set<GridCoordinate> {
        var trees = Set<GridCoordinate>()
        for (y, line) in input.lines.enumerated() {
            for (x, char) in line.enumerated() {
                if char == "#" {
                    let coord = GridCoordinate(x: x, y: y)
                    trees.insert(coord)
                }
            }
        }
        
        return trees
    }
}
