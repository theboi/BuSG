//
//  SettingsViewController.swift
//   BuSG
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
    var action: ((UITableViewController, ListData, IndexPath) -> Void)?
    var urlString: String?
    var isClickable: Bool = true
    var checkmark: CheckmarkState = .none
}

class ListSection {
    var items: [ListItem]
    var headerText: String?
    var footerText: String?
    var headerTrailingButton: UIButton?
    
    init(items: [ListItem] = [], headerText: String? = nil, footerText: String? = nil, headerTrailingButton: UIButton? = nil) {
        self.items = items
        self.headerText = headerText
        self.footerText = footerText
        self.headerTrailingButton = headerTrailingButton
    }
    
}

class ListData {
    var sections: [ListSection]
    var headerView: UIView?
    var footerView: UIView?
    
    init(sections: [ListSection], headerView: UIView? = nil, footerView: UIView? = nil) {
        self.sections = sections
    }
    
}

class SelectListSection: ListSection {
    
    init(items: [ListItem], headerText: String? = nil, footerText: String? = nil, headerTrailingButton: UIButton? = nil, defaultIndex: Int, onSelected: ((ListSection, UITableView, IndexPath) -> Void)? = nil) {
        super.init(items: items, headerText: headerText, footerText: footerText, headerTrailingButton: headerTrailingButton) // TODO: shouldCheckElement instead of controlling checkmarks from view (set from model)
        
        func selectItem(at index: Int, for tableView: UITableView? = nil) {
            for j in 0...items.count-1 {
                self.items[j].checkmark = .off
            }
            self.items[index].checkmark = .on
            tableView?.reloadData()
        }
        
        selectItem(at: defaultIndex)
        
        for i in 0...items.count-1 {
            let oldAction = self.items[i].action
            self.items[i].action = {tableViewController, listData, indexPath in
                oldAction?(tableViewController, listData, indexPath)
                onSelected?(self, tableViewController.tableView, indexPath)
                selectItem(at: i, for: tableViewController.tableView)
            }
        }
    }
    
}

class ListViewController: UITableViewController {
    
    var data: ListData!
    
    init(data: ListData) {
        super.init(nibName: nil, bundle: nil)
        self.data = data
        tableView = UITableView(frame: CGRect(), style: .insetGrouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: K.identifiers.settingsCell)
        tableView.register(ListViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: K.identifiers.listViewHeader)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionData = data.sections[section]
        
        if let headerText = sectionData.headerText {
            let headerView = (tableView.dequeueReusableHeaderFooterView(withIdentifier: K.identifiers.listViewHeader) ?? ListViewHeaderFooterView(reuseIdentifier: K.identifiers.listViewHeader)) as! ListViewHeaderFooterView
            headerView.header.text = headerText
            headerView.trailingButton = sectionData.headerTrailingButton ?? UIButton(frame: .zero)
            return headerView
        }
        
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        data.sections[section].headerText != nil ? 60 : 20
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        data.sections[section].footerText
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return data.sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.sections[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellData = data.sections[indexPath.section].items[indexPath.row]
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
        return data.sections[indexPath.section].items[indexPath.row].height ?? K.cellHeight
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellData = data.sections[indexPath.section].items[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        cellData.action?(self, data, indexPath)
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
