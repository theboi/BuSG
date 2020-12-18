//
//  HomeSheetController.swift
//   BuSG
//
//  Created by Ryan The on 28/11/20.
//

import UIKit
import CoreLocation

class HomeSheetController: SheetController {

    lazy var searchBar = UISearchBar()
    
    lazy var tableView = UITableView(frame: CGRect(), style: .grouped)
    
    lazy var refreshControl = UIRefreshControl(frame: CGRect(), primaryAction: UIAction(handler: { _ in
        self.reloadData()
    }))
    
    var searchText: String = ""
    
    var suggestedServices: [BusSuggestion] = []
    
    var nearbyStops: [BusStop] = []
    
    var searchBusServices: [BusService] {
        ApiProvider.shared.getBusServices(containing: searchText.lowercased())
    }
    
    var searchBusStops: [BusStop] {
        ApiProvider.shared.getBusStops(containing: searchText.lowercased())
    }
    
    private func reloadData() {
        nearbyStops = ApiProvider.shared.getBusStops(nearby: LocationProvider.shared.currentLocation.coordinate)
        ApiProvider.shared.getSuggestedServices { busData in
            self.suggestedServices = busData
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Search for a bus stop or service"
        searchBar.delegate = self
        
        let closeButton = UIButton(type: .system, primaryAction: UIAction(handler: { _ in
            self.searchBar.resignFirstResponder()
            self.headerView.trailingButtonIsHidden = true
        }))
        closeButton.setTitle("Cancel", for: .normal)
        headerView.trailingButton = closeButton
        
        headerView.customView.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: headerView.customView.topAnchor),
            searchBar.bottomAnchor.constraint(equalTo: headerView.customView.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: headerView.customView.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: headerView.customView.trailingAnchor),
        ])
        
        tableView.addSubview(refreshControl)
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
        
        tableView.register(BusArrivalTableViewCell.self, forCellReuseIdentifier: K.identifiers.busArrivalCell)
        tableView.register(BusStopTableViewCell.self, forCellReuseIdentifier: K.identifiers.busStopCell)
        tableView.register(BusServiceTableViewCell.self, forCellReuseIdentifier: K.identifiers.busServiceCell)
        tableView.register(BusSuggestionTableViewCell.self, forCellReuseIdentifier: K.identifiers.busSuggestionCell)

        reloadData()
    }
}

extension HomeSheetController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchText.count == 0 {
            switch section {
            case 0: return suggestedServices.isEmpty ? nearbyStops.count : suggestedServices.count
            case 1: fallthrough
            default: return nearbyStops.count
            }
        } else {
            switch section {
            case 0: return searchBusServices.count
            case 1: fallthrough
            default: return searchBusStops.count
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searchText.count == 0 {
            return suggestedServices.isEmpty ? 1 : 2
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if searchText.count == 0 {
            switch section {
            case 0: return suggestedServices.isEmpty ? "Nearby" : "Suggested"
            case 1: fallthrough
            default: return "Nearby"
            }
        } else {
            switch section {
            case 0: return "Bus Services"
            case 1: fallthrough
            default: return "Bus Stops"
            }
        }
    }
        
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if searchText.count == 0 {
            switch indexPath.section {
            case 0: return suggestedServices.isEmpty ? 85 : 55
            case 1: fallthrough
            default: return 85
            }
        } else {
            switch indexPath.section {
            case 0: return 65
            case 1: fallthrough
            default: return 85
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let busSuggestionCell = { () -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: K.identifiers.busSuggestionCell, for: indexPath) as! BusSuggestionTableViewCell
            let suggestedBusData = self.suggestedServices[indexPath.row]
            cell.eventImage = UIImage(systemName: "calendar")
            cell.serviceNoLabel.text = suggestedBusData.busService.serviceNo
            cell.destinationLabel.text = suggestedBusData.originBusStop.rawRoadDesc
            cell.eventLabel.text = suggestedBusData.event.title
            return cell
        }
        
        let busStopCell = { (busStops: [BusStop]) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: K.identifiers.busStopCell, for: indexPath) as! BusStopTableViewCell
            let busStopData = busStops[indexPath.row]
            cell.busServices = busStopData.busServices
            cell.roadDescLabel.text = busStopData.roadDesc
            cell.busStopCodeLabel.text = busStopData.busStopCode
            cell.roadNameLabel.text = busStopData.roadName
            let distance = LocationProvider.shared.distanceFromCurrentLocation(to: CLLocation(latitude: busStopData.latitude, longitude: busStopData.longitude))
            if distance > 100 {
                cell.distanceLabel.text = "\(String(format: "%.2f", distance/1000)) km"
            } else {
                cell.distanceLabel.text = "\(String(format: "%.1f", distance)) m"
            }
            return cell
        }
        
        let busServiceCell = { () -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: K.identifiers.busServiceCell, for: indexPath) as! BusServiceTableViewCell
            let busServiceData = self.searchBusServices[indexPath.row]
            cell.serviceNoLabel.text = busServiceData.serviceNo
            cell.destinationLabel.text = ApiProvider.shared.getBusStop(with: busServiceData.destinationCode)?.roadDesc
            cell.busService = busServiceData
            return cell
        }
        
        if searchText.count == 0 {
            switch indexPath.section {
            case 0: return suggestedServices.isEmpty ? busStopCell(nearbyStops) : busSuggestionCell()
            case 1: fallthrough
            default: return busStopCell(nearbyStops)
            }
        } else {
            switch indexPath.section {
            case 0: return busServiceCell()
            case 1: fallthrough
            default: return busStopCell(searchBusStops)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let busSuggestionSheetController = {
            BusStopSheetController(for: self.suggestedServices[indexPath.row].originBusStop.busStopCode)
        }
        let busStopSheetController = { (busStops: [BusStop]) -> BusStopSheetController in
            BusStopSheetController(for: busStops[indexPath.row].busStopCode)
        }
        let busServiceSheetController = {
            // FIXME: BUS SERVICE SHEET CONTROLLER NOT SHOWING
            BusServiceSheetController(for: self.searchBusServices[indexPath.row].serviceNo, in: self.searchBusServices[indexPath.row].direction)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
        if searchText.count == 0 {
            switch indexPath.section {
            case 0:
                present(suggestedServices.isEmpty ? busStopSheetController(nearbyStops) : busSuggestionSheetController(), animated: true)
            case 1: fallthrough
            default:
                present(busStopSheetController(nearbyStops), animated: true)
            }
        } else {
            switch indexPath.section {
            case 0:
                present(busServiceSheetController(), animated: true)
            case 1: fallthrough
            default:
                present(busStopSheetController(searchBusStops), animated: true)
            }
        }
    }
}

extension HomeSheetController: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        headerView.trailingButtonIsHidden = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        self.tableView.reloadData()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        headerView.trailingButtonIsHidden = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        headerView.trailingButtonIsHidden = true
        searchBar.resignFirstResponder()
    }
}

extension HomeSheetController: SheetControllerDelegate {
    
    func sheetController(_ sheetController: SheetController, didUpdate state: SheetState) {
        UIView.animate(withDuration: 0.3) {
            switch state {
            case .minimized:
                self.tableView.layer.opacity = 0
            default:
                self.tableView.layer.opacity = 1
            }
        }
    }

    func sheetController(_ sheetController: SheetController, didReturnFromDismissalBy presentingSheetController: SheetController) {
        LocationProvider.shared.delegate?.locationProviderDidRequestNavigateToCurrentLocation()
    }
    
}
