
import Foundation
import AdventOfCode

class Puzzle2020: Puzzle {
    let name: String = "2020_20"
    
    func solveA(_ input: Input) -> String {
        return ""
        let tiles = input.sections.map(Tile.init)
        let image = alignTiles(tiles)
        
        let tileCoordsX = image.keys.map(\.x)
        let minX = tileCoordsX.min()!
        let maxX = tileCoordsX.max()!
        
        let tileCoordsY = image.keys.map(\.y)
        let minY = tileCoordsY.min()!
        let maxY = tileCoordsY.max()!
        
        let corners = [
            GridCoordinate(x: minX, y: minY),
            GridCoordinate(x: minX, y: maxY),
            GridCoordinate(x: maxX, y: minY),
            GridCoordinate(x: maxX, y: maxY),
        ]
        
        let cornerIDs = corners.map({ image[$0]!.tile.id })
        let product = cornerIDs.reduce(1, *)
        
        return "\(product)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    Tile 2311:
                    ..##.#..#.
                    ##..#.....
                    #...##..#.
                    ####.#...#
                    ##.##.###.
                    ##...#.###
                    .#.#.#..##
                    ..#....#..
                    ###...#.#.
                    ..###..###
                    
                    Tile 1951:
                    #.##...##.
                    #.####...#
                    .....#..##
                    #...######
                    .##.#....#
                    .###.#####
                    ###.##.##.
                    .###....#.
                    ..#.#..#.#
                    #...##.#..
                    
                    Tile 1171:
                    ####...##.
                    #..##.#..#
                    ##.#..#.#.
                    .###.####.
                    ..###.####
                    .##....##.
                    .#...####.
                    #.##.####.
                    ####..#...
                    .....##...
                    
                    Tile 1427:
                    ###.##.#..
                    .#..#.##..
                    .#.##.#..#
                    #.#.#.##.#
                    ....#...##
                    ...##..##.
                    ...#.#####
                    .#.####.#.
                    ..#..###.#
                    ..##.#..#.
                    
                    Tile 1489:
                    ##.#.#....
                    ..##...#..
                    .##..##...
                    ..#...#...
                    #####...#.
                    #..#.#.#.#
                    ...#.#.#..
                    ##.#...##.
                    ..##.##.##
                    ###.##.#..
                    
                    Tile 2473:
                    #....####.
                    #..#.##...
                    #.##..#...
                    ######.#.#
                    .#...#.#.#
                    .#########
                    .###.#..#.
                    ########.#
                    ##...##.#.
                    ..###.#.#.
                    
                    Tile 2971:
                    ..#.#....#
                    #...###...
                    #.#.###...
                    ##.##..#..
                    .#####..##
                    .#..####.#
                    #..#.#..#.
                    ..####.###
                    ..#.#.###.
                    ...#.#.#.#
                    
                    Tile 2729:
                    ...#.#.#.#
                    ####.#....
                    ..#.#.....
                    ....#..#.#
                    .##..##.#.
                    .#.####...
                    ####.#.#..
                    ##.####...
                    ##..#.##..
                    #.##...##.
                    
                    Tile 3079:
                    #.#.#####.
                    .#..######
                    ..#.......
                    ######....
                    ####.#..#.
                    .#...#.##.
                    #.#####.##
                    ..#.###...
                    ..#.......
                    ..#.###...
                    """), expectedOutput: "20899048083289")
    ]
    
    func solveB(_ input: Input) -> String {
//        print(seaMonsterText)
//        print(seaMonster)

        let tiles = input.sections.map(Tile.init)
        let tiledImage = alignTiles(tiles)
        let image = Image(tiledImage)
        let size = image.stichedImage.map(\.x).max()! - image.stichedImage.map(\.x).min()!
        let rendered = GridRect.enclosing(image.stichedImage).render({ image.stichedImage.contains($0) ? "#" : "." })
        
        print("size: \(size)")
        print(rendered)
        
        let allImageTransformations = Transformation.allTransformations.map({ transformations in
            return transformations.reduce(image.stichedImage, { $1.applied(to: $0, size: size) })
        })
        
        for opt in allImageTransformations {
            let allMonsters = seaMonters(in: opt)
            print("Sea Monsters detected: \(allMonsters.count)")
            if (allMonsters.count == 0) { continue }
            
            let coveredSquares = seaMonster.count * allMonsters.count
            let sea = image.stichedImage.count - coveredSquares
            return "\(sea)"
        }
        
        return "unsolved"
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("""
                    Tile 2311:
                    ..##.#..#.
                    ##..#.....
                    #...##..#.
                    ####.#...#
                    ##.##.###.
                    ##...#.###
                    .#.#.#..##
                    ..#....#..
                    ###...#.#.
                    ..###..###
                    
                    Tile 1951:
                    #.##...##.
                    #.####...#
                    .....#..##
                    #...######
                    .##.#....#
                    .###.#####
                    ###.##.##.
                    .###....#.
                    ..#.#..#.#
                    #...##.#..
                    
                    Tile 1171:
                    ####...##.
                    #..##.#..#
                    ##.#..#.#.
                    .###.####.
                    ..###.####
                    .##....##.
                    .#...####.
                    #.##.####.
                    ####..#...
                    .....##...
                    
                    Tile 1427:
                    ###.##.#..
                    .#..#.##..
                    .#.##.#..#
                    #.#.#.##.#
                    ....#...##
                    ...##..##.
                    ...#.#####
                    .#.####.#.
                    ..#..###.#
                    ..##.#..#.
                    
                    Tile 1489:
                    ##.#.#....
                    ..##...#..
                    .##..##...
                    ..#...#...
                    #####...#.
                    #..#.#.#.#
                    ...#.#.#..
                    ##.#...##.
                    ..##.##.##
                    ###.##.#..
                    
                    Tile 2473:
                    #....####.
                    #..#.##...
                    #.##..#...
                    ######.#.#
                    .#...#.#.#
                    .#########
                    .###.#..#.
                    ########.#
                    ##...##.#.
                    ..###.#.#.
                    
                    Tile 2971:
                    ..#.#....#
                    #...###...
                    #.#.###...
                    ##.##..#..
                    .#####..##
                    .#..####.#
                    #..#.#..#.
                    ..####.###
                    ..#.#.###.
                    ...#.#.#.#
                    
                    Tile 2729:
                    ...#.#.#.#
                    ####.#....
                    ..#.#.....
                    ....#..#.#
                    .##..##.#.
                    .#.####...
                    ####.#.#..
                    ##.####...
                    ##..#.##..
                    #.##...##.
                    
                    Tile 3079:
                    #.#.#####.
                    .#..######
                    ..#.......
                    ######....
                    ####.#..#.
                    .#...#.##.
                    #.#####.##
                    ..#.###...
                    ..#.......
                    ..#.###...
                    """), expectedOutput: "273")
    ]
    
    struct Tile: Hashable, Equatable {
        var id: Int
        var activePixels: Set<GridCoordinate>
        
        init(_ group: [String]) {
            self.id = Int(regexParse("^Tile (\\d+):$")(group[0])![0])!
            
            var pixels = Set<GridCoordinate>()
            Array(group[1...]).characterGrid.forEach { (key, char) in
                if char == "#" {
                    pixels.insert(key)
                }
            }
            self.activePixels = pixels
        }
        
        func applying(_ transformations: [Transformation]) -> TransformedTile {
            return TransformedTile(self, transformations: transformations)
        }
        
        func allTransformations() -> Set<TransformedTile> {
            return Set(Transformation.allTransformations.map(self.applying(_:)))
        }
    }
    
    enum Transformation {
        case flipHorizontally
        case rotate90
        
        var description: String {
            switch self {
            case .flipHorizontally: return "flip-H"
            case .rotate90: return "rot"
            }
        }
        
        static let allTransformations: [[Transformation]] = [
            [],
            [.rotate90],
            [.rotate90, .rotate90],
            [.rotate90, .rotate90, .rotate90],
            [.flipHorizontally],
            [.flipHorizontally, .rotate90],
            [.flipHorizontally, .rotate90, .rotate90],
            [.flipHorizontally, .rotate90, .rotate90, .rotate90],
        ]
        
        func applied(to pixels: Set<GridCoordinate>, size: Int = 10) -> Set<GridCoordinate> {
            switch self {
            case .flipHorizontally:
                return Set(pixels.map({ GridCoordinate(x: ($0.x * -1) + (size - 1), y: $0.y) }))
                
            case .rotate90:
                return Set(pixels.map({ (coord) -> GridCoordinate in
                    var newCoord = coord
                    newCoord.x = (coord.y * -1) + (size - 1)
                    newCoord.y = coord.x
                    return newCoord
                }))
            }
        }
    }
    
    struct TransformedTile: Hashable {
        var tile: Tile
        var transformations: [Transformation]
        
        init(_ tile: Tile, transformations: [Transformation]) {
            self.tile = tile
            self.transformations = transformations
        }
        
        var activePixels: Set<GridCoordinate> {
            return transformations.reduce(tile.activePixels, { $1.applied(to: $0) })
        }
    }
    
    enum Edge {
        case top
        case left
        case right
        case bottom
        
        func of(_ transformedTile: TransformedTile) -> [Bool] {
            return of(transformedTile.activePixels)
        }
        
        func of(_ tile: Tile) -> [Bool] {
            return of(tile.activePixels)
        }
        
        func of(_ pixels: Set<GridCoordinate>) -> [Bool] {
            coords.map(pixels.contains)
        }
        
        var coords: [GridCoordinate] {
            switch self {
            case .top:
                return (0..<10).map({ GridCoordinate(x: $0, y: 0)})
            case .bottom:
                return (0..<10).map({ GridCoordinate(x: $0, y: 9)})
            case .left:
                return (0..<10).map({ GridCoordinate(x: 0, y: $0)})
            case .right:
                return (0..<10).map({ GridCoordinate(x: 9, y: $0)})
            }
        }
    }
    
    func alignTiles(_ tiles: [Tile]) -> [GridCoordinate: TransformedTile] {
        let builder = ImageBuilder(tiles)
        builder.build()
        return builder.image
    }
    
    class ImageBuilder {
        var image = [GridCoordinate: TransformedTile]()
        var tiles: [Tile]
        
        init(_ tiles: [Tile]) {
            self.tiles = tiles
        }
        
        func build() {
            guard tiles.count > 0 else { return }
            
            let firstTile = tiles.remove(at: 0)
            image[.zero] = TransformedTile(firstTile, transformations: [])
            
            while !tiles.isEmpty {
                for coord in image.keys {
                    for neighbor in coordinates(adjacentTo: coord) {
                        guard image[neighbor] == nil else { continue }
                        
                        let possibilites = candidates(for: neighbor)
                        if possibilites.count == 1 {
                            let transformedTile = possibilites[0]
                            image[neighbor] = transformedTile
                            
                            let index = tiles.firstIndex(of: transformedTile.tile)!
                            tiles.remove(at: index)
                        }
                    }
                }
            }
        }
        
        func candidates(for coord: GridCoordinate) -> [TransformedTile] {
            // Start with all transformations of every tile
            var allCandidates = tiles.flatMap({ $0.allTransformations() })
            
            // Test each direction, and filter out any tiles that don't fit
            if let tileBelow = image[coord.moved(.down)] {
                let topEdge = Edge.top.of(tileBelow)
                allCandidates = allCandidates.filter({ Edge.bottom.of($0) == topEdge })
            }
            
            if let tileToTheLeft = image[coord.moved(.left)] {
                let rightEdge = Edge.right.of(tileToTheLeft)
                allCandidates = allCandidates.filter({ Edge.left.of($0) == rightEdge })
            }
            
            if let tileToTheRight = image[coord.moved(.right)] {
                let leftEdge = Edge.left.of(tileToTheRight)
                allCandidates = allCandidates.filter({ Edge.right.of($0) == leftEdge })
            }
            
            if let tileAbove = image[coord.moved(.up)] {
                let bottomEdge = Edge.bottom.of(tileAbove)
                allCandidates = allCandidates.filter({ Edge.top.of($0) == bottomEdge })
            }
            
            return allCandidates
        }
        
        func coordinates(adjacentTo coord: GridCoordinate) -> Set<GridCoordinate> {
            let directions: [GridVector] = [.up, .left, .right, .down]
            return Set(directions.map(coord.moved(_:)))
        }
    }
    
    class Image {
        let source: [GridCoordinate: TransformedTile]
        init(_ source: [GridCoordinate: TransformedTile]) {
            self.source = source
        }
        
        lazy var stichedImage: Set<GridCoordinate> = {
            let trimmedTiles = source.mapValues { (transformedTile) -> Set<GridCoordinate> in
                let keptPixels = transformedTile.activePixels.filter({ (1..<9).contains($0.x) && (1..<9).contains($0.y) })
                let offsetPixels = keptPixels.map({ $0.moved(.up + .left)})
                return Set(offsetPixels)
            }
            
            let wholeImage = trimmedTiles.flatMap({ (tileCoord, pixels) -> [GridCoordinate] in
                let offset: GridVector = (.down * tileCoord.y * 8) + (.right * tileCoord.x * 8)
                print("offset", offset)
                return pixels.map({ $0.moved(offset) })
            })
            
            let minX = wholeImage.map(\.x).min()!
            let minY = wholeImage.map(\.y).min()!
            
            let dx = minX * -1
            let dy = minY * -1
            let offset = GridVector(dx: dx, dy: dy)
            
            return Set(wholeImage.map({ $0.moved(offset) }))
        }()
    }
    
    // Returns a set of coordinates where a sea monter is in this image.
    func seaMonters(in image: Set<GridCoordinate>) -> Set<GridCoordinate> {
        let frame = GridRect.enclosing(image)
        let matches = frame.coordinates.filter({ isSeaMonster(in: image, at: $0) })
        return Set(matches)
    }
    
    func isSeaMonster(in image: Set<GridCoordinate>, at coord: GridCoordinate) -> Bool {
        let offset = GridVector(dx: coord.x, dy: coord.y)
        let offsetSeaMonster = seaMonster.map({ $0.moved(offset) })
        return offsetSeaMonster.allSatisfy(image.contains)
    }
}

extension Bool {
    var emojify: Character {
        return self ? "✅" : "❌"
    }
}

let seaMonsterText = """
                  #
#    ##    ##    ###
 #  #  #  #  #  #
"""
let seaMonster = seaMonsterText.split(separator: "\n").map(String.init).characterGrid.compactMap { (coord, char) -> GridCoordinate? in
    if (char == "#") { return coord }
    else { return nil }
}
