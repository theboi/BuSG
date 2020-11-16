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
        blurBackground()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func blurBackground() {
        if !UIAccessibility.isReduceTransparencyEnabled {
            view.backgroundColor = .clear

            let blurEffect = UIBlurEffect(style: .systemMaterial)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)

            blurEffectView.frame = self.view.bounds
            blurEffectView.layer.cornerRadius = K.cornerRadius
            blurEffectView.layer.masksToBounds = true
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            view.addSubview(blurEffectView)
        } else {
            view.backgroundColor = .systemBackground
        }
    }
    
    override func didMove(toParent parent: UIViewController?) {
        
    }
}
