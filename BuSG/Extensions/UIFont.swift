//
//  UIFont.swift
//  BuSG
//
//  Created by Ryan The on 14/12/20.
//

import UIKit

extension UIFont {
    
    class var large: UIFont {
        UIFont.systemFont(ofSize: 23, weight: .semibold)
    }
    
    class var regular: UIFont {
        UIFont.systemFont(ofSize: 17)
    }
    
    class var detail: UIFont {
        UIFont.systemFont(ofSize: 12)
    }
    
}
