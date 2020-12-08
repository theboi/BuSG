//
//  BusNumber.swift
//  Navigem
//
//  Created by Ryan The on 29/11/20.
//

enum BusServiceOperator: String, Codable {
    /// SBST (for SBS Transit)
    case sbst = "SBST"
    /// SMRT (for SMRT Corporation)
    case smrt = "SMRT"
    /// TTS (for Tower Transit Singapore)
    case tts = "TTS"
    /// GAS (for Go Ahead Singapore)
    case gas = "GAS"
    case none = ""
}

enum BusServiceCategory: String, Codable {
    /// EXPRESS
    case express = "EXPRESS"
    /// FEEDER
    case feeder = "FEEDER"
    /// INDUSTRIAL
    case industrial = "INDUSTRIAL"
    /// TOWNLINK
    case townlink = "TOWNLINK"
    /// TRUNK
    case trunk = "TRUNK"
    /// 2 TIER FLAT FEE
    case flat2 = "2-TIER FLAT FARE"
    /// Uncertain of actual raw value. FLAT FEE $1.10 (or $1.90, $3.50, $3.80)
    case flat = "FLAT"
    /// Special case for buses CT8 and CT18 solely operated by SBST
    case sbst = "SBST"
    
    case night = "NIGHT RIDER"
    case none = ""
}

struct BusServiceMapperValue: Codable {
    
    /// The bus service number. Sample: `"107M"`
    let serviceNo: String
    
    /// Operator for this bus service. Sample: `"SBST"`
    let serviceOperator: BusServiceOperator?
    
    /// The direction in which the bus travels (1 or 2), loop services only have 1 direction. Sample: `1`
    let direction: Int
    
    /// Category of the SBS bus service: EXPRESS, FEEDER, INDUSTRIAL, TOWNLINK, TRUNK, 2 TIER FLAT FEE, FLAT FEE $1.10 (or $1.90, $3.50, $3.80). Sample: `"TRUNK"`
    let category: BusServiceCategory?
    
    /// Bus stop code for first bus stop. Sample: `"64009"`
    let originCode: String?
    
    /// Bus stop code for last bus stop (similar as first stop for loop services). Sample: `"64009"`
    let destinationCode: String?
    
    /// Freq of dispatch for AM Peak 0630H - 0830H (range in minutes)
    let amPeakFreq: String?
    
    /// Freq of dispatch for AM Off-Peak 0831H - 1659H (range in minutes)
    let amOffpeakFreq: String?
    
    /// Freq of dispatch for PM Peak 1700H - 1900H (range in minutes)
    let pmPeakFreq: String?
    
    /// Freq of dispatch for PM Off-Peak after 1900H (range in minutes)
    let pmOffpeakFreq: String?
    
    /// Location at which the bus service loops, empty if not a loop service.
    let loopDesc: String?
    
    enum CodingKeys: String, CodingKey {
        case serviceNo = "ServiceNo"
        case serviceOperator = "Operator"
        case direction = "Direction"
        case category = "Category"
        case originCode = "OriginCode"
        case destinationCode = "DestinationCode"
        case amPeakFreq = "AM_Peak_Freq"
        case amOffpeakFreq = "AM_Offpeak_Freq"
        case pmPeakFreq = "PM_Peak_Freq"
        case pmOffpeakFreq = "PM_Offpeak_Freq"
        case loopDesc = "LoopDesc"
    }
    
}

struct BusServiceMapperRoot: Codable, BusApiMapperRoot {
    
    typealias Value = BusServiceMapperValue
        
    static let apiUrl = K.apiUrls.busServices
    
    let value: [Value]

    let metaData: String
    
    enum CodingKeys: String, CodingKey {
        case metaData = "odata.metadata"
        case value
    }
    
}
