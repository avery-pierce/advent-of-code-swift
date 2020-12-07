//
//  File.swift
//  
//
//  Created by Avery Pierce on 12/3/20.
//

import Foundation

func regexParse(_ string: String) -> (String) -> [String]? {
    let regex = try! NSRegularExpression(pattern: string, options: [])
    
    return { (_ input: String) -> [String]? in
        let range = NSRange(location: 0, length: input.count)
        guard let match = regex.firstMatch(in: input, options: [], range: range) else { return nil }
        var ranges = (0..<match.numberOfRanges).map { (index) -> NSRange in
            return match.range(at: index)
        }
        
        ranges.removeFirst()
        
        let nsString = NSString(string: input)
        return ranges.compactMap { (range) -> String? in
            guard range.location < nsString.length else { return nil }
            return nsString.substring(with: range)
        }
    }
}
