//
//  BusStopTableViewCell.swift
//   BuSG
//
//  Created by Ryan The on 4/12/20.
//

import UIKit

class BusStopTableViewCell: UITableViewCell {
    
    public lazy var busStopCodeLabel = UILabel()
    public lazy var roadDescLabel = UILabel()
    public lazy var roadNameLabel = UILabel()
    public lazy var distanceLabel = UILabel()
    private lazy var busServicesLabel = UILabel()
    
    public lazy var sequenceTouchView = UIView()
    
    public var showSequence: Bool = false
    
    public var isVisited: Bool = false
    
    public var isViewing: Bool = false
    
    public var busServices: [BusService] = [] {
        didSet {
            busServicesLabel.text = busServices.map({ $0.serviceNo }).joined(separator: "  ")
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(roadDescLabel)
        roadDescLabel.font = .medium
        roadDescLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roadDescLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.margin.two),
            roadDescLabel.topAnchor.constraint(equalTo: topAnchor, constant: K.margin.one),
        ])
        
        addSubview(busStopCodeLabel)
        busStopCodeLabel.font = .detail
        busStopCodeLabel.textColor = .secondaryLabel
        busStopCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            busStopCodeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.margin.two),
            busStopCodeLabel.topAnchor.constraint(equalTo: roadDescLabel.bottomAnchor, constant: K.margin.one),
        ])
        
        addSubview(roadNameLabel)
        roadNameLabel.font = .detail
        roadNameLabel.textColor = .secondaryLabel
        roadNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            roadNameLabel.leadingAnchor.constraint(equalTo: busStopCodeLabel.trailingAnchor, constant: K.margin.one),
            roadNameLabel.topAnchor.constraint(equalTo: roadDescLabel.bottomAnchor, constant: K.margin.one),
        ])
        
        addSubview(busServicesLabel)
        busServicesLabel.font = .detail
        busServicesLabel.textColor = .accent
        busServicesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            busServicesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.margin.two),
            busServicesLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -K.margin.two),
            busServicesLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -K.margin.one),
        ])
        
        addSubview(distanceLabel)
        distanceLabel.font = .detail
        distanceLabel.textColor = .secondaryLabel
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            distanceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -K.margin.two),
            distanceLabel.topAnchor.constraint(equalTo: topAnchor, constant: K.margin.one),
        ])
        
//        addSubview(sequenceTouchView)
//        sequenceTouchView.backgroundColor = .red
//        sequenceTouchView.addGestureRecognizer(<#T##gestureRecognizer: UIGestureRecognizer##UIGestureRecognizer#>)
//        sequenceTouchView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            sequenceTouchView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -K.margin.two),
//            sequenceTouchView.topAnchor.constraint(equalTo: topAnchor),
//            sequenceTouchView.bottomAnchor.constraint(equalTo: bottomAnchor),
//        ])
        let gesrec = UITapGestureRecognizer()
        let gesrecdelegate = BusStopTableViewCellGestureRecognizerDelegate()
        gesrec.delegate = gesrecdelegate
        self.addGestureRecognizer(gesrec)
        
        backgroundColor = .clear
        selectedBackgroundView = FillView(solidWith: UIColor.label.withAlphaComponent(0.1))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
//    override func draw(_ rect: CGRect) {
//        if showSequence {
//            let trailingXPoint = bounds.width-K.margin.two*2
//            let radius: CGFloat = 12
//            let lineWidth: CGFloat = K.margin.half
//            let color = isVisited ? UIColor.secondarySystemFill : UIColor.accent
//            
//            let circle = UIBezierPath(arcCenter: CGPoint(x: trailingXPoint, y: frame.height/2), radius: radius, startAngle: 0, endAngle: 360, clockwise: true)
//            circle.lineWidth = lineWidth
//            color.setStroke()
//            circle.stroke()
//            
//            let verticalLine = UIBezierPath()
//            verticalLine.move(to: CGPoint(x: trailingXPoint, y: 0))
//            verticalLine.addLine(to: CGPoint(x: trailingXPoint, y: frame.height/2 - radius/2 - lineWidth*2))
//            verticalLine.move(to: CGPoint(x: trailingXPoint, y: frame.height/2 + radius/2 + lineWidth*2))
//            verticalLine.addLine(to: CGPoint(x: trailingXPoint, y: frame.height))
//            
//            verticalLine.lineWidth = K.margin.half
//            color.setStroke()
//            verticalLine.stroke()
//            
//            if isViewing {
//                let circle = UIBezierPath(arcCenter: CGPoint(x: trailingXPoint, y: frame.height/2), radius: radius - lineWidth*1.5, startAngle: 0, endAngle: 360, clockwise: true)
//                UIColor.label.setFill()
//                circle.fill()
//            }
//        }
//    }
    
}

class BusStopTableViewCellGestureRecognizerDelegate: NSObject, UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        print("HEYYY")
        return true
    }
    
}
