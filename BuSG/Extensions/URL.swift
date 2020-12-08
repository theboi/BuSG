//
//  URL.swift
//  Navigem
//
//  Created by Ryan The on 29/11/20.
//

import UIKit

extension URL {
    /// CC
    public init?(string: String, with queries: [URLQueryItem]) {
        self.init(string: "\(string)?\(queries.map { return "\($0.name)=\($0.value ?? "")" }.joined(separator: "&"))")
    }
    
    static func open(webURL string: String) {
        if let url = URL(string: string) {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
