//
//  ListViewHeaderFooter.swift
//  BuSG
//
//  Created by Ryan The on 17/12/20.
//

import UIKit

class ListViewHeaderFooterView: UITableViewHeaderFooterView {
    
    public lazy var header = UILabel()
    public var trailingButton = UIButton(frame: .zero) {
        willSet {
            trailingButton.removeFromSuperview()
        }
        didSet {
            addSubview(trailingButton)
            trailingButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                trailingButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -K.sizes.margin.two),
                trailingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -K.sizes.margin.twoAndHalf),
            ])
        }
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(header)
        header.font = .regularHeader
        header.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            header.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -K.sizes.margin.two),
            header.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.sizes.margin.twoAndHalf),
            header.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -K.sizes.margin.twoAndHalf),
        ])
        
//        addSubview(trailingButton)
//        trailingButton.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            trailingButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -K.margin.large),
//            trailingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -K.margin.extraLarge),
//        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
