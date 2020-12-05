//
//  BusStopAnnotation.swift
//  Navigem
//
//  Created by Ryan The on 5/12/20.
//

import UIKit
import MapKit

class BusStopAnnotation: NSObject, MKAnnotation {
    
    var busStop: BusStop
    
    var coordinate: CLLocationCoordinate2D
    
    init(for busStop: BusStop) {
        self.coordinate = CLLocationCoordinate2D(latitude: busStop.latitude, longitude: busStop.longitude)
        self.busStop = busStop
    }

}
