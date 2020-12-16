//
//  UIAlertController.swift
//  BuSG
//
//  Created by Ryan The on 15/12/20.
//

import UIKit

extension UIAlertController {
    
    convenience init(title: String?, message: String?, preferredStyle: UIAlertController.Style, completion: CompletionHandler<UIAlertController>) {
        self.init(title: title, message: message, preferredStyle: preferredStyle)
        completion?(self)
    }
    
}
