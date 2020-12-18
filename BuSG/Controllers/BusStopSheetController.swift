//
//  BusStopSheetController.swift
//   BuSG
//
//  Created by Ryan The on 29/11/20.
//

import UIKit
import MapKit

class BusStopSheetController: SheetController {
    
    var busStop: BusStop!
    
    var busArrival: BusArrival?
    
    lazy var tableView = UITableView(frame: CGRect(), style: .grouped)
    
    lazy var refreshControl = UIRefreshControl(frame: CGRect(), primaryAction: UIAction(handler: {_ in
        self.reloadData()
    }))
    
    var timer: Timer? {
        didSet {
            timer?.fire()
        }
    }
    
    private func reloadData() {
        ApiProvider.shared.getBusArrivals(for: busStop.busStopCode) {busArrival in
            self.busArrival = busArrival
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        LocationProvider.shared.delegate?.locationProvider(didRequestNavigateTo: BusStopAnnotation(for: busStop))
        
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
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in self.reloadData() }
    }
    
    override func dismissSheet() {
        super.dismissSheet()
        timer?.invalidate()
    }
    
    override var isHidden: Bool {
        didSet {
            isHidden ? timer?.invalidate() : (timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in self.reloadData() })
        }
    }
    
    init(for busStopCode: String) {
        super.init()
        
        delegate = self
        
        busStop = ApiProvider.shared.getBusStop(with: busStopCode)
        
        headerView.titleLabel.text = busStop.roadDesc
        headerView.detailLabel.text = "\(busStop.busStopCode)  \(busStop.roadName)"
        
        tableView.register(BusArrivalTableViewCell.self, forCellReuseIdentifier: K.identifiers.busArrivalCell)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension BusStopSheetController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        busStop.busServices.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.identifiers.busArrivalCell, for: indexPath) as! BusArrivalTableViewCell
        let busServiceData = busStop.busServices[indexPath.row]
        cell.serviceNoLabel.text = busServiceData.serviceNo
        cell.destinationLabel.text = ApiProvider.shared.getBusStop(with: busServiceData.destinationCode)?.roadDesc
        cell.busService = busStop.busServices[indexPath.row]
        cell.busTimings = busArrival?.busServices[busServiceData.serviceNo]?.nextBuses
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        present(BusServiceSheetController(for: busStop.busServices[indexPath.row].serviceNo, in: busStop.busServices[indexPath.row].accessorBusRoute!.direction), animated: true)
    }

}

extension BusStopSheetController: SheetControllerDelegate {
    
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
        LocationProvider.shared.delegate?.locationProvider(didRequestNavigateTo: BusStopAnnotation(for: busStop))
    }
    
}
