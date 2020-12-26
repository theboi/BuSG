//
//  Toast.swift
//  BuSG
//
//  Created by Ryan The on 14/12/20.
//

import UIKit

enum ToastStyle {
    case regular, danger
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
                imageView!.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.sizes.margin.two),
                imageView!.centerYAnchor.constraint(equalTo: centerYAnchor),
            ])
        }
        
        let label = UILabel()
        addSubview(label)
        label.text = message
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: imageView?.trailingAnchor ?? leadingAnchor, constant: K.sizes.margin.two),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -K.sizes.margin.two),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        layer.cornerRadius = K.cornerRadius
        
        switch style {
        case .danger:
            backgroundColor = .systemRed
            label.textColor = .white
            imageView?.tintColor = .white
        case .regular: fallthrough
        default:
            backgroundColor = .tertiarySystemBackground
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
