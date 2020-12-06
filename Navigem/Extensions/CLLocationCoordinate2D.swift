//
//  CLLocationCoordinate2D.swift
//  Navigem
//
//  Created by Ryan The on 5/12/20.
//

import CoreLocation

extension CLLocationCoordinate2D {
    
    /// Utility computed property to return a given `CLLocationCoordinate2D` but shifted up slightly to prevent from being covered by by sheet.
    var shift: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude-0.0017, longitude: longitude)
    }
    
}
