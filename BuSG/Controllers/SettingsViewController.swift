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
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en-SG")
        dateFormatter.dateFormat = "MMMM d, y (hh:mm a)"
        data = ListData(sections: [
            ListSection(items: [
//                ListItem(title: "Favourite Places", image: UIImage(systemName: "heart.fill")),
                ListItem(title: "Bus Data", image: UIImage(systemName: "bus.fill"), pushViewController: ListViewController(data: ListData(sections: [
                    ListSection(items: [
                        ListItem(title: "Update Now", action: { tableViewController, listData, indexPath in
                            let alert = UIAlertController(title: nil, message: "Updating Bus Data", preferredStyle: .alert)
                            tableViewController.present(alert, animated: true)
                            let activityIndicator = UIActivityIndicatorView()
                            alert.view.addSubview(activityIndicator)
                            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
                            NSLayoutConstraint.activate([
                                activityIndicator.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor, constant: K.sizes.margin.twoAndHalf),
                                activityIndicator.centerYAnchor.constraint(equalTo: alert.view.centerYAnchor),
                            ])
                            activityIndicator.startAnimating()
                            ApiProvider.shared.updateStaticData {_ in
                                listData.sections[indexPath.section].footerText = "Last Updated: \(dateFormatter.string(from: Date(timeIntervalSince1970: Double(UserDefaults.standard.double(forKey: K.userDefaults.lastUpdatedEpoch)))))"
                                DispatchQueue.main.async {
                                    alert.dismiss(animated: true)
                                    tableViewController.tableView.reloadData()
                                }
                            }
                        }),
                    ], footerText: "Last Updated: \(dateFormatter.string(from: Date(timeIntervalSince1970: Double(UserDefaults.standard.double(forKey: K.userDefaults.lastUpdatedEpoch)))))"),
                    SelectListSection(items: [
                        ListItem(title: "Once per month"),
                        ListItem(title: "Once per week"),
                        ListItem(title: "Manually"),
                    ], headerText: "Auto Update Frequency", defaultIndex: UserDefaults.standard.integer(forKey: K.userDefaults.updateFrequency), onSelected: { UserDefaults.standard.setValue($2.row, forKey: K.userDefaults.updateFrequency) }),
                ]))),
                ListItem(title: "Show Suggestions", image: UIImage(systemName: "calendar"), accessoryView: UISwitch(frame: CGRect(), isOn: UserDefaults.standard.bool(forKey: K.userDefaults.connectToCalendar), primaryAction: UIAction(handler: { UserDefaults.standard.setValue(($0.sender as! UISwitch).isOn, forKey: K.userDefaults.connectToCalendar) }))),
            ]),
            ListSection(items: [
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
                ListItem(title: "Debug Logs", pushViewController: UIViewController()),
                ListItem(title: "Rate on App Store", urlString: "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=\(K.appDetails.appleId)"),
                ListItem(title: "Open-Sourced on GitHub", urlString: "https://github.com/theboi/BuSG"),
            ]),
        ])
        tableView.reloadData()
    }
    
    init() {
        super.init(data: ListData(sections: []))
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
