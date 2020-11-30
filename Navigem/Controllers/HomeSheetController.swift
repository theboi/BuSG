//
//  HomeSheetController.swift
//  Navigem
//
//  Created by Ryan The on 28/11/20.
//

import UIKit

class HomeSheetController: SheetController {

    lazy var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        headerView.searchBar = searchBar
        
        contentView.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: tableView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
        ])
                
//        do {
//            try DataMallProvider.getBusStop()
//        } catch {
//            fatalError(error.localizedDescription)
//        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.present(BusStopSheetController(), animated: true)
        }
    }
}
