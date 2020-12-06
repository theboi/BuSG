//
//  BusStopTableViewCell.swift
//  Navigem
//
//  Created by Ryan The on 4/12/20.
//

import UIKit

enum BusArrivalTiming {
    case arr
    case left
    case mins(Int)
}

class BusStopTableViewCell: UITableViewCell {
    
    var busNumberLabel = UILabel()
    var busArrivedLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(busNumberLabel)
        addSubview(busArrivedLabel)
        
        configureBusNumberLabel()
        configureBusArrivedLabel()
        setBusNumberLabelConstraints()
        setBusArrivedLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureBusNumberLabel() {
        busNumberLabel.numberOfLines = 0
        busNumberLabel.adjustsFontSizeToFitWidth = true
        busNumberLabel.backgroundColor = UIColor(red: 0.0 / 255.0, green: 122.0 / 255.0, blue: 255.0 / 255.0, alpha: 1)
        busNumberLabel.layer.cornerRadius = 8
        busNumberLabel.textColor = .white
        busNumberLabel.textAlignment = .center
        busNumberLabel.clipsToBounds = true
    }
    
    func configureBusArrivedLabel() {
        busArrivedLabel.numberOfLines = 0
        busArrivedLabel.adjustsFontSizeToFitWidth = true
        if busArrivedLabel.text == "Arr" {
            busArrivedLabel.textColor = .systemGreen
        }else{
            busArrivedLabel.textColor = .systemRed
        }
    }
    
    func setBusNumberLabelConstraints() {
        busNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            busNumberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            busNumberLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            busNumberLabel.heightAnchor.constraint(equalToConstant: 40),
            busArrivedLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -200),
        ])
    }
    func setBusArrivedLabelConstraints() {
        busArrivedLabel.translatesAutoresizingMaskIntoConstraints = false
        busArrivedLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        busArrivedLabel.leadingAnchor.constraint(equalTo: busNumberLabel.trailingAnchor, constant: 50).isActive = true
        busArrivedLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        busArrivedLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
    }
    
}
