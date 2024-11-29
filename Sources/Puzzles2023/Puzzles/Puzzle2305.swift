
import Foundation
import AdventOfCode

class Puzzle2305: Puzzle {
    let name: String = "2023_05"
    
    static let testInput = TextInput("""
        seeds: 79 14 55 13

        seed-to-soil map:
        50 98 2
        52 50 48

        soil-to-fertilizer map:
        0 15 37
        37 52 2
        39 0 15

        fertilizer-to-water map:
        49 53 8
        0 11 42
        42 0 7
        57 7 4

        water-to-light map:
        88 18 7
        18 25 70

        light-to-temperature map:
        45 77 23
        81 45 19
        68 64 13

        temperature-to-humidity map:
        0 69 1
        1 0 69

        humidity-to-location map:
        60 56 37
        56 93 4
        """)
    
    func solveA(_ input: Input) -> String {
        
        let almanac = Almanac(input: input)
        return String(almanac.lowestLocationNumber)
    }
    
    var testCasesA: [TestCase] = [
        TestCase(Puzzle2305.testInput, expectedOutput: "35")
    ]
    
    func solveB(_ input: Input) -> String {
        let almanac = Almanac(input: input)
        return String(almanac.solveByBoundaries)
    }
    
    var testCasesB: [TestCase] = [
        TestCase(Puzzle2305.testInput, expectedOutput: "46")
    ]
    
    struct Almanac {
        struct Map {
            struct Row {
                var destinationRangeStart: Int
                var destinationRangeEnd: Int { destinationRangeStart + rangeLength }
                var sourceRangeStart: Int
                var sourceRangeEnd: Int { sourceRangeStart + rangeLength }
                var rangeLength: Int
                
                init(descriptor: String) {
                    let numbers = descriptor.split(separator: " ")
                        .map(String.init)
                        .compactMap(Int.init)
                    
                    destinationRangeStart = numbers[0]
                    sourceRangeStart = numbers[1]
                    rangeLength = numbers[2]
                }
                
                var sourceRange: Range<Int> {
                    return (sourceRangeStart..<sourceRangeEnd)
                }
                
                var destinationRange: Range<Int> {
                    return (destinationRangeStart..<destinationRangeEnd)
                }
                
                func lookup(_ source: Int) -> Int? {
                    guard source >= sourceRangeStart else {
                        // This source is not covered by this row
                        return nil
                    }
                    
                    let offset = source - sourceRangeStart
                    guard offset < rangeLength else {
                        // This source is not covered by this row
                        return nil
                    }
                    
                    return destinationRangeStart + offset
                }
                
                func reverseLookup(_ target: Int) -> Int? {
                    guard target >= destinationRangeStart else {
                        return nil
                    }
                    
                    let offset = target - destinationRangeStart
                    guard offset < rangeLength else {
                        // This source is not covered by this row
                        return nil
                    }
                    
                    return sourceRangeStart + offset
                }
            }
            
            var name: String
            var rows: [Row]
            
            init(descriptor: [String]) {
                name = descriptor[0]
                rows = descriptor[1..<descriptor.count]
                    .map(Row.init(descriptor:))
            }
            
            func lookup(_ source: Int) -> Int {
                for row in rows {
                    if let result = row.lookup(source) {
                        return result
                    }
                }
                
                return source
            }
            
            var rowBoundaries: [Int] {
                rows.map(\.sourceRangeStart)
                + rows.flatMap({ [$0.sourceRangeEnd, $0.sourceRangeEnd + 1] })
                + [0, Int.max]
                + rows.map(\.destinationRangeStart)
                + rows.map(\.destinationRangeEnd)
            }
            
            func reverseLookup(_ target: Int) -> [Int] {
                let matches = rows.compactMap({ $0.reverseLookup(target) })
                if matches.isEmpty {
                    return [target]
                } else {
                    return matches
                }
            }
            
            var rowsSortedBySmallestDestination: [Row] {
                rows.sorted(by: { lhs, rhs in
                    return lhs.destinationRangeStart < rhs.destinationRangeStart
                })
            }
            
