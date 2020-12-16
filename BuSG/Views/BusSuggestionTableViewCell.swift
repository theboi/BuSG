//
//  BusSuggestedTableViewCell.swift
// BuSG
//
//  Created by Ryan The on 6/12/20.
//

import UIKit

class BusSuggestionTableViewCell: UITableViewCell {
    
    public lazy var serviceNoLabel = UILabel()
    public lazy var eventLabel = UILabel()
    public lazy var destinationLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(serviceNoLabel)
        serviceNoLabel.font = .medium
        serviceNoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            serviceNoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.margin.large),
            serviceNoLabel.topAnchor.constraint(equalTo: topAnchor, constant: K.margin.small),
        ])
        
        addSubview(destinationLabel)
        destinationLabel.font = .detail
        destinationLabel.textColor = .secondaryLabel
        destinationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            destinationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.margin.large),
            destinationLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -K.margin.small),
        ])
        
        addSubview(eventLabel)
        eventLabel.font = .detail
        eventLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            eventLabel.leadingAnchor.constraint(equalTo: serviceNoLabel.trailingAnchor, constant: K.margin.large),
            eventLabel.centerYAnchor.constraint(equalTo: serviceNoLabel.centerYAnchor),
        ])

        backgroundColor = .clear
        selectedBackgroundView = FillView(solidWith: UIColor.label.withAlphaComponent(0.1))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
