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
}

protocol LocationProviderDelegate: class {
    
    func locationProvider(didRequestNavigateTo location: CLLocation, with zoomLevel: ZoomLevel)
    
    func locationProvider(didRequestNavigateTo annotation: MKAnnotation, with zoomLevel: ZoomLevel)
    
    func locationProvider(didRequestNavigateToCurrentLocationWith zoomLevel: ZoomLevel)

}

class LocationProvider: NSObject {
    
    static let shared = LocationProvider()
    
    lazy var locationManager = CLLocationManager()
    
    weak var delegate: LocationProviderDelegate?
    
    public var currentLocation: CLLocation {
        locationManager.location ?? CLLocation(latitude: 0, longitude: 0)
    }
    
}
