import Foundation

protocol Input {
    var data: Data { get }
    var text: String { get }
    var lines: [String] { get }
}

class DataInput: Input {
    var data: Data
    init(_ data: Data) {
        self.data = data
    }
    
    lazy var text: String = {
        return String(data: data, encoding: .utf8)!
    }()
    
    lazy var lines: [String] = {
        return text.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
    }()
}

class TextInput: Input {
    var text: String
    init(_ text: String) {
        self.text = text
    }
    
    lazy var data: Data = {
        return text.data(using: .utf8)!
    }()
    
    lazy var lines: [String] = {
        return text.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
    }()
}

class LinesInput: Input {
    var lines: [String]
    init(_ lines: [String]) {
        self.lines = lines.map({ $0.trimmingCharacters(in: .newlines )})
    }
    
    lazy var text: String = {
        return lines.joined(separator: "\n")
    }()
    
    lazy var data: Data = {
        return text.data(using: .utf8)!
    }()
}

class STDIN: LinesInput {
    init() {
        var lines = [String]()
        while let line = readLine(strippingNewline: true) {
            lines.append(line)
        }
        super.init(lines)
    }
}

class FileInput: DataInput {
    init(_ url: URL) throws {
        let data = try Data(contentsOf: url)
        super.init(data)
    }
    
    init(path: String) {
        let data = FileManager.default.contents(atPath: path)!
        super.init(data)
    }
}

extension Input {
    var grid: [GridCoordinate: Character] {
        var result = [GridCoordinate: Character]()
        for (y, line) in lines.enumerated() {
            for (x, character) in line.enumerated() {
                let coord = GridCoordinate(x: x, y: y)
                result[coord] = character
            }
        }
        return result
    }
}
