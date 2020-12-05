
import Foundation

let colorRegex = try! NSRegularExpression(pattern: "^#[abcdef0123456789]{6}$", options: [])
let numericRegex = try! NSRegularExpression(pattern: "^\\d{9}$", options: [])

class Puzzle2004: Puzzle {
    let name: String = "2020_04"
    
    func solveA(_ input: Input) -> String {
        let passportInputs = input.lines.split(separator: "").map(Array.init)
        let passports = passportInputs.map(Passport.init)
        let count = passports.filter(\.isValid).count
        return "\(count)"
    }
    
    var testCasesA: [TestCase] = [
        TestCase(TextInput("""
                    ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
                    byr:1937 iyr:2017 cid:147 hgt:183cm
                    
                    iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
                    hcl:#cfa07d byr:1929
                    
                    hcl:#ae17e1 iyr:2013
                    eyr:2024
                    ecl:brn pid:760753108 byr:1931
                    hgt:179cm
                    
                    hcl:#cfa07d eyr:2025 pid:166559648
                    iyr:2011 ecl:brn hgt:59in
                    """), expectedOutput: "2")
    ]
    
    func solveB(_ input: Input) -> String {
        let passportInputs = input.lines.split(separator: "").map(Array.init)
        let passports = passportInputs.map(Passport.init)
        let count = passports.filter(\.isStrictlyValid).count
        return "\(count)"
    }
    
    var testCasesB: [TestCase] = [
        TestCase(TextInput("""
                    eyr:1972 cid:100
                    hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926
                    
                    iyr:2019
                    hcl:#602927 eyr:1967 hgt:170cm
                    ecl:grn pid:012533040 byr:1946
                    
                    hcl:dab227 iyr:2012
                    ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277
                    
                    hgt:59cm ecl:zzz
                    eyr:2038 hcl:74454a iyr:2023
                    pid:3556412378 byr:2007
                    """), expectedOutput: "0"),
        TestCase(TextInput("""
                    pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
                    hcl:#623a2f

                    eyr:2029 ecl:blu cid:129 byr:1989
                    iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

                    hcl:#888785
                    hgt:164cm byr:2001 iyr:2015 cid:88
                    pid:545766238 ecl:hzl
                    eyr:2022

                    iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
                    """), expectedOutput: "4")
    ]
    
    struct Passport {
        var keyValues: Set<KeyValue>
        
        init(_ lines: [String]) {
            var set = Set<KeyValue>()
            for line in lines {
                set = set.union(Passport.keyValues(in: line))
            }
            self.keyValues = set
        }
        
        static func keyValues(in line: String) -> Set<KeyValue> {
            let keyValues = line.split(separator: " ").map(String.init).map(KeyValue.init)
            return Set(keyValues)
        }
        
        static let requiredKeys = [
            "byr", // (Birth Year)
            "iyr", // (Issue Year)
            "eyr", // (Expiration Year)
            "hgt", // (Height)
            "hcl", // (Hair Color)
            "ecl", // (Eye Color)
            "pid", // (Passport ID)
//            "cid" // (Country ID)
        ]
        
        func value(of key: String) -> String? {
            let kv = keyValues.first(where: { $0.key == key })
            return kv?.value
        }
        
        var isValid: Bool {
            return Passport.requiredKeys.map(value(of:)).allSatisfy({ $0 != nil })
        }
        
        var isStrictlyValid: Bool {
            return Passport.requiredKeys.allSatisfy({ key in
                guard let kv = keyValues.first(where: { $0.key == key }) else { return false }
                return kv.isValid
            })
        }
        
        
    }
    
    struct KeyValue: Hashable, Equatable{
        var key: String
        var value: String
        
        init(_ descriptor: String) {
            let parts = descriptor.split(separator: ":")
            self.key = String(parts[0])
            self.value = String(parts[1])
        }
        
        var isValid: Bool {
            switch key {
            case "byr":
                guard value.count == 4 else { return false }
                guard let val = Int(value) else { return false }
                return val >= 1920 && val <= 2002
                
            case "iyr":
                guard value.count == 4 else { return false }
                guard let val = Int(value) else { return false }
                return val >= 2010 && val <= 2020
                
            case "eyr":
                guard value.count == 4 else { return false }
                guard let val = Int(value) else { return false }
                return val >= 2020 && val <= 2030
                
            case "hgt":
                let lastTwoCharsIndex = value.index(value.endIndex, offsetBy: -2, limitedBy: value.startIndex)!
                let dim = value[lastTwoCharsIndex...]
                let scalar = Int(String(value.dropLast(2)))!
                switch dim {
                case "in":
                    return scalar >= 59 && scalar <= 76
                case "cm":
                    return scalar >= 150 && scalar <= 193
                default:
                    return false
                }
                
            case "hcl":
                let fullRange = NSRange(location: 0, length: value.count)
                return colorRegex.firstMatch(in: value, options: [], range: fullRange) != nil
            
            case "ecl":
                let validColors = [
                    "amb", "blu", "brn", "gry", "grn", "hzl", "oth"
                ]
                return validColors.contains(value)
                
            case "pid":
                let fullRange = NSRange(location: 0, length: value.count)
                return numericRegex.firstMatch(in: value, options: [], range: fullRange) != nil
                
            case "cid":
                return true
                
            default:
                return false
            }
        }
    }
}
