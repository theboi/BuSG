//
//  BusStopSheetController.swift
//  Navigem
//
//  Created by Ryan The on 29/11/20.
//

import UIKit
import MapKit

class BusStopSheetController: SheetController {
    
    var busStop: BusStop!
    
    var busArrival: BusArrival?
    
    lazy var tableView = UITableView(frame: CGRect(), style: .grouped)
    
    lazy var refreshControl = UIRefreshControl(frame: CGRect(), primaryAction: UIAction(handler: { _ in
        self.reloadData()
    }))
    
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
        
        let trailingButton = UIButton(type: .close, primaryAction: UIAction(handler: { (action) in
            self.dismissSheet()
        }))
        headerView.trailingButton = trailingButton
        
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
        
        reloadData()
    }
    
    init(for busStopCode: String?) {
        super.init()
        
        delegate = self
        
        busStop = ApiProvider.shared.getBusStop(with: busStopCode ?? "00000")
        
        headerView.titleText = busStop.roadName
        headerView.detailText = busStop.roadDesc
        
        tableView.register(BusStopTableViewCell.self, forCellReuseIdentifier: K.identifiers.busStop)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension BusStopSheetController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busStop.busServices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.identifiers.busStop, for: indexPath) as! BusStopTableViewCell
        cell.backgroundColor = .clear
        cell.selectedBackgroundView = FillView(solidWith: (UIScreen.main.traitCollection.userInterfaceStyle == .dark ? UIColor.white : UIColor.black).withAlphaComponent(0.1))
        cell.serviceNoLabel.text = busStop.busServices[indexPath.row].serviceNo
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        cell.busTimingLabels.enumerated().forEach { (index, label) in
            let optionalBusArrival = busArrival?.busServices[busStop.busServices[indexPath.row].serviceNo]
            if let estimatedArrival = optionalBusArrival?.nextBuses[index].estimatedArrival, estimatedArrival != "" {
                cell.stackView.isHidden = false
                cell.errorLabel.text = ""
                let date = dateFormatter.date(from: estimatedArrival)!
                let arrTime = Calendar.current.dateComponents([.minute], from: Date(), to: date).minute!
                if arrTime <= 0 { label.text = "Arr" }
                else { label.text = String(arrTime) }
                if arrTime < 0 { label.textColor = UIColor.label.withAlphaComponent(0.3) }
                
            } else if optionalBusArrival == nil {
                /// Bus Service not operating
                cell.stackView.isHidden = true
                cell.errorLabel.text = "Not In Operation"
            } else {
                /// Bus service stopped due to night time etc.
                label.text = "-"
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        present(BusServiceSheetController(for: busStop.busServices[indexPath.row].serviceNo), animated: true)
    }

}

extension BusStopSheetController: SheetControllerDelegate {
    
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
        LocationProvider.shared.delegate?.locationProvider(didRequestNavigateTo: BusStopAnnotation(for: busStop))
    }
    
}
