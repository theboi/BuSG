//
//  FillView.swift
//  Navigem
//
//  Created by Ryan The on 1/12/20.
//

import UIKit

enum FillType {
    case solid, gradient
}

class FillView: UIView {

    var type: FillType!
    
    override var layer: CALayer {
        switch type {
        case .gradient: return super.layer as! CAGradientLayer
        case .solid: fallthrough
        default: return super.layer
        }
    }
    
    init(solidWith color: UIColor) {
        super.init(frame: CGRect())
        type = .solid
        backgroundColor = color
    }
    
    init(gradientWithTopColor topColor: UIColor, bottomColor: UIColor) {
        super.init(frame: CGRect())
        type = .gradient
        backgroundColor = .clear
        
        let layer = self.layer as! CAGradientLayer
        layer.startPoint = CGPoint(x: 0.5, y: 0.0)
        layer.endPoint = CGPoint(x: 0.5, y: 1.0)

        layer.colors = [topColor.cgColor, bottomColor.cgColor]
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    class var blackGradientOverlay: FillView {
        FillView(gradientWithTopColor: .clear, bottomColor: UIScreen.main.traitCollection.userInterfaceStyle == .dark ? .secondarySystemBackground : .black)
    }
}
