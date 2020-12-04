//
//  LocationProvider.swift
//  Navigem
//
//  Created by Ryan The on 3/12/20.
//

import Foundation
import MapKit

class LocationProvider: NSObject {
    
    static let shared = LocationProvider()
    
    lazy var locationManager = CLLocationManager()
    
    public var currentLocation: CLLocation {
        locationManager.location ?? CLLocation(latitude: 0, longitude: 0)
    }
    
    public func navigateToCurrentLocation(mapView: MKMapView) {
        locationManager.requestLocation()
        let region = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(region, animated: true)
    }
    
}
