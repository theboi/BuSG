//
//  SettingsViewController.swift
//  BuSG
//
//  Created by Ryan The on 11/12/20.
//

import UIKit

class SettingsViewController: ListViewController {
        
    func reloadData() {
        listData = [
            ListSection(tableItems: [
                ListItem(title: "Bus Data", pushViewController: ListViewController(tableData: [
                    ListSection(tableItems: [
                        ListItem(title: "Update Now", action: {
                            // TODO
                        })
                    ]),
                    ListSection(tableItems: [
                        ListItem(title: "Once per week"),
                        ListItem(title: "Once per month"),
                        ListItem(title: "Never"),
                    ], headerText: "Update Frequency", footerText: "")
                ])),
            ]),
            ListSection(tableItems: [
                //                SettingsTableItem(title: "History", pushViewController: UIViewController()),
                ListItem(title: "Share with a Friend", presentViewController: {
                    return UIActivityViewController(activityItems: ["Check out BuSG, a smart bus tracker app!"], applicationActivities: [])
                }()),
                ListItem(title: "Rate on App Store", urlString: "itms-apps://itunes.apple.com/app/\(Bundle.main.bundleIdentifier!)"),
                ListItem(title: "Open-Sourced Repository", urlString: "https://github.com/theboi/BuSG"),
                ListItem(title: "Report an Issue", urlString: "https://github.com/theboi/BuSG"),
            ]),
        ]
        tableView.reloadData()
    }
    
    init() {
        super.init()
        title = "Settings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: UIAction(handler: { _ in
            self.dismiss(animated: true)
        }))
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
