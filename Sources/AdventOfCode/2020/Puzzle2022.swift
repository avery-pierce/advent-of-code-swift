
import Foundation

class Puzzle2022: Puzzle {
    let name: String = "2020_22"
    
    func solveA(_ input: Input) -> String {
        let players = input.sections.map { (section) -> Player in
            let cards = section[1...].compactMap(Int.init)
            return Player(deck: cards)
        }
        
        let sim = GameSimulation(player1: players[0], player2: players[1])
        sim.playUntilWinner()
        return "\(sim.winner!.score)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    Player 1:
                    9
                    2
                    6
                    3
                    1

                    Player 2:
                    5
                    8
                    4
                    7
                    10
                    """), expectedOutput: "306")
    ]
    
    func solveB(_ input: Input) -> String {
        let players = input.sections.map { (section) -> Player in
            let cards = section[1...].compactMap(Int.init)
            return Player(deck: cards)
        }
        
        let sim = RecursiveGameSimulation(player1: players[0], player2: players[1])
        sim.playUntilWinner()
        return "\(sim.winner!.score)"
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("""
                    Player 1:
                    43
                    19
                    
                    Player 2:
                    2
                    29
                    14
                    """), expectedOutput: "105"), // Should not loop forever
        TestCase(TextInput("""
                    Player 1:
                    9
                    2
                    6
                    3
                    1

                    Player 2:
                    5
                    8
                    4
                    7
                    10
                    """), expectedOutput: "291")
    ]
    
    class GameSimulation {
        let player1: Player
        let player2: Player
        
        init(player1: Player, player2: Player) {
            self.player1 = player1
            self.player2 = player2
        }
        
        func playUntilWinner() {
            while !isGameOver {
                takeTurn()
            }
        }
        
        func takeTurn() {
            let player1Card = player1.play()
            let player2Card = player2.play()
            
            if player1Card > player2Card {
                player1.win(winnersCard: player1Card, losersCard: player2Card)
            } else if (player2Card > player1Card) {
                player2.win(winnersCard: player2Card, losersCard: player1Card)
            } else {
                fatalError("Tie! This is not in the spec")
            }
        }
        
        var isGameOver: Bool {
            return player1.deck.isEmpty || player2.deck.isEmpty
        }
        
        var winner: Player? {
            if player1.deck.isEmpty {
                return player2
            }
            
            if player2.deck.isEmpty {
                return player1
            }
            
            return nil
        }
    }
    
    class RecursiveGameSimulation {
        static var memoizedGames = [Snapshot: Bool]()
        static func memoizedWinner(of snapshot: Snapshot) -> Bool? {
            if let memoizedResult = RecursiveGameSimulation.memoizedGames[snapshot] {
                return memoizedResult
            } else if let flippedMemoizedResult = RecursiveGameSimulation.memoizedGames[snapshot.reversed()] {
                return !flippedMemoizedResult
            } else {
                return nil
            }
        }
        
        var previousSnapshots = Set<Snapshot>()
        let player1: Player
        let player2: Player
        
        init(player1: Player, player2: Player) {
            self.player1 = player1
            self.player2 = player2
        }
        
        func playUntilWinner() {
            while !isGameOver {
                captureSnapshot()
                takeTurn()
            }
        }
        
        func takeTurn() {
            let player1Card = player1.play()
            let player2Card = player2.play()
            
            if player1.deck.count >= player1Card && player2.deck.count >= player2Card {
                
                // New round of recursive combat
                let newPlayer1 = Player(deck: Array(player1.deck[0..<player1Card]))
                let newPlayer2 = Player(deck: Array(player2.deck[0..<player2Card]))
                
                // Check to see if this game is already played
                let snapshot = Snapshot(player1: newPlayer1, player2: newPlayer2)
                if let memoizedResult = RecursiveGameSimulation.memoizedWinner(of: snapshot) {
                    print("Memoized shortcut! Count: \(RecursiveGameSimulation.memoizedGames.count)")
                    if memoizedResult {
                        // true means that player1 wins
                        player1.win(winnersCard: player1Card, losersCard: player2Card)
                    } else {
                        // false means that player2 wins
                        player2.win(winnersCard: player2Card, losersCard: player1Card)
                    }
                    return
                }
                
                let recursiveGame = RecursiveGameSimulation(player1: newPlayer1, player2: newPlayer2)
                recursiveGame.playUntilWinner()
                
                if recursiveGame.winner === newPlayer1 {
                    player1.win(winnersCard: player1Card, losersCard: player2Card)
                    RecursiveGameSimulation.memoizedGames[snapshot] = true
                } else if recursiveGame.winner === newPlayer2 {
                    player2.win(winnersCard: player2Card, losersCard: player1Card)
                    RecursiveGameSimulation.memoizedGames[snapshot] = false
                } else {
                    fatalError("Winner unclear! This is not in the spec")
                }
                
            } else {
                
                // Normal rules apply
                if player1Card > player2Card {
                    player1.win(winnersCard: player1Card, losersCard: player2Card)
                } else if (player2Card > player1Card) {
                    player2.win(winnersCard: player2Card, losersCard: player1Card)
                } else {
                    fatalError("Tie! This is not in the spec")
                }
            }
        }
        
        var isGameOver: Bool {
            return winner != nil
        }
        
        var winner: Player? {
            if previousSnapshots.contains(currentSnapshot) {
                return player1
            }
            
            if player1.deck.isEmpty {
                return player2
            }
            
            if player2.deck.isEmpty {
                return player1
            }
            
            return nil
        }
        
        var currentSnapshot: Snapshot {
            return Snapshot(player1: player1, player2: player2)
        }
        
        func captureSnapshot() {
            previousSnapshots.insert(currentSnapshot)
        }
        
        struct Snapshot: Equatable, Hashable {
            var player1Cards: [Int]
            var player2Cards: [Int]
            
            init(player1Cards: [Int], player2Cards: [Int]) {
                self.player1Cards = player1Cards
                self.player2Cards = player2Cards
            }
            
            init(player1: Player, player2: Player) {
                self.player1Cards = player1.deck
                self.player2Cards = player2.deck
            }
            
            func reversed() -> Snapshot {
                return Snapshot(player1Cards: player2Cards, player2Cards: player1Cards)
            }
        }
    }
    
    class Player {
        var deck: [Int]
        init(deck: [Int]) {
            self.deck = deck
        }
        
        func play() -> Int {
            // Play off the top
            return deck.remove(at: 0)
        }
        
        func collect(_ card: Int) {
            deck.append(card)
        }
        
        func win(winnersCard: Int, losersCard: Int) {
            collect(winnersCard)
            collect(losersCard)
        }
        
        var score: Int {
            deck.enumerated()
                .map({ (($0 * -1) + deck.count, $1) })
                .map({ $0 * $1 })
                .reduce(0, +)
        }
    }
}
