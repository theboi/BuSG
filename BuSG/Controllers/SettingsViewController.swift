//
//  SettingsViewController.swift
//  Navigem
//
//  Created by Ryan The on 7/12/20.
//

import UIKit
import StoreKit

typealias SettingsTableList = [[SettingsTableItem]]

struct SettingsTableItem {
    var title: String
    var image: UIImage?
    var height: CGFloat?
    var customCell: UITableViewCell?
    var accessoryView: UIView?
    var pushViewController: UIViewController?
    var presentViewController: UIViewController?
    var action: (() -> Void)?
    var urlString: String?
}

class SettingsViewController: UITableViewController {
    
    var listData: SettingsTableList!
    
    var rootList: SettingsTableList {
        [
            [
                SettingsTableItem(title: "Auto Refresh Bus Timing", accessoryView: UISwitch()),
                SettingsTableItem(title: "Update Bus Data", accessoryView: UISwitch()),
            ],
            [
//                SettingsTableItem(title: "History", pushViewController: UIViewController()),
                SettingsTableItem(title: "Share with a Friend", presentViewController: {
                    return UIActivityViewController(activityItems: ["Check out BuSG, a smart bus tracker app!"], applicationActivities: [])
                }()),
                SettingsTableItem(title: "Rate on App Store", action: {
                    //URL.open(webURL: "itms-apps://itunes.apple.com/app/\(Bundle.main.bundleIdentifier)")
                }),
                SettingsTableItem(title: "Open-Sourced Repository", urlString: "https://github.com/theboi/BuSG"),
                SettingsTableItem(title: "Report an Issue", accessoryView: UISwitch()),
            ],
        ]
    }
    
    init(list: SettingsTableList? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.title = "Settings"
        self.tableView = UITableView(frame: CGRect(), style: .insetGrouped)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: K.identifiers.settings)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: UIAction(handler: { _ in
            self.dismiss(animated: true)
        }))
        self.listData = list ?? rootList
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func authStateDidChange(notification: NSNotification) {
        self.tableView.reloadData()
    }
    
    // MARK: UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return listData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellData = listData[indexPath.section][indexPath.row]
        let cell = cellData.customCell ?? tableView.dequeueReusableCell(withIdentifier: K.identifiers.settings, for: indexPath)
        
        cell.textLabel?.text = cellData.title
        if let accessoryView = cellData.accessoryView {
            cell.accessoryView = accessoryView
            cell.selectionStyle = .none
        } else if cellData.pushViewController != nil || cellData.presentViewController != nil || cellData.action != nil {
            cell.accessoryType = .disclosureIndicator
        } else if cellData.urlString != nil {
            cell.accessoryView = UIImageView(image: UIImage(systemName: "arrow.up.forward.app", withConfiguration: UIImage.SymbolConfiguration(weight: .medium)))
            cell.tintColor = .tertiaryLabel
        } else {
            cell.selectionStyle = .none
        }
        cell.imageView?.image = cellData.image
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return listData[indexPath.section][indexPath.row].height ?? K.cellHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = listData[indexPath.section][indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        cellData.action?()
        if let urlString = cellData.urlString {
            URL.open(webURL: urlString)
        }
        if let nextViewController = cellData.pushViewController {
            nextViewController.title = cellData.title
            self.navigationController?.pushViewController(nextViewController, animated: true)
        } else if let nextViewController = cellData.presentViewController {
            self.navigationController?.present(nextViewController, animated: true)
        }
    }
}
