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
    
    lazy var locationManager = CLLocationManager()
    
    var currentLocation: CLLocation {
        locationManager.location ?? CLLocation(latitude: 0, longitude: 0)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .systemBackground
                
        //self.view = mapView
        locationManager.delegate = self
        mapView.delegate = self
        
        // TODO: MOVE INTO LAUNCH
        checkForUpdates()
    }
    
    private func checkForUpdates() {
        let nowEpoch = Date().timeIntervalSince1970
        let lastOpenedEpoch = UserDefaults.standard.double(forKey: K.userDefaults.lastOpenedEpoch)
        let lastUpdatedEpoch = UserDefaults.standard.double(forKey: K.userDefaults.lastUpdatedEpoch)
    
        print(nowEpoch, lastOpenedEpoch)
        if lastOpenedEpoch == 0 {
            print("First Timer!")
            // First time using app
            let vc = UIViewController()
            vc.view.backgroundColor = .red
            self.present(vc, animated: true)
        }
        
        if lastUpdatedEpoch+604800 < nowEpoch { // 1 week = 604800 seconds
            // Requires update of bus data
            print("Updating Bus Data...")
            ApiProvider.shared.updateBusData() {
                UserDefaults.standard.setValue(nowEpoch, forKey: K.userDefaults.lastUpdatedEpoch)
            }
        }
        
        UserDefaults.standard.setValue(nowEpoch, forKey: K.userDefaults.lastOpenedEpoch)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.present(HomeSheetController(), animated: true, completion: nil)
        
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            navigateToCurrentLocation()
        }
    }
    
    private func navigateToCurrentLocation() {
        locationManager.requestLocation()
        let region = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(region, animated: true)
    }
}

extension MainViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        navigateToCurrentLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODO: CATCH
        print("ERROR", error)
    }
}
