//
//  UIWindow.swift
//  BuSG
//
//  Created by Ryan The on 14/12/20.
//

import UIKit

extension UIWindow {
    
    func present(_ toast: Toast, duration: Double = 5) {
        if subviews.filter({ $0 is Toast }).count > 0 { return }
        
        addSubview(toast)
        
        toast.transform = CGAffineTransform(translationX: 0, y: 200).scaledBy(x: 0.8, y: 0.8)
        toast.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toast.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -50),
            toast.heightAnchor.constraint(equalToConstant: 50),
            toast.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.margin.large),
            toast.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -K.margin.large),
        ])
        
        func animateAway() {
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                toast.transform = CGAffineTransform(translationX: 0, y: 200).scaledBy(x: 0.8, y: 0.8)
            }) { _ in
                toast.removeFromSuperview()
            }
        }
        
        let swipeGestureRecogniser = UISwipeGestureRecognizer()
        swipeGestureRecogniser.direction = .down
        toast.addGestureRecognizer(swipeGestureRecogniser) { (sender) -> Void in
            animateAway()
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
            toast.transform = CGAffineTransform(translationX: 0, y: 0).scaledBy(x: 1.0, y: 1.0)
        }, completion: { _ in
            Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in animateAway()}
        })
    }
}
