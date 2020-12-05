//
//  BusNumberSheetController.swift
//  Navigem
//
//  Created by Ryan The on 29/11/20.
//

import UIKit
import MapKit

class BusServiceSheetController: SheetController {
    lazy var tableView = UITableView()
    
    let data = [
        "100"
    ]

    
    var busService: BusService!
    
    lazy var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let trailingButton = UIButton(type: .close, primaryAction: UIAction(handler: { (action) in
            self.popSheet()
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
        
        tableView.register(BusServiceTableViewCell.self, forCellReuseIdentifier: K.identifiers.busService)
    }
    
    init(for serviceNo: String?) {
        
        super.init()
        
        self.busService = ApiProvider.shared.getBusService(for: serviceNo ?? "1")
        self.headerView.titleText = busService.serviceNo
        self.headerView.detailText = busService.destinationCode
        
        LocationProvider.shared.delegate?.locationProvider(didRequestRouteFrom: busService.originBusStop, to: busService.destinationBusStop)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension BusServiceSheetController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busService?.busStops.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.identifiers.busService)
        cell?.backgroundColor = .clear
        cell?.selectedBackgroundView = FillView(solidWith: (UIScreen.main.traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black).withAlphaComponent(0.1))
        cell?.textLabel?.text = busService?.busStops[indexPath.row].busStopCode
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        present(BusStopSheetController(for: busService?.busStops[indexPath.row].busStopCode ?? "NULL"), animated: true)
    }
}


extension BusServiceSheetController: UITableViewDelegate, UITableViewDataSource {
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
        present(BusStopSheetController(for: "10"), animated: true)
    }
}
