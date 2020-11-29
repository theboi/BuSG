//
//  BusStop.swift
//  Navigem
//
//  Created by Ryan The on 29/11/20.
//

import Foundation
import CoreLocation

typealias BusStopCode = Int

typealias BusStopRoadName = String

typealias BusStopDescription = String?

struct BusStop {
    /// The unique 5-digit identifier for this physical bus stop. Sample: `"01012"`
    let busStopCode: BusStopCode
    
    /// The road on which this bus stop is located. Sample: `"Victoria St"`
    let roadName: BusStopRoadName
    
    /// Landmarks next to the bus stop (if any) to aid in identifying this bus stop. Sample: `"Hotel Grand Pacific"`
    let description: BusStopDescription
    
    /// Location coordinates for this bus stop. Sample: `"1.29685, 103.853"`
    let coordinate: CLLocationCoordinate2D
}
