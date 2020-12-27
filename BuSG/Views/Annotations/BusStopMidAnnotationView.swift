//
//  BusStopMidAnnotationView.swift
//  BuSG
//
//  Created by Ryan The on 27/12/20.
//

import MapKit

class BusStopMidAnnotationView: MKAnnotationView, BusStopAnnotationView {
    
    public lazy var roadNameLabel = UILabel()
    
    public lazy var busStopCodeLabel = UILabel()
    
    private lazy var stackView = UIStackView(arrangedSubviews: [roadNameLabel, busStopCodeLabel])
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        let layer = CALayer()
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemRed.cgColor
        image = layer.image
        
        canShowCallout = true
        
        stackView.axis = .vertical
        detailCalloutAccessoryView = stackView
    }
    
}
