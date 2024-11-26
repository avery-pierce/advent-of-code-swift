
import Foundation
import AdventOfCode

class Puzzle2021: Puzzle {
    let name: String = "2020_21"
    
    func solveA(_ input: Input) -> String {
        let foods = input.lines.map(Food.init)
        let solver = AllergenSolver(Set(foods))
        solver.solve()
        print(solver.matchesByAllergen)
        
        let safeIngredients = solver.unknownIngredients
        let counts = safeIngredients.map(solver.countOccurrences(ofIngredient:))
        let sum = counts.reduce(0, +)
        
        return "\(sum)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
                    trh fvjkl sbzzf mxmxvkd (contains dairy)
                    sqjhc fvjkl (contains soy)
                    sqjhc mxmxvkd sbzzf (contains fish)
                    """), expectedOutput: "5")
    ]
    
    func solveB(_ input: Input) -> String {
        let foods = input.lines.map(Food.init)
        let solver = AllergenSolver(Set(foods))
        solver.solve()
        print(solver.matchesByAllergen)
        
        let allergens = solver.knownAllergens.sorted()
        let dangerousIngredients = allergens.map({ solver.matchesByAllergen[$0]! })
        return "\(dangerousIngredients.joined(separator: ","))"
    }
    
    var testCasesB: [TestCase] = [
        // Input test cases here
    ]
    
    
    struct Food: Hashable {
        var ingredients: Set<String>
        var allergens: Set<String>
        
        init(_ string: String) {
            let groups = regexParse("^(.*) \\(contains (.*)\\)$")(string)!
            self.ingredients = Set(groups[0].split(separator: " ").map(String.init))
            self.allergens = Set(groups[1].split(separator: ",").map({ $0.trimmingCharacters(in: .whitespaces) }))
        }
    }
    
    class AllergenSolver {
        var matchesByAllergen = [String: String]()
        let foods: Set<Food>
        
        init(_ foods: Set<Food>) {
            self.foods = foods
        }
        
        func solve() {
            while unknownAllergens.count > 0 {
                print(unknownAllergens)
                for allergen in unknownAllergens {
                    let foods = allFoods(containingAllergen: allergen)
                    let ingredients = commonIngredients(inAll: foods)
                    if ingredients.count == 1 {
                        matchesByAllergen[allergen] = Array(ingredients)[0]
                    }
                }
            }
        }
        
        var allAllergens: Set<String> {
            return Set(foods.flatMap(\.allergens))
        }
        
        var knownAllergens: Set<String> {
            return Set(matchesByAllergen.keys)
        }
        
        var unknownAllergens: Set<String> {
            return allAllergens.filter({ !knownAllergens.contains($0) })
        }
        
        func allFoods(containingAllergen allergen: String) -> Set<Food> {
            return foods.filter({ $0.allergens.contains(allergen) })
        }
        
        var allIngredients: Set<String> {
            return Set(foods.flatMap(\.ingredients))
        }
        
        var allKnownIngredients: Set<String> {
            return Set(matchesByAllergen.values)
        }
        
        var unknownIngredients: Set<String> {
            return allIngredients.filter({ !allKnownIngredients.contains($0) })
        }
        
        func unknownIngredients(of food: Food) -> Set<String> {
            return food.ingredients.filter({ !allKnownIngredients.contains($0) })
        }
        
        func commonIngredients(inAll foods: Set<Food>) -> Set<String> {
            let randomFood = foods.randomElement()!
            let ingredientsToCheck = unknownIngredients(of: randomFood)
            return ingredientsToCheck.filter({ ingredient in
                return foods.allSatisfy({ $0.ingredients.contains(ingredient) })
            })
        }
        
        func countOccurrences(ofIngredient ingredient: String) -> Int {
            foods.filter({ $0.ingredients.contains(ingredient) }).count
        }
    }
}
