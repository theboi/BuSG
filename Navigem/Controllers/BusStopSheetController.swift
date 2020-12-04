//
//  BusStopSheetController.swift
//  Navigem
//
//  Created by Ryan The on 29/11/20.
//

import UIKit

class BusStopSheetController: SheetController {
    
    var busStop: BusStop?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let trailingButton = UIButton(type: .close, primaryAction: UIAction(handler: { (action) in
            self.popSheet()
        }))
        headerView.trailingButton = trailingButton
    }
    
    init(for busStopCode: String) {
        super.init()
        
        ApiProvider.shared.getBusStop(for: busStopCode) {busStop in
            self.busStop = busStop
            
            self.headerView.titleText = busStop.roadName
            self.headerView.detailText = busStop.roadDesc
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
