//
//  BusStop.swift
//   BuSG
//
//  Created by Ryan The on 29/11/20.
//

import CoreLocation

struct BusStopMapperValue: Codable {
    
    /// The unique 5-digit identifier for this physical bus stop. Sample: `"01012"`
    let busStopCode: String
    
    /// The road on which this bus stop is located. Sample: `"Victoria St"`
    let roadName: String?
    
    /// Landmarks next to the bus stop (if any) to aid in identifying this bus stop. Sample: `"Hotel Grand Pacific"`
    let roadDesc: String?
    
    /// Location coordinates for this bus stop. Sample: `1.29685, 103.853`
    let latitude: Double?
    let longitude: Double?
    
    enum CodingKeys: String, CodingKey {
        case busStopCode = "BusStopCode"
        case roadName = "RoadName"
        case roadDesc = "Description"
        case latitude = "Latitude"
        case longitude = "Longitude"
    }
    
}

struct BusStopMapperRoot: Codable, BusApiMapperRoot {
    
    typealias Value = BusStopMapperValue
    
    static let apiUrl = K.apiUrls.busStops
    
    let value: [Value]
    
    let metaData: String
    
    enum CodingKeys: String, CodingKey {
        case metaData = "odata.metadata"
        case value
    }
    
}
