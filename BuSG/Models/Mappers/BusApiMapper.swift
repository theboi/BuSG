//
//  ApiService.swift
//   BuSG
//
//  Created by Ryan The on 2/12/20.
//

protocol BusApiMapperRoot: Codable {
    
    associatedtype Value
        
    static var apiUrl: String { get }
    
    var value: [Value] { get }
    
    var metaData: String { get }
    
}
