//
//  File.swift
//  
//
//  Created by Avery Pierce on 12/6/20.
//

import Foundation

extension Set {
    mutating func insert<C: Collection>(membersOf collection: C) where C.Element == Element {
        for member in collection {
            insert(member)
        }
    }
    
    mutating func remove<C: Collection>(membersOf collection: C) where C.Element == Element {
        for member in collection {
            remove(member)
        }
    }
}
