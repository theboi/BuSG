//
//  MainViewController.swift
//  Navigem
//
//  Created by Ryan The on 16/11/20.
//

import UIKit
import MapKit

class MainViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .blue//.systemBackground
//        let mapView = MKMapView()
//        self.view = mapView
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createBottomSheet()
    }
    
    private func createBottomSheet() {
        let sheetA = SheetController()
        self.present(sheetA, animated: true, completion: nil)
        
    }
}
