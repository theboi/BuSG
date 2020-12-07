//
//  SettingsViewController.swift
//  Navigem
//
//  Created by Ryan The on 7/12/20.
//

import UIKit

typealias SettingsAction = () -> Void
typealias SettingsList = () -> [[SettingsTableItem]]
struct SettingsTableItem {
    var title: String
    var image: UIImage?
    var height: CGFloat?
    var customCell: UITableViewCell?
    var accessoryView: UIView?
    var pushViewController: UIViewController?
    var presentViewController: UIViewController?
    var action: SettingsAction?
}

class SettingsViewController: UITableViewController {
    
    var listData: SettingsList!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var defaultList: SettingsList {
        { () -> [[SettingsTableItem]] in
            return [
                [
                    SettingsTableItem(title: "Privacy", presentViewController: { () -> UIAlertController in
                        let privacyAlert = UIAlertController(title: "Privacy", message: "Your data will be kept private and confidential... hopefully...", preferredStyle: .alert)
                        privacyAlert.addAction(UIAlertAction(title: "OK", style: .default))
                        return privacyAlert
                    }()),
                ],
                [
//                    SettingsTableItem(title: "History", pushViewController: UIViewController()),
                    SettingsTableItem(title: "Privacy", presentViewController: { () -> UIAlertController in
                        let privacyAlert = UIAlertController(title: "Privacy", message: "Your data will be kept private and confidential... hopefully...", preferredStyle: .alert)
                        privacyAlert.addAction(UIAlertAction(title: "OK", style: .default))
                        return privacyAlert
                    }()),
                ],
            ]
        }
    }
    
    init(list: SettingsList? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.title = "Settings"
        self.tableView = UITableView(frame: CGRect(), style: .insetGrouped)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "settingsTableViewCell")
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
        return listData().count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData()[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellData = listData()[indexPath.section][indexPath.row]
        let cell = cellData.customCell ?? tableView.dequeueReusableCell(withIdentifier: "settingsTableViewCell", for: indexPath)
        
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
        return listData()[indexPath.section][indexPath.row].height ?? tableView.rowHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = listData()[indexPath.section][indexPath.row]
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
