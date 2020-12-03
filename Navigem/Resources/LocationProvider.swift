////
////  LocationProvider.swift
////  Navigem
////
////  Created by Ryan The on 3/12/20.
////
//
//import Foundation
//import MapKit
//
//class LocationProvider: NSObject {
//    
//    static let shared = LocationProvider()
//    
//    lazy var locationManager = CLLocationManager()
//    
//    var currentLocation: CLLocation {
//        locationManager.location ?? CLLocation(latitude: 0, longitude: 0)
//    }
//    
//    override init() {
//        locationManager.delegate = self
//        
//        guard CLLocationManager.locationServicesEnabled() else {
//            return
//        }
//        
//        if locationManager.authorizationStatus == .notDetermined {
//            locationManager.requestAlwaysAuthorization()
//        } else {
//            navigateToCurrentLocation()
//        }
//    }
//    
//    private func navigateToCurrentLocation(mapView: MKMapView) {
//        locationManager.requestLocation()
//        let region = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
//        mapView.setRegion(region, animated: true)
//    }
//    
//}
//
//extension LocationProvider: CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        navigateToCurrentLocation()
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else {
//            return
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        // TODO: CATCH
//        print("ERROR", error)
//    }
//}
