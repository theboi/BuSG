//
//  Constants.swift
//   BuSG
//
//  Created by Ryan The on 16/11/20.
//

import UIKit
import CoreLocation

/// DataMall does not support HTTPS
let apiUrlBase = "http://datamall2.mytransport.sg/ltaodataservice"

enum K {
    enum margin {
        static let small: CGFloat = 8
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 24
    }
    
    static let bottomSheetOpacity: CGFloat = 0.7
    static let cornerRadius: CGFloat = 8
    
    static let nearbyCoordRadius: Double = 1/111.3/2 // 0.5km radius. 1 degree of lat/long is approximately equal to 111.3 kilometers
    static let datamallEnvVar = "datamall_api_key"
    static let busStopRoutingSkip = 5
    static let nilStr = "-"
    static let cellHeight: CGFloat = 50
    
    enum apiUrls {
        static let busArrivals = "\(apiUrlBase)/BusArrivalv2"
        static let busServices = "\(apiUrlBase)/BusServices"
        static let busRoutes = "\(apiUrlBase)/BusRoutes"
        static let busStops = "\(apiUrlBase)/BusStops"
    }
    
    enum apiQueries {
        static let skip = "$skip"
        static let busStopCode = "BusStopCode"
        static let busServiceNo = "ServiceNo"
        static let apiKeyHeader = "AccountKey"
    }
    
    enum identifiers {
        static let busServiceCell = "busServiceCellIdentifier"
        static let busStopCell = "busStopCellIdentifier"
        static let busSuggestedCell = "busSuggestedCellIdentifier"
        static let settingsCell = "settingsCellIdentifier"
        static let listViewHeader = "settingsHeaderIdentifier"
    }
    
    enum userDefaults {
        static let lastOpenedEpoch = "lastOpenedEpoch"
        static let lastUpdatedEpoch = "lastUpdatedEpoch"
        static let connectToCalendar = "connectToCalendar"
        static let updateFrequency = "updateFrequency"
        static let favoritePlaces = "favoritePlaces"
    }
    
    enum mapView {
        static let edgePadding = UIEdgeInsets(top: 0, left: 10, bottom: 500, right: 10)
        static let span: CLLocationDistance = 500
    }
}
