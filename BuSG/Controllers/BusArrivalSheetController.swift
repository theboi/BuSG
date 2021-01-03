//
//  BusStopSheetController.swift
//   BuSG
//
//  Created by Ryan The on 29/11/20.
//

import UIKit
import MapKit

class BusArrivalSheetController: SheetController {
    
    var busStop: BusStop!
    
    var busArrival: BusArrival?
    
    var previewingIndexes = [Int: Int]()
    
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
    
    init(for busStop: BusStop) {
        super.init()
        
        self.busStop = busStop

        delegate = self
        
        headerView.titleLabel.text = busStop.roadDesc
        headerView.detailLabel.text = "\(busStop.busStopCode)  \(busStop.roadName)"
        
        tableView.register(BusArrivalTableViewCell.self, forCellReuseIdentifier: K.identifiers.busArrivalCell)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension BusArrivalSheetController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        busStop.busServices.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        previewingIndexes[indexPath.row] != nil ? K.sizes.cell.busArrivalMax : K.sizes.cell.busArrivalMin
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.identifiers.busArrivalCell, for: indexPath) as! BusArrivalTableViewCell
        let busServiceData = busStop.busServices[indexPath.row]
        cell.indexPath = indexPath
        cell.delegate = self
        cell.isPreviewing = previewingIndexes[indexPath.row] != nil
        cell.previewingTimingIndex = previewingIndexes[indexPath.row]
        switch busServiceData.serviceOperator {
        case .sbst: cell.busOperatorImage.image = UIImage(named: "BusOperatorLogoSBST")
        case .smrt: cell.busOperatorImage.image = UIImage(named: "BusOperatorLogoSMRT")
        case .gas: cell.busOperatorImage.image = UIImage(named: "BusOperatorLogoGAS")
        case .tts: cell.busOperatorImage.image = UIImage(named: "BusOperatorLogoTTS")
        default: break
        }
        cell.serviceNoLabel.text = busServiceData.serviceNo
        cell.originLabel.text = busServiceData.originBusStop?.roadDesc
        cell.destinationLabel.text = busServiceData.destinationBusStop?.roadDesc
        cell.busService = busStop.busServices[indexPath.row]
        cell.busTimings = busArrival?.busServices[busServiceData.serviceNo]?.nextBuses
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        present(BusServiceSheetController(for: busStop.busServices[indexPath.row], at: busStop.busStopCode), animated: true)
    }

}

extension BusArrivalSheetController: SheetControllerDelegate {
    
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

extension BusArrivalSheetController: BusServiceTableViewCellDelegate {
    
    func busArrivalTableViewCell(_ busArrivalTableViewCell: BusServiceTableViewCell, didSelectBusTimingButtonAt busTimingIndex: Int, forCellAt cellIndexPath: IndexPath) {
        let cell = tableView.cellForRow(at: cellIndexPath) as! BusArrivalTableViewCell

        if previewingIndexes[cellIndexPath.row] == busTimingIndex {
            previewingIndexes.removeValue(forKey: cellIndexPath.row)
        } else {
            previewingIndexes[cellIndexPath.row] = busTimingIndex
        }
        cell.isPreviewing = previewingIndexes[cellIndexPath.row] != nil
        cell.previewingTimingIndex = previewingIndexes[cellIndexPath.row]
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}