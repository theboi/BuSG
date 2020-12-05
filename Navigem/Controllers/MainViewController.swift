//
//  MainViewController.swift
//  Navigem
//
//  Created by Ryan The on 16/11/20.
//

import UIKit
import MapKit

class MainViewController: UIViewController {
    
    lazy var mapView = MKMapView()
    
    var locationManager: CLLocationManager {
        LocationProvider.shared.locationManager
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .systemBackground
        
        self.view = mapView
        locationManager.delegate = self
        mapView.delegate = self
        LocationProvider.shared.delegate = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func checkForUpdates() {
        
        let nowEpoch = Date().timeIntervalSince1970
        let lastOpenedEpoch = UserDefaults.standard.double(forKey: K.userDefaults.lastOpenedEpoch)
        let lastUpdatedEpoch = UserDefaults.standard.double(forKey: K.userDefaults.lastUpdatedEpoch)
        
        if lastOpenedEpoch == 0 {
            print("First Timer!")
            // First time using app
            let launchViewController = UIViewController()
            launchViewController.view.backgroundColor = .systemBackground
            launchViewController.isModalInPresentation = true
            self.present(launchViewController, animated: true)
        }
        
        if lastUpdatedEpoch+604800 < nowEpoch { // 1 week = 604800 seconds
            // Requires update of bus data
            print("Updating Bus Data...")
            ApiProvider.shared.updateBusData() {
                UserDefaults.standard.setValue(nowEpoch, forKey: K.userDefaults.lastUpdatedEpoch)
            }
        }
        
        UserDefaults.standard.setValue(nowEpoch, forKey: K.userDefaults.lastOpenedEpoch)
        
        // FIX: MAPPING CAUSING CRASH EXC_BAD_ACCESS
        //ApiProvider.shared.mapBusData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let homeSheetController = HomeSheetController()
        self.present(homeSheetController, animated: true, completion: nil)
        
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            LocationProvider.shared.delegate?.locationProvider(didRequestNavigateToCurrentLocationWith: .one)
        }
        
        checkForUpdates()
    }
}

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        LocationProvider.shared.delegate?.locationProvider(didRequestNavigateToCurrentLocationWith: .one)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        fatalError(error.localizedDescription)
    }
    
}

extension MainViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.red
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return MKPolygonRenderer(overlay: overlay)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    //    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    //
    //    }
    
}

extension MainViewController: LocationProviderDelegate {
    
    func locationProvider(didRequestNavigateTo location: CLLocation, with zoomLevel: ZoomLevel) {
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: zoomLevel.rawValue, longitudinalMeters: zoomLevel.rawValue)
        mapView.setRegion(region, animated: true)
    }
    
    func locationProvider(didRequestNavigateTo annotation: MKAnnotation, with zoomLevel: ZoomLevel) {
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: zoomLevel.rawValue, longitudinalMeters: zoomLevel.rawValue)
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(annotation)
    }
    
    func locationProvider(didRequestNavigateToCurrentLocationWith zoomLevel: ZoomLevel) {
        locationManager.requestLocation()
        let region = MKCoordinateRegion(center: LocationProvider.shared.currentLocation.coordinate.shift, latitudinalMeters: zoomLevel.rawValue, longitudinalMeters: zoomLevel.rawValue)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
    
    func locationProvider(didRequestRouteFrom originBusStop: BusStop, to destinationBusStop: BusStop) {
        let req = MKDirections.Request()
        req.source = MKMapItem(placemark: MKPlacemark(coordinate: originBusStop.coordinate, addressDictionary: nil))
        req.destination = MKMapItem(placemark: MKPlacemark(coordinate: destinationBusStop.coordinate, addressDictionary: nil))
        req.requestsAlternateRoutes = true
        req.transportType = .automobile
        
        let directions = MKDirections(request: req)
        
        directions.calculate { res, err in
            if let res = res, res.routes.count > 0 {
                self.mapView.addOverlay(res.routes[0].polyline)
                self.mapView.setVisibleMapRect(res.routes[0].polyline.boundingMapRect, animated: true)
            }
        }
    }
}
