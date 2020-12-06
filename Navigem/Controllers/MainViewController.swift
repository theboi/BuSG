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
    
    var currentlyPresentingSheetController: SheetController?
        
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .systemBackground
        
        self.view = mapView
        
        locationManager.delegate = self
        mapView.delegate = self
        LocationProvider.shared.delegate = self
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "busStop")
        let segmentedControl = UISegmentedControl(items: [
            UIImage(systemName: "location"),
            UIImage(systemName: "location"),
        ])
        
        mapView.addSubview(segmentedControl)
        
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
        
        /// Show Apple Maps logo and legal notice when sheet at min state
        mapView.layoutMargins.bottom = 40
        mapView.layoutMargins.top = 40
        
        checkForUpdates()
    }
    
    private func clearMapView() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
    }
}

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        LocationProvider.shared.delegate?.locationProvider(didRequestNavigateToCurrentLocationWith: .one)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        fatalError(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
}

extension MainViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.systemGreen
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return MKPolygonRenderer(overlay: overlay)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        switch annotation {
        case let annotation as BusStopAnnotation:
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "busStop", for: annotation) as? MKMarkerAnnotationView
            annotationView?.glyphImage = UIImage(systemName: "building")
            annotationView?.markerTintColor = .systemRed
            annotationView?.canShowCallout = true
            let roadNameLabel = UILabel()
            roadNameLabel.text = annotation.busStop.roadDesc
            let busStopCodeLabel = UILabel()
            busStopCodeLabel.text = annotation.busStop.busStopCode
            let stack = UIStackView(arrangedSubviews: [roadNameLabel, busStopCodeLabel])
            stack.axis = .vertical
            annotationView?.detailCalloutAccessoryView = stack
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure, primaryAction: UIAction(handler: { _ in
                self.currentlyPresentingSheetController?.present(BusStopSheetController(for: annotation.busStop.busStopCode), animated: true)
            }))

            return annotationView
        default:
            return nil
        }
    }
    
}

extension MainViewController: LocationProviderDelegate {
    
    func locationProvider(didRequestNavigateTo location: CLLocation, with zoomLevel: ZoomLevel) {
        let region = MKCoordinateRegion(center: location.coordinate.shift, latitudinalMeters: zoomLevel.rawValue, longitudinalMeters: zoomLevel.rawValue)
        mapView.setRegion(region, animated: true)
    }
    
    func locationProvider(didRequestNavigateTo annotation: MKAnnotation, with zoomLevel: ZoomLevel) {
        let region = MKCoordinateRegion(center: annotation.coordinate.shift, latitudinalMeters: zoomLevel.rawValue, longitudinalMeters: zoomLevel.rawValue)
        mapView.setRegion(region, animated: true)
        self.clearMapView()
        mapView.addAnnotation(annotation)
    }
    
    func locationProvider(didRequestNavigateToCurrentLocationWith zoomLevel: ZoomLevel) {
        locationManager.requestLocation()
        let region = MKCoordinateRegion(center: LocationProvider.shared.currentLocation.coordinate.shift, latitudinalMeters: zoomLevel.rawValue, longitudinalMeters: zoomLevel.rawValue)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
    
    func locationProvider(didRequestRouteFor busService: BusService, in direction: Int64) {
        let busStops = busService.busStops.filter { (busStop) -> Bool in
            busStop.accessorBusRoute?.direction == direction ? true : false
        }.sorted { (prevBusStop, nextBusStop) -> Bool in
            if let prevBusRoute = prevBusStop.accessorBusRoute, let nextBusRoute = nextBusStop.accessorBusRoute {
                return prevBusRoute.stopSequence < nextBusRoute.stopSequence
            }
            return false
        }
        
        self.clearMapView()
        
        for (index, _) in busStops.enumerated().dropLast() {
            if index%K.busStopRoutingSkip==0 || index == 0 || index == (busStops.count-1) {
                let skip = index+K.busStopRoutingSkip >= busStops.count-1 ? busStops.count-1-index : K.busStopRoutingSkip
                let req = MKDirections.Request()
                req.source = MKMapItem(placemark: MKPlacemark(coordinate: busStops[index].coordinate, addressDictionary: nil))
                req.destination = MKMapItem(placemark: MKPlacemark(coordinate: busStops[index+skip].coordinate, addressDictionary: nil))
                req.transportType = .automobile
                MKDirections(request: req).calculate { res, _ in
                    if let res = res {
                        self.mapView.addOverlay(res.routes[0].polyline)
                    } else {
                        print("STRAIGHT TIME")
                        let polylineMax = index+K.busStopRoutingSkip > busStops.count-1 ? busStops.count-1-index : K.busStopRoutingSkip
                        print(Array(0...polylineMax))
                        let polylineCoords = Array(0...polylineMax).map { (num) -> CLLocationCoordinate2D in
                            busStops[index+num].coordinate
                        }
                        self.mapView.addOverlay(MKPolyline(coordinates: polylineCoords, count: polylineMax+1))
                    }
                }
            }
        }
        
        busStops.forEach { busStop in
            self.mapView.addAnnotation(BusStopAnnotation(for: busStop))
        }
        
        self.mapView.fitAll()
    }
}
