//
//  Array.swift
//  BuSG
//
//  Created by Ryan The on 15/12/20.
//

extension Sequence {
    
    func uniqued() -> [Iterator.Element] where Iterator.Element: Hashable {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
    
    func uniqued<T>(by uniqueKey: (Element) throws -> T) rethrows -> [Iterator.Element] where T: Hashable {
        var seen: Set<T> = []
        return try filter { seen.insert(try uniqueKey($0)).inserted }
    }
    
}
