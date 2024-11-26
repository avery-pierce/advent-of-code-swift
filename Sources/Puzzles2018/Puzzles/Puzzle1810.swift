
import Foundation
import AdventOfCode

class Puzzle1810: Puzzle {
    let name: String = "2018_10"
    
    func solveA(_ input: Input) -> String {
        print("mapping")
        let movingPoints = input.lines.map(MovingPoint.init)
        
        let aroundSecond = findTimeWhenAreaIsSmallest(movingPoints)
        
        let lowerBound = aroundSecond - 10
        let upperBound = aroundSecond + 10
        
        for seconds in (lowerBound...upperBound) {
            let arrangedPoints = movingPoints.map({ $0.after(seconds: seconds) })
            print("rendering \(seconds)")
            
            let renderer = GridRenderer(arrangedPoints)
            print(renderer.render())
        }
        
        return ""
    }
    
    func findTimeWhenAreaIsSmallest(_ movingPoints: [MovingPoint]) -> Int {
        var lastSize = Int.max
        var seconds = 0
        repeat {
            let movedPoints = movingPoints.map({ $0.after(seconds: seconds) })
            let rect = GridRect.enclosing(movedPoints)
            if (rect.area > lastSize) {
                break
            }
            
            print("Change (\(seconds)s): \(rect.area - lastSize)")
            lastSize = rect.area
            seconds += 1
        } while true
        return seconds
    }
    
    var testCasesA: [TestCase] = [
        // Input test cases here
    ]
    
    func solveB(_ input: Input) -> String {
        return "unsolved"
    }
    
    var testCasesB: [TestCase] = [
        // Input test cases here
    ]
    
    struct MovingPoint {
        var startingCoordinate: GridCoordinate
        var vector: GridVector
        
        func after(seconds: Int) -> GridCoordinate {
            return startingCoordinate.moved(by: vector.multiplied(by: seconds))
        }
        
        init(descriptor: String) {
            //  "position=<-31761,  10798> velocity=< 3, -1>"
            let position = descriptor[descriptor.index(descriptor.startIndex, offsetBy: 10)..<descriptor.index(descriptor.startIndex, offsetBy: 24)]
            self.startingCoordinate = GridCoordinate(descriptor: String(position))
            
            let velocity = descriptor[descriptor.index(descriptor.startIndex, offsetBy: 36)..<descriptor.index(descriptor.startIndex, offsetBy: 42)]
            let proxyCoordinate = GridCoordinate(descriptor: String(velocity))
            self.vector = GridVector(dx: proxyCoordinate.x, dy: proxyCoordinate.y)
        }
    }
}
