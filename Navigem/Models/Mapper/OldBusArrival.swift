//
//  BusArrival.swift
//  Navigem
//
//  Created by Ryan The on 1/12/20.
//

import Foundation
import CoreLocation

struct BusArrival: Codable {
    
    /// Date-time of this bus’ estimated time of arrival, expressed in the UTC standard, GMT+8 for Singapore Standard Time (SST)
    let estimatedArrival: Timing
    
    /// Current estimated location coordinates of this bus at point of published data
    //let coordinate: CLLocationCoordinate2D
    
    /// Current bus occupancy / crowding level
    let load: Load
    
    /// Indicates if bus is wheel-chair accessible
    let feature: Feature
    
    /// Vehicle type
    let type: Type
    
    enum CodingKeys: String, CodingKey {
        case estimatedArrival = "EstimatedArrival"
        case load = "Load"
        case feature = "Feature"
        case type = "Type"
    }
    
    typealias Timing = String

    enum Load: String, Codable {
        /// SEA (for Seats Available)
        case sea = "SEA"
        /// SDA (for Standing Available)
        case sda = "SDA"
        /// LSD (for Limited Standing)
        case lsd = "LSD"
    }

    enum Feature: String, Codable {
        /// WAB (for Wheelchair Accessible Bus)
        case wab = "WAB"
        /// Not WAB
        case none = ""
    }

    enum `Type`: String, Codable {
        /// SD (for Single Deck)
        case sd = "SD"
        /// DD (for Double Deck)
        case dd = "DD"
        /// BD (for Bendy)
        case bd = "BD"
    }
}
