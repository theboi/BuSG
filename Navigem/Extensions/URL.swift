//
//  URL.swift
//  Navigem
//
//  Created by Ryan The on 29/11/20.
//

import Foundation

extension URL {
    public init?(string: String, with queries: [URLQueryItem]) {
        self.init(string: "\(string)\(queries.map { return "\($0.name)=\($0.value ?? "")&"})")
    }
}
