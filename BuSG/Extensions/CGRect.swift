//
//  CGRect.swift
//  BuSG
//
//  Created by Ryan The on 17/12/20.
//

import CoreGraphics

extension CGRect {
    
    init(x: CGFloat = 0, y: CGFloat = 0, width: CGFloat = 0, height: CGFloat = 0) {
        self.init(origin: CGPoint(x: x, y: y), size: CGSize(width: width, height: height))
    }
    
    init(x: Int = 0, y: Int = 0, width: Int = 0, height: Int = 0) {
        self.init(origin: CGPoint(x: x, y: y), size: CGSize(width: width, height: height))
    }
    
    init(x: Double = 0, y: Double = 0, width: Double = 0, height: Double = 0) {
        self.init(origin: CGPoint(x: x, y: y), size: CGSize(width: width, height: height))
    }
    
}