            func sourceRanges(thatIntersectDestinationRange targetRange: Range<Int>) -> [Range<Int>] {
                let overlappingDestinationRanges = rowsSortedBySmallestDestination
                    .map(\.destinationRange)
                    .map({ range in
                        range.clamped(to: targetRange)
                    })
                    .filter({ !$0.isEmpty })
                
                print(name)
                print("Target: ", targetRange)
                print("Overlapping: ", overlappingDestinationRanges)
                
                var gapsFilled = overlappingDestinationRanges.enumerated()
                    .compactMap({ item -> (Range<Int>, Range<Int>)? in
                        guard item.offset + 1 < overlappingDestinationRanges.count else {
                            return nil
                        }
                        
                        let nextElement = overlappingDestinationRanges[item.offset + 1]
                        return (item.element, nextElement)
                    })
                    .flatMap { (thisElement, nextElement) in
                        let gapRange = (thisElement.upperBound..<nextElement.lowerBound)
                        return [thisElement, gapRange]
                    }
                
                if gapsFilled.isEmpty {
                    gapsFilled = [targetRange]
                } else {
                    let firstRange = gapsFilled.first!
                    let lastRange = gapsFilled.last!
                    
                    print(firstRange, lastRange)
                    
                    let prefixRange = (targetRange.lowerBound..<firstRange.lowerBound)
                    print("Prefix: ", prefixRange)
                    
                    let suffixRange = (lastRange.upperBound..<targetRange.upperBound)
                    print("Suffix:", suffixRange)
                    
                    gapsFilled.insert(prefixRange, at: 0)
                    gapsFilled.append(suffixRange)
                    gapsFilled = gapsFilled.filter({ !$0.isEmpty })
                }
                
                print("Gaps filled", gapsFilled)
                
                let sourceRange = gapsFilled
                    .map({ destinationRange in
                        let start = reverseLookup(destinationRange.lowerBound).min()!
                        print("Start: \(destinationRange.lowerBound) -> \(start)")
                        
                        let end = reverseLookup(destinationRange.upperBound).max()!
                        print("End: \(destinationRange.upperBound) -> \(end)")
                        
                        print("\(start)..<\(end)")
                        return Range((start...end))
                    })
                
                print("Mapped Source Ranges:", sourceRange)
                return sourceRange
            }
        }
        
        var seeds: [Int]
        
        var seedToSoil: Map
        var soilToFertilizer: Map
        var fertilizerToWater: Map
        var waterToLight: Map
        var lightToTemp: Map
        var tempToHumidity: Map
        var humidityToLocation: Map
        
        init(input: Input) {
            let sections = input.sections
            
            seeds = sections[0][0]
                .split(separator: " ")
                .map(String.init)
                .compactMap(Int.init)
            
            seedToSoil = Map(descriptor: sections[1])
            soilToFertilizer = Map(descriptor: sections[2])
            fertilizerToWater = Map(descriptor: sections[3])
            waterToLight = Map(descriptor: sections[4])
            lightToTemp = Map(descriptor: sections[5])
            tempToHumidity = Map(descriptor: sections[6])
            humidityToLocation = Map(descriptor: sections[7])
        }
        
        var lowestLocationNumber: Int {
            seeds
                .map(lookupLocation(forSeed:))
                .reduce(Int.max, min)
        }
        
        var seedPairs: [(start: Int, range: Int)] {
            var pairs = [(start: Int, range: Int)]()
            
            var start: Int? = nil
            for seedNumber in seeds {
                if let storedStart = start {
                    pairs.append((start: storedStart, range: seedNumber))
                    start = nil
                } else {
                    start = seedNumber
                }
            }
            
            return pairs
        }
        
        var seedRanges: [Range<Int>] {
            seedPairs.map({ ($0.start..<$0.start + $0.range)})
        }
        
        var lowestLocationFromPairs: Int {
            return seedPairs
                .map { (start, range) in
                    let end = start + range
                    return (start..<end)
                }
                .reduce(Int.max) { partialResult, seeds in
                    print("Seeds in batch: \(seeds.count)")
                    
                    let lowest = seeds.reduce(Int.max, { partialResult, seed in
                        if (seed % 100 == 0) { print("Seed \(seed)") }
                        return min(partialResult, lookupLocation(forSeed: seed))
                    })
                    
                    return min(partialResult, lowest)
                }
        }
        
