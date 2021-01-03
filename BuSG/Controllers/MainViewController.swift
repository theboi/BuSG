//
//  MainViewController.swift
//   BuSG
//
//  Created by Ryan The on 16/11/20.
//

import UIKit
import MapKit

class MainViewController: UIViewController {
    
    lazy var mapView = MKMapView()
    
    var sheetController = HomeSheetController()
    
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
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = mapView
        view.backgroundColor = .systemBackground
        
        locationManager.delegate = self
        mapView.delegate = self
        LocationProvider.shared.delegate = self
        
        mapView.register(BusStopEndAnnotationView.self, forAnnotationViewWithReuseIdentifier: K.identifiers.busStopEndAnnotation)
        mapView.register(BusStopMidAnnotationView.self, forAnnotationViewWithReuseIdentifier: K.identifiers.busStopMidAnnotation)
        
        let stackButtons = [
            UIButton(type: .roundedRect, primaryAction: UIAction(handler: { _ in
                self.present(UINavigationController(rootViewController: SettingsViewController()), animated: true)
            })),
            UIButton(type: .roundedRect, primaryAction: UIAction(handler: { _ in
                LocationProvider.shared.delegate?.locationProvider(didRequestNavigateToCurrentLocationAnimated: true)
            }))
        ]
        
        stackButtons.enumerated().forEach { (index, button) in
            if let imageView = button.imageView {
                button.bringSubviewToFront(imageView)
            }
            
            if !UIAccessibility.isReduceTransparencyEnabled {
                button.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.7)
                
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
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -K.sizes.margin.two),
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
            compassButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -K.sizes.margin.two),
            compassButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: K.sizes.margin.two),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        present(sheetController, animated: true)
        
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            LocationProvider.shared.delegate?.locationProvider(didRequestNavigateToCurrentLocationAnimated: true)
        }
    }
    
    private func clearMapView() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
    }
}

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        LocationProvider.shared.delegate?.locationProvider(didRequestNavigateToCurrentLocationAnimated: false)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODO
        print(error.localizedDescription)
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
            //annotation.isEnds
//            annotation.isEnds ? (mapView.dequeueReusableAnnotationView(withIdentifier: K.identifiers.busStopMidAnnotation, for: annotation)) as! BusStopMidAnnotationView
//            : 
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: K.identifiers.busStopEndAnnotation, for: annotation) as! BusStopEndAnnotationView
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure, primaryAction: UIAction(handler: { _ in
                self.currentlyPresentingSheetController?.present(BusArrivalSheetController(for: annotation.busStop), animated: true)
            }))
            annotationView.roadNameLabel.text = annotation.busStop.roadDesc
            annotationView.busStopCodeLabel.text = annotation.busStop.busStopCode
            return annotationView
        default:
            return nil
        }
    }
    
}

extension MainViewController: LocationProviderDelegate {
    
    func locationProvider(didRequestNavigateTo location: CLLocation) {
        let region = MKCoordinateRegion(center: location.coordinate.shift(), latitudinalMeters: K.mapView.span, longitudinalMeters: K.mapView.span)
        mapView.setRegion(region, animated: true)
    }
    
    func locationProvider(didRequestNavigateTo annotation: MKAnnotation) {
        let region = MKCoordinateRegion(center: annotation.coordinate.shift(), latitudinalMeters: K.mapView.span, longitudinalMeters: K.mapView.span)
        mapView.setRegion(region, animated: true)
        self.clearMapView()
        mapView.addAnnotation(annotation)
    }
    
    func locationProvider(didRequestNavigateToCurrentLocationAnimated animated: Bool) {
        locationManager.requestLocation()
        let span = LocationProvider.shared.currentLocation == nil ? K.mapView.defaultSpan : K.mapView.span
        let region = MKCoordinateRegion(center: (LocationProvider.shared.currentLocation ?? K.mapView.defaultLocation).coordinate.shift(by: span), latitudinalMeters: span, longitudinalMeters: span)
        mapView.setRegion(region, animated: animated)
        self.clearMapView()
        mapView.showsUserLocation = true
    }
    
    func locationProvider(didRequestRouteFor busService: BusService) {
        let busStops = busService.busStops

        self.clearMapView()

        for index in 0...busStops.dropLast().count-1 {
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
