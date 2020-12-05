//
//  LocationProvider.swift
//  Navigem
//
//  Created by Ryan The on 3/12/20.
//

import Foundation
import MapKit

enum ZoomLevel: Double {
    case one = 400
    case two = 1000
    case three = 2000
    case bounding
}

protocol LocationProviderDelegate: class {
    
    func locationProvider(didRequestNavigateTo location: CLLocation, with zoomLevel: ZoomLevel)
    
    func locationProvider(didRequestNavigateTo annotation: MKAnnotation, with zoomLevel: ZoomLevel)
    
    func locationProvider(didRequestRouteFrom originBusStop: BusStop, to destinationBusStop: BusStop)
    
    func locationProvider(didRequestNavigateToCurrentLocationWith zoomLevel: ZoomLevel, animated: Bool)

}

class LocationProvider: NSObject {
    
    static let shared = LocationProvider()
    
    lazy var locationManager = CLLocationManager()
    
    weak var delegate: LocationProviderDelegate?
    
    public var currentLocation: CLLocation {
        locationManager.location ?? CLLocation(latitude: 0, longitude: 0)
    }
    
}