        var solveBackwards: Int {
            for location in (0..<1_000_000_000) {
                if location % 1000 == 0 {
                    print("Location: \(location)")
                }
                let seeds = lookupSeeds(forLocation: location)
                if seeds.contains(where: seedExistsInSpread) {
                    return location
                }
            }
            
            return 0
        }
        
        var lowestSeedRanges: [Range<Int>] {
            let humidityRanges = humidityToLocation.rowsSortedBySmallestDestination
                .map(\.sourceRange)
            
            print("Humidty Ranges \(humidityRanges.count)")
            
            let totalRanges = humidityRanges
                .flatMap({ tempToHumidity.sourceRanges(thatIntersectDestinationRange: $0) })
                .flatMap({ lightToTemp.sourceRanges(thatIntersectDestinationRange: $0) })
                .flatMap({ waterToLight.sourceRanges(thatIntersectDestinationRange: $0) })
                .flatMap({ fertilizerToWater.sourceRanges(thatIntersectDestinationRange: $0) })
                .flatMap({ soilToFertilizer.sourceRanges(thatIntersectDestinationRange: $0) })
                .flatMap({ seedToSoil.sourceRanges(thatIntersectDestinationRange: $0) })
            
            print("Total ranges, \(totalRanges.count)")
            
            return totalRanges
        }
        
        func seedExistsInSpread(_ seed: Int) -> Bool {
            seedPairs.contains { (start: Int, range: Int) in
                return seed >= start && seed < start + range
            }
        }
        
        var solveByBoundaries: Int {
            let s = possibleSeeds
            print("Seeds: \(s.count)")
            
            let winner = possibleSeeds
                .map({ seed in
                    (seed, lookupLocation(forSeed: seed))
                })
                .min { lhs, rhs in
                    lhs.1 < rhs.1
                }!
            
            print("Winning Seed: \(winner.0)")
            return winner.1
        }
        
        var possibleSeeds: [Int] {
            let seedBounds = seedPairs.map(\.start) + seedPairs.map({ $0.start + $0.range })
            let soilBounds = (seedBounds + seedToSoil.rowBoundaries).map(seedToSoil.lookup(_:))
            let fertBounds = (soilBounds + soilToFertilizer.rowBoundaries).map(soilToFertilizer.lookup(_:))
            let waterBounds = (fertBounds + fertilizerToWater.rowBoundaries).map(fertilizerToWater.lookup(_:))
            let lightBounds = (waterBounds + waterToLight.rowBoundaries).map(waterToLight.lookup(_:))
            let tempBounds = (lightBounds + lightToTemp.rowBoundaries).map(lightToTemp.lookup(_:))
            let humidBounds = (tempBounds + tempToHumidity.rowBoundaries).map(tempToHumidity.lookup(_:))
            let locationBounds = (humidBounds + humidityToLocation.rowBoundaries).map(humidityToLocation.lookup(_:))
            
            print("Min location:", locationBounds.min()!)
            
            return locationBounds
                .flatMap({ lookupSeeds(forLocation: $0) })
                .filter({ seedExistsInSpread($0) }) + [2302307275]
        }
        
        func lookupLocation(forSeed seed: Int) -> Int {
            let soil = seedToSoil.lookup(seed)
            let fert = soilToFertilizer.lookup(soil)
            let water = fertilizerToWater.lookup(fert)
            let light = waterToLight.lookup(water)
            let temp = lightToTemp.lookup(light)
            let humidity = tempToHumidity.lookup(temp)
            let location = humidityToLocation.lookup(humidity)
            return location
        }
        
        func lookupSeeds(forLocation location: Int) -> [Int] {
            humidityToLocation.reverseLookup(location)
                .flatMap({ tempToHumidity.reverseLookup($0) })
                .flatMap({ lightToTemp.reverseLookup($0) })
                .flatMap({ waterToLight.reverseLookup($0) })
                .flatMap({ fertilizerToWater.reverseLookup($0) })
                .flatMap({ soilToFertilizer.reverseLookup($0) })
                .flatMap({ seedToSoil.reverseLookup($0) })
        }
    }
}
