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
    
    public lazy var destinationDirectionImageView = UIImageView()
    
    public lazy var destinationLabel = UILabel()
    
    public lazy var originLabel = UILabel()

    public lazy var isPreviewing: Bool = false {
        didSet {
            originLabelWidthConstraint.isActive = !isPreviewing
            destinationDirectionImageViewLeadingAnchorConstraint.constant = isPreviewing ? K.sizes.margin.one : 0
            let scale: CGFloat = isPreviewing ? 1 : 0.8
            let shift: CGFloat = 1-scale
            let label = self.serviceNoLabel
            UIView.animate(withDuration: 0.2) {
                self.serviceNoLabel.transform = CGAffineTransform(scaleX: scale, y: scale).concatenating(CGAffineTransform(translationX: -label.frame.width*shift/2, y: -label.frame.height*shift/2))
            }
        }
    }
    
    public var busService: BusService? {
        didSet {
            destinationDirectionImageView.image = UIImage(systemName: busService?.originCode == busService?.destinationCode ? "arrow.clockwise" : "arrow.right")
        }
    }
    
    enum originLabelConstraints {
        
    }
    
    lazy var originLabelWidthConstraint = originLabel.widthAnchor.constraint(equalToConstant: 0)
    lazy var destinationDirectionImageViewLeadingAnchorConstraint = destinationDirectionImageView.leadingAnchor.constraint(equalTo: originLabel.trailingAnchor, constant: K.sizes.margin.one)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(serviceNoLabel)
        contentView.addSubview(destinationDirectionImageView)
        contentView.addSubview(destinationLabel)
        contentView.addSubview(originLabel)

        serviceNoLabel.translatesAutoresizingMaskIntoConstraints = false
        serviceNoLabel.font = .largeScaled
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
            originLabelWidthConstraint,
        ])
        
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
        
        backgroundColor = .clear
        selectedBackgroundView = FillView(solidWith: UIColor.label.withAlphaComponent(0.1))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
