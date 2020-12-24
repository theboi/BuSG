//
//  Constants.swift
//   BuSG
//
//  Created by Ryan The on 16/11/20.
//

import UIKit
import CoreLocation

enum K {
    
    /// DataMall does not support HTTPS
    private static let apiUrlBase = "http://datamall2.mytransport.sg/ltaodataservice"
    
    enum margin {
        static let half: CGFloat = 4
        static let one: CGFloat = 8
        static let two: CGFloat = 16
        static let twoAndHalf: CGFloat = 24
    }
    
    static let bottomSheetOpacity: CGFloat = 0.7
    static let cornerRadius: CGFloat = 8
    
    static let nearbyCoordRadius: Double = 1/111.3/2 // 0.5km radius. 1 degree of lat/long is approximately equal to 111.3 kilometers
    static let busStopRoutingSkip = 5
    static let nilStr = "-"
    static let cellHeight: CGFloat = 50
    static let backgroundThreadLabel = "com.ryanthe.background"
    
    static let defaultLocation = CLLocation(latitude: 1.3521, longitude: 103.8198)
    
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
        static let busStopCell = "busStopCellIdentifier"
        static let busServiceCell = "busServiceCellIdentifier"
        static let busArrivalCell = "busArrivalCellIdentifier"
        static let busSuggestionCell = "busSuggestionCellIdentifier"
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
