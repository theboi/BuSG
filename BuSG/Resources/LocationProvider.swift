//
//  LocationProvider.swift
// BuSG
//
//  Created by Ryan The on 3/12/20.
//

import Foundation
import MapKit

protocol LocationProviderDelegate: class {
    
    func locationProvider(didRequestNavigateTo location: CLLocation)
    
    func locationProvider(didRequestNavigateTo annotation: MKAnnotation)
    
    func locationProvider(didRequestRouteFor busService: BusService, in direction: Int64)
    
    func locationProviderDidRequestNavigateToCurrentLocation()

}

class LocationProvider: NSObject {
    
    static let shared = LocationProvider()
    
    lazy var locationManager = CLLocationManager()
    
    weak var delegate: LocationProviderDelegate?
    
    public var currentLocation: CLLocation {
        locationManager.location ?? CLLocation(latitude: 0, longitude: 0)
    }
    
}
