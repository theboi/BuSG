//
//  BottomSheetViewController.swift
//  Navigem
//
//  Created by Ryan The on 16/11/20.
//

import UIKit

class BottomSheetViewController: UIViewController {
    private enum SizeState {
        case mini, half, max
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        
    }
}
