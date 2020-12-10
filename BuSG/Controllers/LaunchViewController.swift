//
//  LaunchViewController.swift
//  BuSG
//
//  Created by Ryan The on 8/12/20.
//

import UIKit

class LaunchViewController: SettingsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        isModalInPresentation = true

        self.view.backgroundColor = .systemBackground
        
    }
    
    var favouriteLocations: [SettingsTableItem] = [SettingsTableItem(title: "Hello")]
    
    init() {
        super.init()
        title = "Setup"
        tableData = [
            SettingsTableSection(tableItems: favouriteLocations, headerText: "Favourite Locations", footerText: "These locations would be used in suggesting buses to take.", headerTrailingButton: UIButton(type: .contactAdd, primaryAction: UIAction(handler: { _ in
                let newFavouriteLocationViewController = UIAlertController()
                newFavouriteLocationViewController.addTextField { (textField) in
                    textField.placeholder = "Name"
                }
                self.present(newFavouriteLocationViewController, animated: true, completion: nil)
            })))
        ]
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
