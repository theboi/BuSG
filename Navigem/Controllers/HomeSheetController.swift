//
//  HomeSheetController.swift
//  Navigem
//
//  Created by Ryan The on 28/11/20.
//

import UIKit

class HomeSheetController: SheetController {

    lazy var tableView = UITableView()
    
    let data = [
        "100"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search for a bus stop or service"
        headerView.searchBar = searchBar
        
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        
        contentView.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: tableView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
        ])
                
        do {
            try Provider.shared.getBusArrivals(for: "10079", completionBlock: {_ in
                
            })
        } catch {
            fatalError(error.localizedDescription)
        }
        
        tableView.register(BusServiceTimingsTableViewCell.self, forCellReuseIdentifier: K.identifiers.busService)
    }
}

extension HomeSheetController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.identifiers.busService)
        cell?.backgroundColor = .clear
        cell?.selectedBackgroundView = FillView(solidWith: (UIScreen.main.traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black).withAlphaComponent(0.1))
        cell?.textLabel?.text = data[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        present(BusServiceSheetController(for: "10"), animated: true)
    }
}
