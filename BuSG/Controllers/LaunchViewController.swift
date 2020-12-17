//
//  LaunchViewController.swift
//  BuSG
//
//  Created by Ryan The on 8/12/20.
//

import UIKit

class LaunchViewController: ListViewController {
    
    var favouritePlaces = ["Home", "Work", "School"]
        
    func reloadData() {
        let favouritePlacesLocationPickerView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
        favouritePlacesLocationPickerView.backgroundColor = .red
//        favouritePlacesLocationPickerView.addSubview(UISegmentedControl(items: ["Hello"]))
        
        let favouritePlacesTableItems = favouritePlaces.enumerated().map { (index, name) -> ListItem in
            ListItem(title: name, pushViewController: ListViewController(data: ListData(sections: [
                ListSection(items: [
                    ListItem(textField: UITextField(frame: CGRect(), placeholder: "Name", text: name, primaryAction: UIAction(handler: { action in
                        let textField = action.sender as! UITextField
                        textField.resignFirstResponder()
                        if let text = textField.text {
                            self.favouritePlaces[index] = text
                        }
                        self.reloadData()
                    })))
                ], footerText: "Enter a descriptive name and it's nearest bus stop.")
            ]), headerView: favouritePlacesLocationPickerView))
        }
        
        data = ListData(sections: [
            ListSection(items: favouritePlacesTableItems, headerText: "Favourite Places", footerText: "These places would be used in suggesting buses to take.", headerTrailingButton: UIButton(type: .contactAdd, primaryAction: UIAction(handler: { _ in
                // TODO
            }))),
            ListSection(items: [
                ListItem(title: "Connect To Calendar", accessoryView: UISwitch(frame: CGRect(), isOn: UserDefaults.standard.bool(forKey: K.userDefaults.connectToCalendar), primaryAction: UIAction(handler: { UserDefaults.standard.setValue(($0.sender as! UISwitch).isOn, forKey: K.userDefaults.connectToCalendar) }))),
            ], headerText: "Events", footerText: "Enabling this allows BuSG to suggest buses based on your Calendar events.")
        ])
        tableView.reloadData()
    }
    
    init() {
        super.init(data: ListData(sections: []), footerView: UIView(frame: CGRect(height: 50+K.margin.large*2)))
        isModalInPresentation = true
        title = "Setup"
        
        reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let doneButton = UIButton(frame: CGRect(), primaryAction: UIAction(handler: { _ in
            self.dismiss(animated: true)
        }))
        doneButton.backgroundColor = .accent
        doneButton.setTitle("Done", for: .normal)
        doneButton.layer.cornerRadius = K.cornerRadius
        footerView.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: K.margin.large),
            doneButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -K.margin.large),
            doneButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -K.margin.large),
            doneButton.topAnchor.constraint(equalTo: footerView.topAnchor, constant: K.margin.large),
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
