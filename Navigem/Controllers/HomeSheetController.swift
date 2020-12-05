//
//  HomeSheetController.swift
//  Navigem
//
//  Created by Ryan The on 28/11/20.
//

import UIKit

class HomeSheetController: SheetController {

    lazy var tableView = UITableView()
    
    var searchText: String = ""
    
    var suggestedServices: [BusService] = []
    
    var nearbyStops: [BusStop] = []
    
    private func reloadData() {
        ApiProvider.shared.getNearbyBusStops {busStops in
            self.nearbyStops = busStops
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
                
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search for a bus stop or service"
        searchBar.delegate = self
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
        
        tableView.register(BusServiceTableViewCell.self, forCellReuseIdentifier: K.identifiers.busService)
        
        reloadData()
    }
}

extension HomeSheetController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        nearbyStops.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.identifiers.busService)
        cell?.backgroundColor = .clear
        cell?.selectedBackgroundView = FillView(solidWith: (UIScreen.main.traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black).withAlphaComponent(0.1))
        cell?.textLabel?.text = nearbyStops[indexPath.row].busStopCode
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        present(BusStopSheetController(for: nearbyStops[indexPath.row].busStopCode), animated: true)
    }
}

extension HomeSheetController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let closeButton = UIButton(type: .system, primaryAction: UIAction(handler: { _ in
            searchBar.resignFirstResponder()
        }))
        closeButton.setTitle("Cancel", for: .normal)
        headerView.trailingButton = closeButton
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        self.tableView.reloadData()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        headerView.trailingButton = nil
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension HomeSheetController: SheetControllerDelegate {
    
    func sheetController(_ sheetController: SheetController, didUpdate state: SheetState) {
        UIView.animate(withDuration: 0.3) {
            switch state {
            case .min:
                self.tableView.layer.opacity = 0
            default:
                self.tableView.layer.opacity = 1
            }
        }
    }

    func sheetController(_ sheetController: SheetController, didReturnFromDismissalBy presentingSheetController: SheetController) {
        LocationProvider.shared.delegate?.locationProvider(didRequestNavigateToCurrentLocationWith: .one)
    }
    
}
