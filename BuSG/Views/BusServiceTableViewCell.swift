//
//  BusServiceTableViewCell.swift
//  BuSG
//
//  Created by Ryan The on 18/12/20.
//

import UIKit

class BusServiceTableViewCell: UITableViewCell {
        
    public lazy var serviceNoLabel = UILabel()
    public lazy var destinationDirectionImageView = UIImageView()
    public lazy var destinationLabel = UILabel()
    
    public var busService: BusService? {
        didSet {
            destinationDirectionImageView.image = UIImage(systemName: busService?.originCode == busService?.destinationCode ? "arrow.clockwise" : "arrow.right")
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(serviceNoLabel)
        serviceNoLabel.translatesAutoresizingMaskIntoConstraints = false
        serviceNoLabel.font = .large
        NSLayoutConstraint.activate([
            serviceNoLabel.topAnchor.constraint(equalTo: topAnchor, constant: K.margin.small),
            serviceNoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.margin.large),
        ])
        
        addSubview(destinationDirectionImageView)
        destinationDirectionImageView.preferredSymbolConfiguration = .init(font: .detail)
        destinationDirectionImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            destinationDirectionImageView.heightAnchor.constraint(equalToConstant: 15),
            destinationDirectionImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -K.margin.small),
            destinationDirectionImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.margin.large),
        ])
        
        addSubview(destinationLabel)
        destinationLabel.font = .detail
        destinationLabel.textColor = .secondaryLabel
        destinationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            destinationLabel.leadingAnchor.constraint(equalTo: destinationDirectionImageView.trailingAnchor, constant: K.margin.small),
            destinationLabel.centerYAnchor.constraint(equalTo: destinationDirectionImageView.centerYAnchor),
        ])
        
        backgroundColor = .clear
        selectedBackgroundView = FillView(solidWith: UIColor.label.withAlphaComponent(0.1))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
