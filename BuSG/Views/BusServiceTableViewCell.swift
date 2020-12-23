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
        
        contentView.addSubview(serviceNoLabel)
        serviceNoLabel.translatesAutoresizingMaskIntoConstraints = false
        serviceNoLabel.font = .large
        NSLayoutConstraint.activate([
            serviceNoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: K.margin.one),
            serviceNoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: K.margin.two),
        ])
        
        contentView.addSubview(destinationDirectionImageView)
        destinationDirectionImageView.preferredSymbolConfiguration = .init(font: .detail)
        destinationDirectionImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            destinationDirectionImageView.heightAnchor.constraint(equalToConstant: 15),
            destinationDirectionImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -K.margin.one),
            destinationDirectionImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: K.margin.two),
        ])
        
        contentView.addSubview(destinationLabel)
        destinationLabel.font = .detail
        destinationLabel.textColor = .secondaryLabel
        destinationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            destinationLabel.leadingAnchor.constraint(equalTo: destinationDirectionImageView.trailingAnchor, constant: K.margin.one),
            destinationLabel.centerYAnchor.constraint(equalTo: destinationDirectionImageView.centerYAnchor),
        ])
        
        backgroundColor = .clear
        selectedBackgroundView = FillView(solidWith: UIColor.label.withAlphaComponent(0.1))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
