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
    var action: ((ListViewController, ListData, IndexPath) -> Void)?
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

struct ListData {
    var sections: [ListSection]
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
            self.items[i].action = {listViewController, listData, indexPath in
                oldAction?(listViewController, listData, indexPath)
                onSelected?(self, listViewController.tableView, indexPath)
                selectItem(at: i, for: listViewController.tableView)
            }
        }
    }
    
}

class ListViewController: UIViewController {
    
    var headerView = UIView()
    var footerView = UIView()
    
    let tableView = UITableView(frame: CGRect(), style: .insetGrouped)
    
    var data: ListData!
    
    init(data: ListData, headerView: UIView? = nil, footerView: UIView? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.data = data
        
        if let headerView = headerView {
            self.headerView = headerView
        }
        
        if let footerView = footerView {
            self.footerView = footerView
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: K.identifiers.settingsCell)
        tableView.register(ListViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: K.identifiers.listViewHeader)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.heightAnchor.constraint(equalToConstant: headerView.frame.height),
        ])
        
        view.addSubview(footerView)
        footerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            footerView.heightAnchor.constraint(equalToConstant: footerView.frame.height),
        ])
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: footerView.topAnchor)
        ])
    }
    
}

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionData = data.sections[section]
        
        if let headerText = sectionData.headerText {
            let headerView = (tableView.dequeueReusableHeaderFooterView(withIdentifier: K.identifiers.listViewHeader) ?? ListViewHeaderFooterView(reuseIdentifier: K.identifiers.listViewHeader)) as! ListViewHeaderFooterView
            headerView.header.text = headerText
            headerView.trailingButton = sectionData.headerTrailingButton ?? UIButton(frame: .zero)
            return headerView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        data.sections[section].headerText != nil ? 60 : 20
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        data.sections[section].footerText
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellData = data.sections[indexPath.section].items[indexPath.row]
        let cell = cellData.customCell ?? tableView.dequeueReusableCell(withIdentifier: K.identifiers.settingsCell, for: indexPath)
        
        if let textField = cellData.textField {
            cell.addSubview(textField)
            dismissKeyboardWhenTapAround()
            textField.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                textField.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: K.margin.two),
                textField.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: -K.margin.two),
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
    
}

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return data.sections[indexPath.section].items[indexPath.row].height ?? K.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
