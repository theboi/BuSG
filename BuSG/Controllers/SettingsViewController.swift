//
//  SettingsViewController.swift
//  BuSG
//
//  Created by Ryan The on 11/12/20.
//

import UIKit
import MessageUI

class SettingsViewController: ListViewController {
    
    func reloadData() {
        listData = [
            ListSection(tableItems: [
                ListItem(title: "Bus Data", pushViewController: ListViewController(tableData: [
                    ListSection(tableItems: [
                        ListItem(title: "Update Now", action: {_ in 
                            (UIApplication.shared.delegate as! AppDelegate).window?.present(Toast(message: "Began Bus Data Update", image: UIImage(systemName: "square.and.arrow.down")), duration: 3)
                        })
                    ]),
                    SelectListSection(tableItems: [
                        ListItem(title: "Once per week"),
                        ListItem(title: "Once per month"),
                        ListItem(title: "Never"),
                    ], headerText: "Update Frequency", onSelected: { (section) in
                        print("HELO")
                    }),
                ])),
            ]),
            ListSection(tableItems: [
                //                SettingsTableItem(title: "History", pushViewController: UIViewController()),
                ListItem(title: "Share with a Friend", presentViewController: {
                    return UIActivityViewController(activityItems: ["Check out BuSG, a smart bus tracker app!"], applicationActivities: [])
                }()),
                ListItem(title: "Submit Feedback/Issues", presentViewController: {
                    if MFMailComposeViewController.canSendMail() {
                        let mail = MFMailComposeViewController()
                        mail.mailComposeDelegate = self
                        mail.setToRecipients(["ryan@ryanthe.com"])
                        mail.setSubject("Feedback on BuSG")
                        return mail
                    }
                    return UIAlertController(title: "Could not send Mail", message: "Please configure your device to send Mail.", preferredStyle: .alert)
                }()),
                ListItem(title: "Rate on App Store", urlString: "itms-apps://itunes.apple.com/app/\(Bundle.main.bundleIdentifier!)"),
                ListItem(title: "Open-Sourced on GitHub", urlString: "https://github.com/theboi/BuSG"),
            ]),
        ]
        tableView.reloadData()
    }
    
    init() {
        super.init()
        title = "Settings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .done, primaryAction: UIAction(handler: { _ in
            self.dismiss(animated: true)
        }))
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
