import Foundation

struct TestCase {
    var input: Input
    var expectedOutput: String
    
    init(_ input: Input, expectedOutput: String) {
        self.input = input
        self.expectedOutput = expectedOutput
    }
}
