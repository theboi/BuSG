//
//  MKMapView.swift
// BuSG
//
//  Created by Ryan The on 5/12/20.
//

import MapKit

extension MKMapView {
    
    /// Utility function to zoom view to fit all annotations provided
    func fitAll(in annotations: [MKAnnotation]? = nil) {
        let fitAnnotations = annotations ?? self.annotations
        var zoomRect = MKMapRect.null;
        for annotation in fitAnnotations {
            let annotationPoint = MKMapPoint(annotation.coordinate)
            let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0.01, height: 0.01);
            zoomRect = zoomRect.union(pointRect);
        }
        setVisibleMapRect(zoomRect, edgePadding: K.mapView.edgePadding, animated: true)
    }
    
}
