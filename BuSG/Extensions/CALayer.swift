//
//  CALayer.swift
//  BuSG
//
//  Created by Ryan The on 27/12/20.
//

import UIKit

extension CALayer {

    public var image: UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, isOpaque, 0)
        render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
    }
    
}
