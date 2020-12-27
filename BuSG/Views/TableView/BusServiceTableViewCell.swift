//
//  BusServiceTableViewCell.swift
//  BuSG
//
//  Created by Ryan The on 18/12/20.
//

import UIKit

protocol BusServiceTableViewCellDelegate {
    
    func busArrivalTableViewCell(_ busArrivalTableViewCell: BusServiceTableViewCell, didSelectBusTimingButtonAt busTimingIndex: Int, forCellAt cellIndexPath: IndexPath)
    
}

class BusServiceTableViewCell: UITableViewCell {
    
    public var indexPath: IndexPath!
    
    public var delegate: BusServiceTableViewCellDelegate?
    
    public lazy var serviceNoLabel = UILabel()
    
    public lazy var originLabel = UILabel()

    public lazy var destinationDirectionImageView = UIImageView()
    
    public lazy var destinationLabel = UILabel()
    
    public lazy var busOperatorImage = UIImageView()
    
    public lazy var isPreviewing: Bool = false {
        didSet {
            originLabelWidthConstraint.isActive = !isPreviewing
            destinationDirectionImageViewLeadingAnchorConstraint.constant = isPreviewing ? K.sizes.margin.one : 0
            busOperatorImage.isHidden = !isPreviewing
        }
    }
    
    public var busService: BusService? {
        didSet {
            destinationDirectionImageView.image = UIImage(systemName: busService?.originCode == busService?.destinationCode ? "arrow.clockwise" : "arrow.right")
        }
    }
    
    lazy var originLabelWidthConstraint = originLabel.widthAnchor.constraint(equalToConstant: 0)
    lazy var destinationDirectionImageViewLeadingAnchorConstraint = destinationDirectionImageView.leadingAnchor.constraint(equalTo: originLabel.trailingAnchor, constant: isPreviewing ? K.sizes.margin.one : 0)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(serviceNoLabel)
        contentView.addSubview(originLabel)
        contentView.addSubview(destinationDirectionImageView)
        contentView.addSubview(destinationLabel)
        contentView.addSubview(busOperatorImage)

        serviceNoLabel.translatesAutoresizingMaskIntoConstraints = false
        serviceNoLabel.font = .large
        NSLayoutConstraint.activate([
            serviceNoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: K.sizes.margin.one),
            serviceNoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: K.sizes.margin.two),
        ])
        
        originLabel.font = .detail
        originLabel.textColor = .secondaryLabel
        originLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            originLabel.heightAnchor.constraint(equalToConstant: 15),
            originLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -K.sizes.margin.one),
            originLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: K.sizes.margin.two),
        ])
        originLabelWidthConstraint.isActive = !isPreviewing
        
        destinationDirectionImageView.preferredSymbolConfiguration = .init(font: .detail)
        destinationDirectionImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            destinationDirectionImageViewLeadingAnchorConstraint,
            destinationDirectionImageView.centerYAnchor.constraint(equalTo: originLabel.centerYAnchor),
        ])
        
        destinationLabel.font = .detail
        destinationLabel.textColor = .secondaryLabel
        destinationLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            destinationLabel.leadingAnchor.constraint(equalTo: destinationDirectionImageView.trailingAnchor, constant: K.sizes.margin.one),
            destinationLabel.centerYAnchor.constraint(equalTo: destinationDirectionImageView.centerYAnchor),
        ])
        
        busOperatorImage.isHidden = !isPreviewing
        busOperatorImage.contentMode = .scaleAspectFit
        busOperatorImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            busOperatorImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -K.sizes.margin.two),
            busOperatorImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -K.sizes.margin.one),
            busOperatorImage.heightAnchor.constraint(equalToConstant: 20),
            busOperatorImage.widthAnchor.constraint(equalToConstant: 48),
        ])
        
        backgroundColor = .clear
        selectedBackgroundView = FillView(solidWith: UIColor.label.withAlphaComponent(0.1))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
