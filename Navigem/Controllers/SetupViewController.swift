//
//  SetupViewController.swift
//  Navigem
//
//  Created by Karl Steven  on 5/12/20.
//

import UIKit

class SetupViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .systemBackground
        let welcomeText = UILabel(frame: CGRect(x: (self.view.center.x) - 82, y: 150, width: 500, height: 100))
        welcomeText.text = "Welcome"
        welcomeText.font = UIFont.boldSystemFont(ofSize: 40)
        self.view.addSubview(welcomeText)
        
        let homeLocation =  UITextField(frame: CGRect(x: (self.view.center.x)-150, y: 300, width: 300, height: 40))
            homeLocation.placeholder = "Enter Home Location"
            homeLocation.font = UIFont.systemFont(ofSize: 18)
            homeLocation.borderStyle = UITextField.BorderStyle.roundedRect
            homeLocation.autocorrectionType = UITextAutocorrectionType.no
            homeLocation.keyboardType = UIKeyboardType.default
            homeLocation.returnKeyType = UIReturnKeyType.done
            homeLocation.clearButtonMode = UITextField.ViewMode.whileEditing
            homeLocation.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
            self.view.addSubview(homeLocation)
        
        let schoolLocation =  UITextField(frame: CGRect(x: (self.view.center.x)-150, y: 400, width: 300, height: 40))
            schoolLocation.placeholder = "Enter School Location"
            schoolLocation.font = UIFont.systemFont(ofSize: 18)
            schoolLocation.borderStyle = UITextField.BorderStyle.roundedRect
            schoolLocation.autocorrectionType = UITextAutocorrectionType.no
            schoolLocation.keyboardType = UIKeyboardType.default
            schoolLocation.returnKeyType = UIReturnKeyType.done
            schoolLocation.clearButtonMode = UITextField.ViewMode.whileEditing
            schoolLocation.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
            self.view.addSubview(schoolLocation)
        
        let workLocation =  UITextField(frame: CGRect(x: (self.view.center.x) - 150, y: 500, width: 300, height: 40))
            workLocation.placeholder = "Enter Work Location"
            workLocation.font = UIFont.systemFont(ofSize: 18)
            workLocation.borderStyle = UITextField.BorderStyle.roundedRect
            workLocation.autocorrectionType = UITextAutocorrectionType.no
            workLocation.keyboardType = UIKeyboardType.default
            workLocation.returnKeyType = UIReturnKeyType.done
            workLocation.clearButtonMode = UITextField.ViewMode.whileEditing
            workLocation.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
            self.view.addSubview(workLocation)
        
        let defaults = UserDefaults.standard
        
        let startButton = UIButton(type: .roundedRect, primaryAction: UIAction(title: "Start") {_ in
            let newViewController = MainViewController()
            defaults.setValue(homeLocation.text, forKey: "homeLoc")
            defaults.setValue(schoolLocation.text, forKey: "schoolLoc")
            defaults.setValue(workLocation.text, forKey: "workLoc")
            newViewController.modalPresentationStyle = .fullScreen
            self.present(newViewController, animated: true)
        })
        startButton.frame = CGRect(x: (self.view.center.x) - 150, y: 600, width: 300, height: 40)
        startButton.backgroundColor = UIColor.black
        startButton.titleLabel?.textAlignment = .center
        startButton.layer.cornerRadius = 5
        startButton.setTitleColor(UIColor.white, for: .normal)
        self.view.addSubview(startButton)

    
    



}
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
