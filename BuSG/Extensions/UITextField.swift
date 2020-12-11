//
//  UITextField.swift
//  BuSG
//
//  Created by Ryan The on 10/12/20.
//

import UIKit

extension UITextField {
    
    convenience init(frame: CGRect, placeholder: String? = nil, primaryAction: UIAction?) {
        self.init(frame: frame, primaryAction: primaryAction)
        self.placeholder = placeholder
    }
    
    func addToolbarWithDoneButton() {
        let keyboardToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        keyboardToolbar.sizeToFit()
        keyboardToolbar.barStyle = .default
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        self.inputAccessoryView = keyboardToolbar
    }
    
}
