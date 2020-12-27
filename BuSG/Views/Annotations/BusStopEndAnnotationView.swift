//
//  BusRouteEndAnnotationView.swift
//  BuSG
//
//  Created by Ryan The on 27/12/20.
//

import MapKit

protocol BusStopAnnotationView {
    
    var roadNameLabel: UILabel { get set }
    
    var busStopCodeLabel: UILabel { get set }
    
}

class BusStopEndAnnotationView: MKMarkerAnnotationView, BusStopAnnotationView {
        
    public lazy var roadNameLabel = UILabel()
    
    public lazy var busStopCodeLabel = UILabel()
    
    private lazy var stackView = UIStackView(arrangedSubviews: [roadNameLabel, busStopCodeLabel])
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        glyphImage = UIImage(systemName: "building")
        markerTintColor = .systemRed
        canShowCallout = true
        let layer = CALayer()
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemRed.cgColor
        image = layer.image
        
        
        stackView.axis = .vertical
        detailCalloutAccessoryView = stackView
    }
    
}
