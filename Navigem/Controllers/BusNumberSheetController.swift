//
//  BusNumberSheetController.swift
//  Navigem
//
//  Created by Ryan The on 29/11/20.
//

import UIKit

class BusNumberSheetController: SheetController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let trailingButton = UIButton(type: .close, primaryAction: UIAction(handler: { (action) in
            self.popSheet()
        }))
        headerView.trailingButton = trailingButton

        headerView.titleText = "100"
        headerView.detailText = "Singapore"
    }
    
    init(busStop: Int) {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
