//
//  BusNumberSheetController.swift
// BuSG
//
//  Created by Ryan The on 29/11/20.
//

import UIKit
import MapKit

class BusServiceSheetController: SheetController {
    
    var busService: BusService!
    
    lazy var tableView = UITableView(frame: CGRect(), style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        let trailingButton = UIButton(type: .close, primaryAction: UIAction(handler: {_ in
            self.dismissSheet()
        }))
        headerView.trailingButton = trailingButton
        
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
        
        tableView.register(BusServiceTableViewCell.self, forCellReuseIdentifier: K.identifiers.busServiceCell)
    }
    
    init(for serviceNo: String?) {
        super.init()
        
        self.busService = ApiProvider.shared.getBusService(with: serviceNo ?? "1")
        self.headerView.titleText = busService.serviceNo
        self.headerView.detailText = busService.destinationCode
        
        LocationProvider.shared.delegate?.locationProvider(didRequestRouteFor: busService, in: 2)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension BusServiceSheetController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busService?.busStops.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        85
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.identifiers.busServiceCell, for: indexPath) as! BusServiceTableViewCell
        let busStopData = self.busService.busStops[indexPath.row]
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        present(BusStopSheetController(for: busService?.busStops[indexPath.row].busStopCode ?? K.nilStr), animated: true)
    }
}

extension BusServiceSheetController: SheetControllerDelegate {
    
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
        LocationProvider.shared.delegate?.locationProvider(didRequestRouteFor: busService, in: 1)
    }

}
