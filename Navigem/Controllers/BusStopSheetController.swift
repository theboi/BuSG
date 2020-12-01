//
//  BusStopSheetController.swift
//  Navigem
//
//  Created by Ryan The on 29/11/20.
//

import UIKit

class BusStopSheetController: SheetController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let trailingButton = UIButton(type: .close, primaryAction: UIAction(handler: { (action) in
            self.popSheet()
        }))
        headerView.trailingButton = trailingButton
    }
    
    init(for busStopCode: String) {
        super.init()
        
        headerView.titleText = String(busStopCode)
        headerView.detailText = "Singapore"
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
