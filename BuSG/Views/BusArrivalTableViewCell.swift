//
//  BusStopTableViewCell.swift
//   BuSG
//
//  Created by Ryan The on 4/12/20.
//

import UIKit

class BusArrivalTableViewCell: BusServiceTableViewCell {
    
    private var stackView: UIStackView!
    
    private lazy var busTimingButtons: [UIButton] = (0...2).map { num in
        UIButton(primaryAction: UIAction(handler: { _ in
            self.delegate?.busArrivalTableViewCell(self, didSelectBusTimingButtonAt: num, forCellAt: self.indexPath)
        }))
    }
    
    public lazy var errorLabel = UILabel()
    
    public var busTimings: [BusArrivalBus]? {
        didSet {
            if let busTimings = busTimings {
                errorLabel.text = nil
                stackView.isHidden = false
                busTimings.enumerated().forEach { (index, bus) in
                    let time = bus.estimatedMinsToArrival
                    let button = busTimingButtons[index]
                    let loadIndicator = button.subviews[0]
                    button.layer.borderWidth = 0
                    button.setTitleColor(.label, for: .normal)
                    button.backgroundColor = .clear
                    button.layer.opacity = 1
                    if index == 0 {
                        button.backgroundColor = UIColor.label.withAlphaComponent(0.1)
                    } else {
                        button.layer.borderWidth = 1
                        button.layer.borderColor = UIColor.systemFill.cgColor
                    }
                    if time == -999 {
                        /// Bus service estimation not available (stopped due to night time etc.)
                        button.setTitle("-", for: .normal)
                        button.layer.opacity = 0.4
                    } else if time == 0 {
                        /// Bus Arriving
                        button.setTitle("Arr", for: .normal)
                        button.setTitleColor(.systemBackground, for: .normal)
                        button.backgroundColor = .systemGreen
                    } else if time < 0 {
                        /// Bus Just Left
                        button.setTitle("Arr", for: .normal)
                        button.layer.opacity = 0.4
                    } else {
                        /// Valid timing
                        button.setTitle(String(time), for: .normal)
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
        
        stackView = UIStackView(arrangedSubviews: busTimingButtons)
        stackView.distribution = .fillEqually
        stackView.alignment = .trailing
        stackView.spacing = K.sizes.margin.twoAndHalf
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: (K.sizes.cell.busArrivalMin-K.sizes.others.busTimingButton)/2),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -K.sizes.margin.two),
            stackView.widthAnchor.constraint(equalToConstant: 180),
        ])
        
        busTimingButtons.forEach { (button) in
            button.titleLabel?.font = .medium
            button.layer.cornerRadius = K.cornerRadius
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.heightAnchor.constraint(equalToConstant: K.sizes.others.busTimingButton)
            ])
            
            let loadIndicatorView = UIView()
            button.insertSubview(loadIndicatorView, at: 0)
            loadIndicatorView.backgroundColor = .systemGreen
            loadIndicatorView.translatesAutoresizingMaskIntoConstraints = false
            loadIndicatorView.layer.cornerRadius = 3
            loadIndicatorView.layer.borderWidth = 1
            loadIndicatorView.layer.borderColor = UIColor.systemFill.cgColor
            NSLayoutConstraint.activate([
                loadIndicatorView.heightAnchor.constraint(equalToConstant: 5),
                loadIndicatorView.widthAnchor.constraint(equalToConstant: 5),
                loadIndicatorView.topAnchor.constraint(equalTo: button.topAnchor, constant: 5),
                loadIndicatorView.trailingAnchor.constraint(equalTo: button.trailingAnchor, constant: -5),
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
