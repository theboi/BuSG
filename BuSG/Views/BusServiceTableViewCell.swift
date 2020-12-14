//
//  BusStopTableViewCell.swift
//  Navigem
//
//  Created by Ryan The on 4/12/20.
//

import UIKit

enum BusStopData {
    case arr
    case left
    case mins(Int)
}

class BusServiceTableViewCell: UITableViewCell {
    
    public lazy var busStopCodeLabel = UILabel()
    public lazy var roadDescLabel = UILabel()
    public lazy var roadNameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        addSubview(roadDescLabel)
        roadDescLabel.font = .medium
        roadDescLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roadDescLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.margin.large),
            roadDescLabel.topAnchor.constraint(equalTo: topAnchor, constant: K.margin.small),
        ])
        
        addSubview(busStopCodeLabel)
        busStopCodeLabel.font = .detail
        busStopCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            busStopCodeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.margin.large),
            busStopCodeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -K.margin.small),
        ])
        
        addSubview(roadNameLabel)
        roadNameLabel.font = .detail
        roadNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roadNameLabel.leadingAnchor.constraint(equalTo: busStopCodeLabel.trailingAnchor, constant: 7),
            roadNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -K.margin.small),
        ])

        backgroundColor = .clear
        selectedBackgroundView = FillView(solidWith: UIColor.label.withAlphaComponent(0.1))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
