//
//  BusArrival.swift
//  Navigem
//
//  Created by Ryan The on 1/12/20.
//

enum BusArrivalLoad: String, Codable {
    /// SEA (for Seats Available)
    case sea = "SEA"
    /// SDA (for Standing Available)
    case sda = "SDA"
    /// LSD (for Limited Standing)
    case lsd = "LSD"
    case none = ""
}

enum BusArrivalFeature: String, Codable {
    /// WAB (for Wheelchair Accessible Bus)
    case wab = "WAB"
    /// Not WAB
    case none = ""
}

enum BusArrivalType: String, Codable {
    /// SD (for Single Deck)
    case sd = "SD"
    /// DD (for Double Deck)
    case dd = "DD"
    /// BD (for Bendy)
    case bd = "BD"
    case none = ""
}

struct BusArrivalBus: Codable {
    
    /// Reference code of the first bus stop where this bus started its service. Sample: `"77009"`
    let originCode: String?
    
    /// Reference code of the last bus stop where this bus will terminate its service. Sample: `"77131"`
    let destinationCode: String?
    
    /// Date-time of this bus’ estimated time of arrival, expressed in the UTC standard, GMT+8 for Singapore Standard Time (SST). Sample: `"2017-04-29T07:20:24+08:00"`
    let estimatedArrival: String?
    
    /// Current estimated location coordinates of this bus at point of published data. Sample: `1.42117943692586, 103.831477233098`
    let latitude: String?
    let longitude: String?
    
    /// Ordinal value of the nth visit of this vehicle at this bus stop; 1=1st visit, 2=2nd visit. Sample: `1`
    let visitNo: String?
    
    /// Current bus occupancy / crowding level. Sample: `"SEA"`
    let load: BusArrivalLoad?
    
    /// Indicates if bus is wheel-chair accessible. Sample: `"WAB"`
    let feature: BusArrivalFeature?
    
    /// Vehicle type. Sample: `"SD"`
    let type: BusArrivalType?
    
    enum CodingKeys: String, CodingKey {
        case originCode = "OriginCode"
        case destinationCode = "DestinationCode"
        case estimatedArrival = "EstimatedArrival"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case visitNo = "VisitNumber"
        case load = "Load"
        case feature = "Feature"
        case type = "Type"
    }
}

struct BusArrivalValue: Codable {
    
    /// Bus service number. Sample: `"15"`
    let serviceNo: String
    
    /// Public Transport Operator Codes. Sample: `"GAS"`
    let serviceOperator: BusServiceOperator?
    
    /// Structural tags for all bus level attributes^ of the next 3 oncoming buses. Note that if there is only one last bus left on the roads (e.g. at night), attributes values in NextBus2 and NextBus3 will be empty / blank.
    let nextBus1: BusArrivalBus?
    let nextBus2: BusArrivalBus?
    let nextBus3: BusArrivalBus?
    
    enum CodingKeys: String, CodingKey {
        case serviceNo = "ServiceNo"
        case serviceOperator = "Operator"
        case nextBus1 = "NextBus"
        case nextBus2 = "NextBus2"
        case nextBus3 = "NextBus3"
    }
    
}

struct BusArrivalRoot: Codable, BusApiMapperRoot {
    
    typealias Value = BusArrivalValue
        
    static let apiUrl = K.apiUrls.busServices
    
    let busStopCode: String
    
    let value: [Value]

    let metaData: String
    
    enum CodingKeys: String, CodingKey {
        case metaData = "odata.metadata"
        case value = "Services"
        case busStopCode = "BusStopCode"
    }
    
}
