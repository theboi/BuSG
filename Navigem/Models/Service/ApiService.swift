//
//  ApiService.swift
//  Navigem
//
//  Created by Ryan The on 2/12/20.
//

import Foundation
import CoreData

protocol BusApiServiceRoot: Codable {
    
    associatedtype Value
    
    associatedtype Data: NSManagedObject & NSFetchRequestResult
    
    static var apiUrl: String { get }
    
    var value: [Value] { get }
    
    var metaData: String { get }
    
}
