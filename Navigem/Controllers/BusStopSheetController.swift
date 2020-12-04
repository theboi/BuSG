//
//  BusStopSheetController.swift
//  Navigem
//
//  Created by Ryan The on 29/11/20.
//

import UIKit
import CoreLocation

class BusStopSheetController: SheetController {
    
    var busStop: BusStop?
    
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
        
        tableView.register(BusStopTableViewCell.self, forCellReuseIdentifier: K.identifiers.busStop)
    }
    
    init(for busStopCode: String?) {
        super.init()
        
        ApiProvider.shared.getBusStop(for: busStopCode ?? "00000") {busStop in
            self.busStop = busStop
            
            self.headerView.titleText = busStop?.roadName ?? "NULL"
            self.headerView.detailText = busStop?.roadDesc ?? "NULL"
            
            LocationProvider.shared.delegate?.locationProvider(didRequestNavigateTo: CLLocation(latitude: busStop?.latitude ?? 0, longitude: busStop?.longitude ?? 0), with: .one)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension BusStopSheetController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busStop!.busServices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.identifiers.busStop)
        cell?.backgroundColor = .clear
        cell?.selectedBackgroundView = FillView(solidWith: (UIScreen.main.traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black).withAlphaComponent(0.1))
        cell?.textLabel?.text = busStop?.busServices[indexPath.row].serviceNo
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        present(BusServiceSheetController(for: busStop?.busServices[indexPath.row].serviceNo), animated: true)
    }
}
