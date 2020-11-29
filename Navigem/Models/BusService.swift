//
//  BusNumber.swift
//  Navigem
//
//  Created by Ryan The on 29/11/20.
//

import Foundation

enum BusServiceOperator: String {
    /// SBST (for SBS Transit)
    case sbst = "SBST"
    /// SMRT (for SMRT Corporation)
    case smrt = "SMRT"
    /// TTS (for Tower Transit Singapore)
    case tts = "TTS"
    /// GAS (for Go Ahead Singapore)
    case gas = "GAS"
}

enum BusServiceCategory: String {
    /// EXPRESS, FEEDER, INDUSTRIAL, TOWNLINK, TRUNK, 2 TIER FLAT FEE, FLAT FEE $1.10 (or $1.90, $3.50, $3.80)
    case express = "EXPRESS"
    case feeder = "FEEDER"
    case industrial = "INDUSTRIAL"
    case townlink = "TOWNLINK"
    case trunk = "TRUNK"
    case flat2 = "2-TIER FLAT FARE"
    case flat = "FLAT"
}

enum BusServiceDirection: Int {
    case single = 1
    case double = 2
}

typealias BusServiceNumber = String

struct BusService {
    /// The bus service number. Sample: `"107M"`
    let serviceNo: BusServiceNumber
    
    /// Operator for this bus service. Sample: `"SBST"`
    let `operator`: BusServiceOperator
    
    /// The direction in which the bus travels (1 or 2), loop services only have 1 direction. Sample: `"1"`
    let direction: BusServiceDirection
    
    /// Category of the SBS bus service: EXPRESS, FEEDER, INDUSTRIAL, TOWNLINK, TRUNK, 2 TIER FLAT FEE, FLAT FEE $1.10 (or $1.90, $3.50, $3.80). Sample: `"TRUNK"`
    let category: BusServiceCategory
    
    /// Bus stop code for first bus stop. Sample: `"64009"`
    let originCode: BusStopCode
    
    /// Bus stop code for last bus stop (similar as first stop for loop services). Sample: `"64009"`
    let destinationCode: BusStopCode
}
