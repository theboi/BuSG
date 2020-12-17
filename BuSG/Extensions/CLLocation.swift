//
//  CLLocation.swift
//  BuSG
//
//  Created by Ryan The on 17/12/20.
//

import CoreLocation

extension CLLocation {
    
    convenience init(coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}
