//
//  BottomSheetViewController.swift
//  Navigem
//
//  Created by Ryan The on 16/11/20.
//

import UIKit

enum SheetState: CGFloat {
    case min, half, max
}

class BottomSheetViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var tableView: UITableView?
    var screenBounds: CGRect {
        UIScreen.main.bounds
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onSlideDown(_:)))
        let panGestureDelegate = self
        panGesture.delegate = panGestureDelegate
        
        self.view.addGestureRecognizer(panGesture)
        styleSheet()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateSize(for: .half)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func styleSheet() {
        view.layer.cornerRadius = K.cornerRadius
        view.layer.masksToBounds = true
        if !UIAccessibility.isReduceTransparencyEnabled {
            view.backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: .systemMaterial)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            view.addSubview(blurEffectView)
        } else {
            view.backgroundColor = .systemBackground
        }
    }
    
    private func updateSize(for state: SheetState) {
        let height = getSheetHeight(for: state)
        
        self.view.frame = getSheetRect(with: height)
    }
    
    private func updateView(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let height = view.frame.height-translation.y
        
        print(height)
        //        if (currentHeight >= screenBounds.height-getSheetHeight(for: .max)) && (minY + translation.y <= screenBounds.height-getSheetHeight(for: .half)) {
        //
        //        }
        view.frame = getSheetRect(with: height)
        //CGRect(x: 0, y: screenBounds.height-height, width: view.frame.width, height: height)
        recognizer.setTranslation(CGPoint.zero, in: view)
    }
    
    @objc func onSlideDown(_ sender: UIPanGestureRecognizer) {
        updateView(recognizer: sender)
        //
        //        if sender.state == .ended {
        //            UIView.animate(withDuration: 1, delay: 0.0, options: [.allowUserInteraction], animations: {})
        //        }
    }
    
    //    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    //        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
    //        let direction = gesture.velocity(in: view).y
    //
    //        let y = view.frame.minY
    //        if (y == fullView && tableView.contentOffset.y == 0 && direction > 0) || (y == partialView) {
    //            tableView.isScrollEnabled = false
    //        } else {
    //            tableView.isScrollEnabled = true
    //        }
    //
    //        return false
    //    }
    
    private func getSheetHeight(for state: SheetState) -> CGFloat {
        switch state {
        case .max: return UIScreen.main.bounds.height-100
        case .min: return 100
        case .half: fallthrough
        default: return 500
        }
    }
    
    private func getSheetRect(with height: CGFloat) -> CGRect {
        return CGRect(x: K.margin.small, y: screenBounds.height-height, width: screenBounds.width-K.margin.small*2, height: height)
    }
}
