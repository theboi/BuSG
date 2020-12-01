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
        self.view.backgroundColor = .systemBackground
        
        let updateDataButton = UIButton(type: .roundedRect, primaryAction: UIAction(handler: { (action) in
            Provider.shared.updateBusData()
        }))
        updateDataButton.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
        updateDataButton.backgroundColor = .red
        view.addSubview(updateDataButton)
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
        self.present(HomeSheetController(), animated: true, completion: nil)
    }
}
