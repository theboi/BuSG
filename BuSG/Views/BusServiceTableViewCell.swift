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
    
    public lazy var blockLabel = UILabel()
    public lazy var streetLabel = UILabel()
    public lazy var busStopCodeLabel = UILabel()
    public lazy var blockImage = UIImageView()
    public var stackView: UIStackView!
    public lazy var errorLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        addSubview(blockLabel)
        blockLabel.font = .detail
        blockLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blockLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.margin.large),
            blockLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            blockLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -26)
        ])
        
        addSubview(busStopCodeLabel)
        busStopCodeLabel.font = .detail
        busStopCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            busStopCodeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.margin.large),
            busStopCodeLabel.topAnchor.constraint(equalTo: blockLabel.bottomAnchor, constant: 2)
        ])

        addSubview(streetLabel)
        streetLabel.font = streetLabel.font.withSize(12)
        streetLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            streetLabel.leadingAnchor.constraint(equalTo: busStopCodeLabel.trailingAnchor, constant: 7),
            streetLabel.topAnchor.constraint(equalTo: blockLabel.bottomAnchor, constant: 2)
        ])

        backgroundColor = .clear
        selectedBackgroundView = FillView(solidWith: UIColor.label.withAlphaComponent(0.1))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
