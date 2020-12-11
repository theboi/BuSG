//
//  SettingsViewController.swift
//  Navigem
//
//  Created by Ryan The on 7/12/20.
//

import UIKit
import StoreKit

struct ListItem {
    var title: String?
    var image: UIImage?
    var height: CGFloat?
    var customCell: UITableViewCell?
    var textField: UITextField?
    var accessoryView: UIView?
    var pushViewController: UIViewController?
    var presentViewController: UIViewController?
    var action: (() -> Void)?
    var urlString: String?
}

struct ListSection {
    var tableItems: [ListItem]
    var headerText: String?
    var footerText: String?
    var headerTrailingButton: UIButton?
}

class ListViewController: UITableViewController {
    
    var listData: [ListSection]!
    
    init(tableData: [ListSection] = []) {
        super.init(nibName: nil, bundle: nil)
        self.listData = tableData
        tableView = UITableView(frame: CGRect(), style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: K.identifiers.settingsCell)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: K.identifiers.settingsHeader)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionData = listData[section]
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: K.identifiers.settingsHeader)!
        
        let label = UILabel()
        view.addSubview(label)
        label.text = sectionData.headerText
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -K.margin.large),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: K.margin.large+K.margin.small),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -K.margin.large-K.margin.small),
        ])
        
        if let button = sectionData.headerTrailingButton {
            view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -K.margin.large),
                button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -K.margin.large-K.margin.small),
            ])
        }
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        listData[section].headerText != nil ? 60 : 20
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        listData[section].footerText
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return listData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listData[section].tableItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellData = listData[indexPath.section].tableItems[indexPath.row]
        let cell = cellData.customCell ?? tableView.dequeueReusableCell(withIdentifier: K.identifiers.settingsCell, for: indexPath)
        
        if let textField = cellData.textField {
            cell.addSubview(textField)
            dismissKeyboardWhenTapAround()
            textField.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                textField.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: K.margin.large),
                textField.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -K.margin.large),
                textField.topAnchor.constraint(equalTo: cell.topAnchor),
                textField.bottomAnchor.constraint(equalTo: cell.bottomAnchor),
            ])
        } else {
            cell.textLabel?.text = cellData.title
        }
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
        return listData[indexPath.section].tableItems[indexPath.row].height ?? K.cellHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = listData[indexPath.section].tableItems[indexPath.row]
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
