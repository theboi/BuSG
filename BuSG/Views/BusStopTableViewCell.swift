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
    
    public lazy var serviceNoLabel = UILabel()
    public lazy var busTimingLabels = [UILabel(), UILabel(), UILabel()]
    public var stackView: UIStackView!
    public lazy var errorLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(serviceNoLabel)
        
        serviceNoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            serviceNoLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            serviceNoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.margin.large),
            serviceNoLabel.heightAnchor.constraint(equalTo: heightAnchor, constant: -20),
            serviceNoLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            serviceNoLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -309)
        ])
        
        stackView = UIStackView(arrangedSubviews: busTimingLabels)
        stackView.distribution = .fillEqually
        stackView.alignment = .trailing
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: K.margin.large),
            stackView.widthAnchor.constraint(equalToConstant: 200),
        ])
        
        errorLabel.backgroundColor = .clear
        errorLabel.textColor = UIColor.label.withAlphaComponent(0.3)
        insertSubview(errorLabel, aboveSubview: stackView)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: stackView.topAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
