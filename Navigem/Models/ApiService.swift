//
//  ApiService.swift
//  Navigem
//
//  Created by Ryan The on 2/12/20.
//

import Foundation

protocol ApiServiceRoot: Codable {
    
    associatedtype T
    
    static var apiUrl: String { get }
    
    var value: [T] { get }
    
    var metaData: String { get }
    
}
