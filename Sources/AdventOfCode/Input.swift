import Foundation

public protocol Input {
    var data: Data { get }
    var text: String { get }
    var lines: [String] { get }
}

public class DataInput: Input {
    public var data: Data
    public init(_ data: Data) {
        self.data = data
    }
    
    public lazy var text: String = {
        return String(data: data, encoding: .utf8)!
    }()
    
    public lazy var lines: [String] = {
        return text.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
    }()
}

public class TextInput: Input {
    public var text: String
    public init(_ text: String) {
        self.text = text
    }
    
    public lazy var data: Data = {
        return text.data(using: .utf8)!
    }()
    
    public lazy var lines: [String] = {
        return text.split(separator: "\n", omittingEmptySubsequences: false).map(String.init)
    }()
}

public class LinesInput: Input {
    public var lines: [String]
    public init(_ lines: [String]) {
        self.lines = lines.map({ $0.trimmingCharacters(in: .newlines )})
    }
    
    public lazy var text: String = {
        return lines.joined(separator: "\n")
    }()
    
    public lazy var data: Data = {
        return text.data(using: .utf8)!
    }()
}

public class STDIN: LinesInput {
    public init() {
        var lines = [String]()
        while let line = readLine(strippingNewline: true) {
            lines.append(line)
        }
        super.init(lines)
    }
}

public class FileInput: DataInput {
    public init(_ url: URL) throws {
        let data = try Data(contentsOf: url)
        super.init(data)
    }
    
    public init(path: String) {
        let data = FileManager.default.contents(atPath: path)!
        super.init(data)
    }
}

public extension Input {
    var grid: [GridCoordinate: Character] {
        return lines.characterGrid
    }
}

public extension Input {
    var sections: [[String]] {
        return lines.split(separator: "").map(Array.init)
    }
}
