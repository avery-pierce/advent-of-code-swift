import Foundation

public struct TestCase {
    public var input: Input
    public var expectedOutput: String
    
    public init(_ input: Input, expectedOutput: String) {
        self.input = input
        self.expectedOutput = expectedOutput
    }
}
