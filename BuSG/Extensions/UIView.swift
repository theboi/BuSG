//
//  UIView.swift
//  BuSG
//
//  Created by Ryan The on 14/12/20.
//

import UIKit

extension UIView {

    private struct AssociatedObjectKeys {
        static var gestureRecognizer = "gestureRecognizer"
    }

    private typealias Action = ((_ sender: UIGestureRecognizer) -> Void)?
    
    private var gestureRecognizerAction: Action? {
        set {
            if let newValue = newValue {
                // Computed properties get stored as associated objects
                objc_setAssociatedObject(self, &AssociatedObjectKeys.gestureRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            }
        }
        get {
            let gestureRecognizerActionInstance = objc_getAssociatedObject(self, &AssociatedObjectKeys.gestureRecognizer) as? Action
            return gestureRecognizerActionInstance
        }
    }

    public func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, action: ((_ sender: UIGestureRecognizer) -> Void)?) {
        self.isUserInteractionEnabled = true
        self.gestureRecognizerAction = action
        gestureRecognizer.addTarget(self, action: #selector(handleGesture))
        self.addGestureRecognizer(gestureRecognizer)
    }

    @objc private func handleGesture(sender: UIGestureRecognizer) {
        if let action = self.gestureRecognizerAction {
            action?(sender)
        }
    }

}
