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
    
    var currentlyPresentingSheetController: SheetController? {
        var topSheetController: SheetController = sheetController
        while let sheetController = topSheetController.presentedSheetController {
            topSheetController = sheetController
        }
        return topSheetController
    }
    
    var sheetController = HomeSheetController()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .systemBackground
        
        self.view = mapView
        
        locationManager.delegate = self
        mapView.delegate = self
        LocationProvider.shared.delegate = self
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "busStop")
        
        let stackButtons = [
            UIButton(type: .roundedRect, primaryAction: UIAction(handler: { _ in
                self.present(UINavigationController(rootViewController: SettingsViewController()), animated: true)
            })),
            UIButton(type: .roundedRect, primaryAction: UIAction(handler: { _ in
                LocationProvider.shared.delegate?.locationProviderDidRequestNavigateToCurrentLocation()
            }))
        ]
        
        stackButtons.enumerated().forEach { (index, button) in
            if let imageView = button.imageView {
                button.bringSubviewToFront(imageView)
            }
            
            if !UIAccessibility.isReduceTransparencyEnabled {
                button.backgroundColor = .clear
                
                let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
                blurEffectView.isUserInteractionEnabled = false // allows button to be clicked
                blurEffectView.frame = button.bounds
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                
                button.insertSubview(blurEffectView, at: 0)
            } else {
                button.backgroundColor = .systemBackground
            }
        }
        stackButtons[0].setImage(UIImage(systemName: "gear"), for: .normal)
        stackButtons[1].setImage(UIImage(systemName: "location"), for: .normal)
        
        let stackView = UIStackView(arrangedSubviews: stackButtons)
        
        stackView.layer.cornerRadius = K.cornerRadius
        stackView.clipsToBounds = true
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        mapView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -K.margin.large),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            stackView.widthAnchor.constraint(equalToConstant: 50),
            stackView.heightAnchor.constraint(equalToConstant: 100),
        ])
        
        /// Move compass below stackview
        mapView.showsCompass = false
        let compassButton = MKCompassButton(mapView: mapView)
        mapView.addSubview(compassButton)
        compassButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            compassButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -K.margin.large),
            compassButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: K.margin.large),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func checkForUpdates() {
        UserDefaults.standard.setValue(0, forKey: K.userDefaults.lastOpenedEpoch)

        let nowEpoch = Date().timeIntervalSince1970
        let lastOpenedEpoch = UserDefaults.standard.double(forKey: K.userDefaults.lastOpenedEpoch)
        let lastUpdatedEpoch = UserDefaults.standard.double(forKey: K.userDefaults.lastUpdatedEpoch)

        if lastOpenedEpoch == 0 {
            print("First Timer!")
            /// First time using app
            self.present(LaunchViewController(), animated: true)
        }
        
        if lastUpdatedEpoch+604800 < nowEpoch { // 1 week = 604800 seconds
            /// Requires update of bus data
            print("Updating Bus Data...")
            ApiProvider.shared.updateStaticData() {
                UserDefaults.standard.setValue(nowEpoch, forKey: K.userDefaults.lastUpdatedEpoch)
            }
        }
        UserDefaults.standard.setValue(nowEpoch, forKey: K.userDefaults.lastOpenedEpoch)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.present(sheetController, animated: true)
        
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            LocationProvider.shared.delegate?.locationProviderDidRequestNavigateToCurrentLocation()
        }
        
        checkForUpdates()
    }
    
    private func clearMapView() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
    }
}

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        LocationProvider.shared.delegate?.locationProviderDidRequestNavigateToCurrentLocation()
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
            polylineRenderer.strokeColor = .systemGreen
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
    
    func locationProvider(didRequestNavigateTo location: CLLocation) {
        let region = MKCoordinateRegion(center: location.coordinate.shift, latitudinalMeters: K.mapView.span, longitudinalMeters: K.mapView.span)
        mapView.setRegion(region, animated: true)
    }
    
    func locationProvider(didRequestNavigateTo annotation: MKAnnotation) {
        let region = MKCoordinateRegion(center: annotation.coordinate.shift, latitudinalMeters: K.mapView.span, longitudinalMeters: K.mapView.span)
        mapView.setRegion(region, animated: true)
        self.clearMapView()
        mapView.addAnnotation(annotation)
    }
    
    func locationProviderDidRequestNavigateToCurrentLocation() {
        locationManager.requestLocation()
        let region = MKCoordinateRegion(center: LocationProvider.shared.currentLocation.coordinate.shift, latitudinalMeters: K.mapView.span, longitudinalMeters: K.mapView.span)
        mapView.setRegion(region, animated: true)
        self.clearMapView()
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
                MKDirections(request: req).calculate { res, err in
                    if let res = res {
                        self.mapView.addOverlay(res.routes[0].polyline)
                    } else {
                        let polylineMax = index+K.busStopRoutingSkip > busStops.count-1 ? busStops.count-1-index : K.busStopRoutingSkip
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
