//
//  UIWindow.swift
//  BuSG
//
//  Created by Ryan The on 14/12/20.
//

import UIKit

enum ToastStyle {
    case regular, danger
}

extension UIWindow {
    
    func presentToast(message: String, image: UIImage? = nil, style: ToastStyle = .regular, duration: Double = 7) {
        if subviews.count > 1 { return }
        let toast = UIView()
        
        var imageView: UIImageView? = nil
        if let image = image {
            imageView = UIImageView(image: image)
            toast.addSubview(imageView!)
            imageView?.translatesAutoresizingMaskIntoConstraints = false
            imageView?.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            NSLayoutConstraint.activate([
                imageView!.leadingAnchor.constraint(equalTo: toast.leadingAnchor, constant: K.margin.large),
                imageView!.centerYAnchor.constraint(equalTo: toast.centerYAnchor),
            ])
        }
        
        let label = UILabel()
        toast.addSubview(label)
        label.text = message
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: imageView?.trailingAnchor ?? toast.leadingAnchor, constant: K.margin.large),
            label.trailingAnchor.constraint(equalTo: toast.trailingAnchor, constant: -K.margin.large),
            label.centerYAnchor.constraint(equalTo: toast.centerYAnchor),
        ])
        
        addSubview(toast)
        toast.layer.cornerRadius = K.cornerRadius
        toast.backgroundColor = .secondarySystemBackground
        toast.transform = CGAffineTransform(translationX: 0, y: 200).scaledBy(x: 0.8, y: 0.8)
        toast.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toast.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -50),
            toast.heightAnchor.constraint(equalToConstant: 50),
            toast.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.margin.large),
            toast.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -K.margin.large),
        ])
        
        switch style {
        case .danger:
            toast.backgroundColor = .systemRed
            label.textColor = .white
            imageView?.tintColor = .white
        case .regular: fallthrough
        default: break
        }
        
        func animateAway() {
            UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                toast.transform = CGAffineTransform(translationX: 0, y: 200).scaledBy(x: 0.8, y: 0.8)
                toast.removeFromSuperview()
            })
        }
        
        let swipeGestureRecogniser = UISwipeGestureRecognizer()
        swipeGestureRecogniser.direction = .down
        toast.addGestureRecognizer(swipeGestureRecogniser) { (sender) -> Void in
            animateAway()
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
            toast.transform = CGAffineTransform(translationX: 0, y: 0).scaledBy(x: 1.0, y: 1.0)
        }, completion: {_ in
            Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in animateAway()}
        })
    }
}
