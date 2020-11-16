//
//  MainViewController.swift
//  Navigem
//
//  Created by Ryan The on 16/11/20.
//

import UIKit

class MainViewController: UIViewController {

    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createBottomSheet()
    }
    
    private func createBottomSheet() {
        let bottomSheetVC = BottomSheetViewController()
        self.addChild(bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParent: self)
        
        let width = view.frame.width
        let height = view.frame.height-100
        bottomSheetVC.view.frame = CGRect(x: K.margin.small, y: 100, width: width-K.margin.small*2, height: height)
    }
}
