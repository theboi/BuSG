//
//  UISwitch.swift
//  BuSG
//
//  Created by Ryan The on 16/12/20.
//

import UIKit

extension UISwitch {
    
    convenience init(frame: CGRect, isOn: Bool, primaryAction: UIAction?) {
        self.init(frame: frame, primaryAction: primaryAction)
        setOn(isOn, animated: false)
    }
    
}
