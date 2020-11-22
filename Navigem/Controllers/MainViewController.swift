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
        let sheetA = SheetViewController()
        let sheetB = SheetViewController()
        self.present(sheetA, animated: true, completion: nil)
        sheetA.present(sheetB, animated: true, completion: nil)
    }
}
