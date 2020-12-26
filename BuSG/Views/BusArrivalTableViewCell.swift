//
//  BusStopTableViewCell.swift
//   BuSG
//
//  Created by Ryan The on 4/12/20.
//

import UIKit

/// Height: 65
class BusArrivalTableViewCell: BusServiceTableViewCell {
    
    private var stackView: UIStackView!
    private lazy var busTimingLabels = [UIButton(), UIButton(), UIButton()]
    
    public lazy var errorLabel = UILabel()
    
    public var busTimings: [BusArrivalBus]? {
        didSet {
            if let busTimings = busTimings {
                errorLabel.text = nil
                stackView.isHidden = false
                busTimings.enumerated().forEach { (index, bus) in
                    let time = bus.estimatedMinsToArrival
                    let label = busTimingLabels[index]
                    let loadIndicator = label.subviews[0]
                    label.layer.borderWidth = 0
                    label.setTitleColor(.label, for: .normal)
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
                        label.setTitle("-", for: .normal)
                        label.layer.opacity = 0.4
                    } else if time == 0 {
                        /// Bus Arriving
                        label.setTitle("Arr", for: .normal)
                        label.setTitleColor(.systemBackground, for: .normal)
                        label.backgroundColor = .systemGreen
                    } else if time < 0 {
                        /// Bus Just Left
                        label.setTitle("Arr", for: .normal)
                        label.layer.opacity = 0.4
                    } else {
                        /// Valid timing
                        label.setTitle(String(time), for: .normal)
                    }
                    loadIndicator.isHidden = !(bus.load == .sda || bus.load == .lsd)
                    loadIndicator.backgroundColor = bus.load == .sda ? .systemYellow : .systemRed
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
        
        stackView = UIStackView(arrangedSubviews: busTimingLabels)
        stackView.distribution = .fillEqually
        stackView.alignment = .trailing
        stackView.spacing = K.margin.twoAndHalf
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -K.margin.two),
            stackView.widthAnchor.constraint(equalToConstant: 180),
        ])
        
        busTimingLabels.forEach { (label) in
            label.titleLabel?.font = .medium
            label.layer.cornerRadius = K.cornerRadius
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.heightAnchor.constraint(equalToConstant: 40)
            ])
            
            let loadIndicatorView = UIView()
            label.insertSubview(loadIndicatorView, at: 0)
            loadIndicatorView.backgroundColor = .systemGreen
            loadIndicatorView.translatesAutoresizingMaskIntoConstraints = false
            loadIndicatorView.layer.cornerRadius = 3
            loadIndicatorView.layer.borderWidth = 1
            loadIndicatorView.layer.borderColor = UIColor.systemFill.cgColor
            NSLayoutConstraint.activate([
                loadIndicatorView.heightAnchor.constraint(equalToConstant: 5),
                loadIndicatorView.widthAnchor.constraint(equalToConstant: 5),
                loadIndicatorView.topAnchor.constraint(equalTo: label.topAnchor, constant: 5),
                loadIndicatorView.trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: -5),
            ])
        }
        
        errorLabel.backgroundColor = .clear
        errorLabel.textColor = UIColor.label.withAlphaComponent(0.3)
        insertSubview(errorLabel, aboveSubview: stackView)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            errorLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
