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
    
    func presentToast(toast: Toast, duration: Double = 5) {
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
        }, completion: {_ in
            Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in animateAway()}
        })
    }
}

class Toast: UIView {
    
    lazy var imageView: UIImageView? = nil
    lazy var label = UILabel()
    
    init(message: String, image: UIImage? = nil, style: ToastStyle = .regular) {
        super.init(frame: CGRect())
        
        var imageView: UIImageView? = nil
        if let image = image {
            imageView = UIImageView(image: image)
            addSubview(imageView!)
            imageView?.translatesAutoresizingMaskIntoConstraints = false
            imageView?.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            NSLayoutConstraint.activate([
                imageView!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.margin.large),
                imageView!.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
        }
        
        let label = UILabel()
        addSubview(label)
        label.text = message
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: imageView?.trailingAnchor ?? leadingAnchor, constant: K.margin.large),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -K.margin.large),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        layer.cornerRadius = K.cornerRadius
        backgroundColor = .secondarySystemBackground
        
        switch style {
        case .danger:
            backgroundColor = .systemRed
            label.textColor = .white
            imageView?.tintColor = .white
        case .regular: fallthrough
        default: break
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
