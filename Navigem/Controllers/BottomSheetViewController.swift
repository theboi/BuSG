//
//  BottomSheetViewController.swift
//  Navigem
//
//  Created by Ryan The on 16/11/20.
//

import UIKit

enum SheetState: CGFloat {
    case mini, half, max
}

class BottomSheetViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var tableView: UITableView?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onSlideDown(_:)))
        let panGestureDelegate = self
        panGesture.delegate = panGestureDelegate
        
        self.view.addGestureRecognizer(panGesture)
        blurBackground()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateView(with: .half)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func blurBackground() {
        if !UIAccessibility.isReduceTransparencyEnabled {
            view.backgroundColor = .clear
            view.layer.cornerRadius = K.cornerRadius
            view.layer.masksToBounds = true
            
            let blurEffect = UIBlurEffect(style: .systemMaterial)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            view.addSubview(blurEffectView)
        } else {
            view.backgroundColor = .systemBackground
        }
    }
    
    private func updateView(with state: SheetState) {
        switch state {
        case .mini: fallthrough
        default:
            UIView.animate(withDuration: 5, animations: {
                self.view.frame = CGRect(x: K.margin.small, y: 100, width: (UIScreen.main.bounds.width)-K.margin.small*2, height: 100)
            })
        }
    }
    
    private func updateView(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let minY = view.frame.minY
        
        if (minY + translation.y >= getSheetSize(for: .max)) && (minY + translation.y <= getSheetSize(for: .half)) {
            view.frame = CGRect(x: 0, y: minY + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: view)
        }
    }
    
    @objc func onSlideDown(_ sender: UIPanGestureRecognizer) {
        updateView(recognizer: sender)
        
        if sender.state == .ended {
            UIView.animate(withDuration: 1, delay: 0.0, options: [.allowUserInteraction], animations: {})
        }
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
    
    private func getSheetSize(for state: SheetState) -> CGFloat {
        switch state {
        case .mini: return 10
        case .max: return UIScreen.main.bounds.height - 130
        case .half: fallthrough
        default: return 100
        }
    }
    
    private func getSheetRect(with height: CGRect) {
        
    }
}
