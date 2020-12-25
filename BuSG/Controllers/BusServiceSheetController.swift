//
//  BusNumberSheetController.swift
//   BuSG
//
//  Created by Ryan The on 29/11/20.
//

import UIKit
import MapKit

class BusServiceSheetController: SheetController {
    
    var busService: BusService!
    
    lazy var previewingIndex: Int = {
        visitingIndex
    }()
    
    var visitingIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self

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
        
        tableView.register(BusStopTableViewCell.self, forCellReuseIdentifier: K.identifiers.busStopCell)
        
        tableView.scrollToRow(at: IndexPath(row: visitingIndex, section: 0), at: .top, animated: false)
    }
    
    init(for busService: BusService, at busStopCode: String? = nil) {
        super.init()

        self.visitingIndex = busService.busStops.firstIndex(where: { (busStop: BusStop) -> Bool in
            busStop.busStopCode == busStopCode
        }) ?? 0
        self.busService = busService
        
        headerView.titleLabel.text = busService.serviceNo
        if let originDesc = busService.originBusStop?.roadDesc, let destinationDesc = busService.destinationBusStop?.roadDesc {
            if originDesc != destinationDesc {
                self.headerView.detailLabel.text = "\(originDesc) → \(destinationDesc)"
            } else {
                self.headerView.detailLabel.text = originDesc
            }
        }
        
        LocationProvider.shared.delegate?.locationProvider(didRequestRouteFor: busService)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension BusServiceSheetController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        busService.busStops.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        85
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.identifiers.busStopCell, for: indexPath) as! BusStopTableViewCell
        let busStopData = self.busService.busStops[indexPath.row]
        
        cell.delegate = self
        cell.indexPath = indexPath
        
        cell.isBeginning = indexPath.row == 0
        cell.isEnd = indexPath.row == busService.busStops.count - 1
        cell.isPreviewing = indexPath.row == previewingIndex
        cell.isVisited = indexPath.row < visitingIndex
        
        cell.busServices = busStopData.busServices
        cell.roadDescLabel.text = busStopData.roadDesc
        cell.busStopCodeLabel.text = busStopData.busStopCode
        cell.roadNameLabel.text = busStopData.roadName
        cell.showSequence = true
        cell.setNeedsDisplay()
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        present(BusStopSheetController(for: busService.busStops[indexPath.row]), animated: true)
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
        LocationProvider.shared.delegate?.locationProvider(didRequestRouteFor: busService)
    }

}

extension BusServiceSheetController: BusStopTableViewCellDelegate {
    
    func busStopTableViewCell(_ busStopTableViewCell: BusStopTableViewCell, didPressSequenceButtonAt index: Int) {
        previewingIndex = index
        LocationProvider.shared.delegate?.locationProvider(didRequestNavigateTo: CLLocation(coordinate: busService.busStops[previewingIndex].coordinate))
        tableView.reloadData()
    }
    
}
