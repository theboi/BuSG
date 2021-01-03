//
//  CLLocationCoordinate2D.swift
//   BuSG
//
//  Created by Ryan The on 5/12/20.
//

import CoreLocation

extension CLLocationCoordinate2D {
    
    /// Utility function that returns a given `CLLocationCoordinate2D` but shifted up slightly to prevent from being covered by by sheet.
    func shift(by span: CLLocationDistance = 0) -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude-0.0038*span/500, longitude: longitude)
    }
    
}
