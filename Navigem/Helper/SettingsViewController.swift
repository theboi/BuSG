//
//  SettingsViewController.swift
//  Navigem
//
//  Created by Ryan The on 7/12/20.
//

import UIKit

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
}

class SettingsViewController: UITableViewController {
    
    var listData: SettingsTableList!
    
    var defaultList: SettingsTableList {
        [
            [
                SettingsTableItem(title: "Auto Refresh Bus Timing", accessoryView: UISwitch()),
                SettingsTableItem(title: "Update Bus Data", accessoryView: UISwitch()),
                
            ],
            [
//                SettingsTableItem(title: "History", pushViewController: UIViewController()),
                SettingsTableItem(title: "Share with a Friend", accessoryView: UISwitch()),
                SettingsTableItem(title: "Rate on App Store", accessoryView: UISwitch()),
                SettingsTableItem(title: "Open Sourced Repository", action: {
                    if let url = URL(string: "https://github.com/theboi/BuSG") {
                        UIApplication.shared.open(url, options: [:])
                    }
                }),
                SettingsTableItem(title: "Report an Issue", accessoryView: UISwitch()),
            ],
        ]
    }
    
    init(list: SettingsTableList? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.title = "Settings"
        self.tableView = UITableView(frame: CGRect(), style: .insetGrouped)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: K.identifiers.settings)
        self.listData = list ?? defaultList
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
        } else if cellData.pushViewController != nil || cellData.presentViewController != nil {
            cell.accessoryType = .disclosureIndicator
        } else if cellData.action != nil {
        } else {
            cell.selectionStyle = .none
        }
        cell.imageView?.image = cellData.image
        
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return listData[indexPath.section][indexPath.row].height ?? tableView.rowHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = listData[indexPath.section][indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        cellData.action?()
        if let nextViewController = cellData.pushViewController {
            nextViewController.title = cellData.title
            self.navigationController?.pushViewController(nextViewController, animated: true)
        } else if let nextViewController = cellData.presentViewController {
            self.navigationController?.present(nextViewController, animated: true)
        }
    }
}
