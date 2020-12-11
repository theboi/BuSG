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
        let favouritePlacesTableItems = favouritePlaces.enumerated().map { (index, string) -> ListItem in
            ListItem(title: string, pushViewController: ListViewController(tableData: [
                ListSection(tableItems: [
                    ListItem(textField: UITextField(frame: CGRect(), primaryAction: UIAction(handler: { action in
                        let textField = action.sender as! UITextField
                        textField.resignFirstResponder()
                        if let text = textField.text {
                            self.favouritePlaces[index] = text
                        }
                        self.reloadData()
                    })))
                ], footerText: "Enter a descriptive name and its nearest bus stop.")
            ]))
        }
        
        listData = [
            ListSection(tableItems: favouritePlacesTableItems, headerText: "Favourite Places", footerText: "These places would be used in suggesting buses to take.", headerTrailingButton: UIButton(type: .contactAdd, primaryAction: UIAction(handler: { _ in
                // TODO
            }))),
            ListSection(tableItems: [
                ListItem(title: "Connect to Calendar", accessoryView: UISwitch(frame: CGRect(), primaryAction: UIAction(handler: { action in
                    UserDefaults.standard.setValue(action.state == .on, forKey: K.userDefaults.connectToCalendar)
                })))
            ], headerText: "Events", footerText: "Enabling this allows BuSG to suggest buses based on your Calendar events.")
        ]
        tableView.reloadData()
    }
    
    init() {
        super.init()
        isModalInPresentation = true
        title = "Setup"
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
