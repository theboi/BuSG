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
    
    private var stackView: UIStackView!
    private lazy var busTimingLabels = [UILabel(), UILabel(), UILabel()]
    
    public lazy var serviceNoLabel = UILabel()
    public lazy var destinationLabel = UILabel()
    public lazy var errorLabel = UILabel()
    
    public var busTimings: [Int]? {
        didSet {
            if let busTimings = busTimings {
                errorLabel.text = nil
                stackView.isHidden = false
                busTimings.enumerated().forEach { (index, time) in
                    let label = busTimingLabels[index]
                    label.layer.borderWidth = 0
                    label.textColor = .label
                    label.backgroundColor = .clear
                    label.layer.opacity = 1
                    if index == 0 {
                        label.backgroundColor = UIColor.label.withAlphaComponent(0.1)
                    } else {
                        label.layer.borderWidth = 1
                        label.layer.borderColor = UIColor.systemFill.cgColor
                    }
                    if time == -999 {
                        /// Bus service estimation not available (stopped due to night time etc.)
                        label.text = "-"
                        label.layer.opacity = 0.4
                    } else if time == 0 {
                        /// Bus Arriving
                        label.text = "Arr"
                        label.textColor = .systemBackground
                        label.backgroundColor = .systemGreen
                    } else if time < 0 {
                        /// Bus Just Left
                        label.text = "Arr"
                        label.layer.opacity = 0.4
                    } else {
                        /// Valid timing
                        label.text = String(time)
                    }
                }
            } else {
                /// Bus Service not operating
                errorLabel.text = "Not In Operation"
                stackView.isHidden = true
            }
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
        
        addSubview(destinationLabel)
        destinationLabel.font = .detail
        destinationLabel.textColor = .secondaryLabel
        destinationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            destinationLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -K.margin.small),
            destinationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.margin.large),
        ])
        
        stackView = UIStackView(arrangedSubviews: busTimingLabels)
        stackView.distribution = .fillEqually
        stackView.alignment = .trailing
        stackView.spacing = K.margin.extraLarge
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -2),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -K.margin.large),
            stackView.widthAnchor.constraint(equalToConstant: 180),
        ])
        
        busTimingLabels.forEach { (label) in
            label.textAlignment = .center
            label.font = .medium
            label.layer.cornerRadius = K.cornerRadius
            label.clipsToBounds = false
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.heightAnchor.constraint(equalToConstant: 40)
            ])
            
            let loadIndicatorView = UIView()
            loadIndicatorView.backgroundColor = .systemGreen
            label.insertSubview(loadIndicatorView, at: 100)
            loadIndicatorView.translatesAutoresizingMaskIntoConstraints = false
            loadIndicatorView.layer.cornerRadius = 2
            NSLayoutConstraint.activate([
                loadIndicatorView.heightAnchor.constraint(equalToConstant: 3),
                loadIndicatorView.widthAnchor.constraint(equalToConstant: 10),
                loadIndicatorView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5),
                loadIndicatorView.centerXAnchor.constraint(equalTo: label.centerXAnchor)
            ])
        }
        
        errorLabel.backgroundColor = .clear
        errorLabel.textColor = UIColor.label.withAlphaComponent(0.3)
        insertSubview(errorLabel, aboveSubview: stackView)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: topAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
        ])
        
        backgroundColor = .clear
        selectedBackgroundView = FillView(solidWith: UIColor.label.withAlphaComponent(0.1))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
