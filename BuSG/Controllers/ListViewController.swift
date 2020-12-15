//
//  SettingsViewController.swift
// BuSG
//
//  Created by Ryan The on 7/12/20.
//

import UIKit
import StoreKit

enum CheckmarkState {
    case none, on, off
}

struct ListItem {
    var title: String?
    var image: UIImage?
    var height: CGFloat?
    var customCell: UITableViewCell?
    var textField: UITextField?
    var accessoryView: UIView?
    var pushViewController: UIViewController?
    var presentViewController: UIViewController?
    var action: ((UITableView) -> Void)?
    var urlString: String?
    var isClickable: Bool = true
    var checkmark: CheckmarkState = .none
}

class ListSection {
    
    var tableItems: [ListItem]
    var headerText: String?
    var footerText: String?
    var headerTrailingButton: UIButton?
    
    init(tableItems: [ListItem] = [], headerText: String? = nil, footerText: String? = nil, headerTrailingButton: UIButton? = nil) {
        self.tableItems = tableItems
        self.headerText = headerText
        self.footerText = footerText
        self.headerTrailingButton = headerTrailingButton
    }
    
}

class SelectListSection: ListSection {
        
    init(tableItems: [ListItem] = [], headerText: String? = nil, footerText: String? = nil, headerTrailingButton: UIButton? = nil, onSelected: ((ListSection) -> Void)? = nil) {
        super.init(tableItems: tableItems, headerText: headerText, footerText: footerText, headerTrailingButton: headerTrailingButton)
        
        func selectItem(at index: Int, for tableView: UITableView? = nil) {
            for j in 0...tableItems.count-1 {
                self.tableItems[j].checkmark = .off
            }
            self.tableItems[index].checkmark = .on
            tableView?.reloadData()
        }
        
        selectItem(at: 0)
        
        for i in 0...tableItems.count-1 {
            let oldAction = self.tableItems[i].action
            self.tableItems[i].action = {tableView in
                oldAction?(tableView)
                onSelected?(self)
                selectItem(at: i, for: tableView)
            }
        }
    }
    
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
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: K.margin.extraLarge),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -K.margin.extraLarge),
        ])
        
        if let button = sectionData.headerTrailingButton {
            view.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -K.margin.large),
                button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -K.margin.extraLarge),
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
        cell.selectionStyle = cellData.isClickable ? .default : .none
        if let accessoryView = cellData.accessoryView {
            cell.accessoryView = accessoryView
        } else if cellData.pushViewController != nil || cellData.presentViewController != nil || cellData.action != nil {
            cell.accessoryType = .disclosureIndicator
        } else if cellData.urlString != nil {
            cell.accessoryView = UIImageView(image: UIImage(systemName: "arrow.up.forward.app", withConfiguration: UIImage.SymbolConfiguration(weight: .medium)))
            cell.tintColor = .tertiaryLabel
        } else {
            cell.selectionStyle = .none
        }
        cell.imageView?.image = cellData.image
        if cellData.checkmark == .on {
            cell.accessoryType = .checkmark
        } else if cellData.checkmark == .off {
            cell.accessoryType = .none
        }
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return listData[indexPath.section].tableItems[indexPath.row].height ?? K.cellHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = listData[indexPath.section].tableItems[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        cellData.action?(tableView)
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
