//
//  BusStopTableViewCell.swift
//   BuSG
//
//  Created by Ryan The on 4/12/20.
//

import UIKit

protocol BusStopTableViewCellDelegate {
    
    func busStopTableViewCell(_ busStopTableViewCell: BusStopTableViewCell, didPressSequenceButtonAt index: Int)
    
}

class BusStopTableViewCell: UITableViewCell {
    
    public var indexPath: IndexPath?
    
    public lazy var busStopCodeLabel = UILabel()
    
    public lazy var roadDescLabel = UILabel()
    
    public lazy var roadNameLabel = UILabel()
    
    public lazy var distanceLabel = UILabel()
    
    private lazy var busServicesLabel = UILabel()
    
    private lazy var sequenceButton = { () -> UIButton in 
        let button = UIButton(type: .roundedRect, primaryAction: UIAction(handler: { _ in
            if let indexPath = self.indexPath {
                self.delegate?.busStopTableViewCell(self, didPressSequenceButtonAt: indexPath.row)
            }
        }))
        button.isHidden = true
        return button
    }()
    
    public var delegate: BusStopTableViewCellDelegate?
    
    public var showSequence: Bool = false {
        didSet {
            sequenceButton.isHidden = !showSequence
        }
    }
    
    public var isBeginning: Bool = false
    
    public var isEnd: Bool = false
    
    public var isVisited: Bool = false
    
    public var isPreviewing: Bool = false
    
    public var busServices: [BusService] = [] {
        didSet {
            busServicesLabel.text = busServices.map({ $0.serviceNo }).joined(separator: "  ")
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        contentView.addSubview(roadDescLabel)
        roadDescLabel.font = .medium
        roadDescLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roadDescLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: K.margin.two),
            roadDescLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: K.margin.one),
        ])
        
        contentView.addSubview(busStopCodeLabel)
        busStopCodeLabel.font = .detail
        busStopCodeLabel.textColor = .secondaryLabel
        busStopCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            busStopCodeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: K.margin.two),
            busStopCodeLabel.topAnchor.constraint(equalTo: roadDescLabel.bottomAnchor, constant: K.margin.one),
        ])
        
        contentView.addSubview(roadNameLabel)
        roadNameLabel.font = .detail
        roadNameLabel.textColor = .secondaryLabel
        roadNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roadNameLabel.leadingAnchor.constraint(equalTo: busStopCodeLabel.trailingAnchor, constant: K.margin.one),
            roadNameLabel.topAnchor.constraint(equalTo: roadDescLabel.bottomAnchor, constant: K.margin.one),
        ])
        
        contentView.addSubview(busServicesLabel)
        busServicesLabel.font = .detail
        busServicesLabel.textColor = .accent
        busServicesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            busServicesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: K.margin.two),
            busServicesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -K.margin.two),
            busServicesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -K.margin.one),
        ])
        
        contentView.addSubview(distanceLabel)
        distanceLabel.font = .detail
        distanceLabel.textColor = .secondaryLabel
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            distanceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -K.margin.two),
            distanceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: K.margin.one),
        ])
        
        contentView.addSubview(sequenceButton)
        sequenceButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sequenceButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            sequenceButton.widthAnchor.constraint(equalToConstant: K.margin.two*4),
            sequenceButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            sequenceButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        backgroundColor = .clear
        selectedBackgroundView = FillView(solidWith: UIColor.label.withAlphaComponent(0.1))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
        
    override func draw(_ rect: CGRect) {
        super.draw(rect)
                
        if showSequence {
            let trailingXPoint = bounds.width-K.margin.two*2
            let radius: CGFloat = 12
            let lineWidth: CGFloat = 4 /// Radius + Line Width = 16 (K.margin.two)
            let color = isVisited ? UIColor.secondarySystemFill : UIColor.accent
            
            let circle = UIBezierPath(arcCenter: CGPoint(x: trailingXPoint, y: frame.height/2), radius: radius, startAngle: 0, endAngle: 360, clockwise: true)
            circle.lineWidth = lineWidth
            color.setStroke()
            circle.stroke()
            
            let verticalLine = UIBezierPath()
            if !isBeginning {
                verticalLine.move(to: CGPoint(x: trailingXPoint, y: 0))
                verticalLine.addLine(to: CGPoint(x: trailingXPoint, y: frame.height/2 - radius/2 - lineWidth*2))
            }
            if !isEnd {
                verticalLine.move(to: CGPoint(x: trailingXPoint, y: frame.height/2 + radius/2 + lineWidth*2))
                verticalLine.addLine(to: CGPoint(x: trailingXPoint, y: frame.height))
            }
            verticalLine.lineWidth = K.margin.half
            color.setStroke()
            verticalLine.stroke()
            
            if isPreviewing {
                let circle = UIBezierPath(arcCenter: CGPoint(x: trailingXPoint, y: frame.height/2), radius: radius - lineWidth*1.5, startAngle: 0, endAngle: 360, clockwise: true)
                UIColor.label.setFill()
                circle.fill()
            }
        }
    }
    
}
