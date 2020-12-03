//
//  BusRouteService.swift
//  Navigem
//
//  Created by Ryan The on 3/12/20.
//

import Foundation

struct BusRouteServiceValue: Codable {
    
    /// The bus service number. Sample: `"107M"`
    let serviceNo: String
    
    /// Operator for this bus service. Sample: `"SBST"`
    let serviceOperator: BusServiceOperator
    
    /// The direction in which the bus travels (1 or 2), loop services only have 1 direction. Sample: `"1"`
    let direction: Int
    
    /// The i-th bus stop for this route. Sample: `"28"`
    let stopSequence: Int
    
    /// The unique 5-digit identifier for this physical bus stop. Sample: `"01219"`
    let busStopCode: String
    
    /// Distance travelled by bus from starting location to this bus stop (in kilometres). Sample: `"10.3"`
    let distance: Double
    
    /// Scheduled arrival of first bus on weekdays. Sample: `"2025"`
    let wdFirstBus: String
    
    /// Scheduled arrival of last bus on weekdays. Sample: `"2352"`
    let wdLastBus: String
    
    /// Scheduled arrival of first bus on Saturdays. Sample: `"1427"`
    let satFirstBus: String
    
    /// Scheduled arrival of last bus on Saturdays. Sample: `"2349"`
    let satLastBus: String
    
    /// Scheduled arrival of first bus on Sundays. Sample: `"0620"`
    let sunFirstBus: String
    
    /// Scheduled arrival of last bus on Sundays. Sample: `"2349"`
    let sunLastBus: String
    
    enum CodingKeys: String, CodingKey {
        case serviceNo = "ServiceNo"
        case serviceOperator = "Operator"
        case direction = "Direction"
        case stopSequence = "StopSequence"
        case busStopCode = "BusStopCode"
        case distance = "Distance"
        case wdFirstBus = "WD_FirstBus"
        case wdLastBus = "WD_LastBus"
        case satFirstBus = "SAT_FirstBus"
        case satLastBus = "SAT_LastBus"
        case sunFirstBus = "SUN_FirstBus"
        case sunLastBus = "SUN_LastBus"
    }
    
}

struct BusRouteServiceRoot: Codable, BusApiServiceRoot {
    
    typealias T = BusRouteServiceValue
    
    static let apiUrl = K.apiUrls.busRoutes
    
    let value: [BusRouteServiceValue]

    let metaData: String
    
    enum CodingKeys: String, CodingKey {
        case metaData = "odata.metadata"
        case value
    }
    
}
