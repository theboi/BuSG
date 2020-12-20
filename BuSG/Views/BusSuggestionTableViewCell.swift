//
//  BusSuggestedTableViewCell.swift
//   BuSG
//
//  Created by Ryan The on 6/12/20.
//

import UIKit

class BusSuggestionTableViewCell: UITableViewCell {
    
    public var eventImage: UIImage? {
        didSet {
            eventImageView.image = eventImage
        }
    }
    
    private var eventImageView = UIImageView()
    
    public lazy var serviceNoLabel = UILabel()
    public lazy var eventLabel = UILabel()
    public lazy var destinationLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(eventImageView)
        eventImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            eventImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.margin.two),
            eventImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        addSubview(serviceNoLabel)
        serviceNoLabel.font = .medium
        serviceNoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            serviceNoLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: K.margin.two),
            serviceNoLabel.topAnchor.constraint(equalTo: topAnchor, constant: K.margin.one),
        ])
        
        addSubview(destinationLabel)
        destinationLabel.font = .detail
        destinationLabel.textColor = .secondaryLabel
        destinationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            destinationLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: K.margin.two),
            destinationLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -K.margin.one),
        ])
        
        addSubview(eventLabel)
        eventLabel.font = .detail
        eventLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            eventLabel.leadingAnchor.constraint(equalTo: serviceNoLabel.trailingAnchor, constant: K.margin.two),
            eventLabel.centerYAnchor.constraint(equalTo: serviceNoLabel.centerYAnchor),
        ])

        backgroundColor = .clear
        selectedBackgroundView = FillView(solidWith: UIColor.label.withAlphaComponent(0.1))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
