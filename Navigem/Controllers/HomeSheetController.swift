//
//  HomeSheetController.swift
//  Navigem
//
//  Created by Ryan The on 28/11/20.
//

import UIKit

class HomeSheetController: SheetController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let trailingButton = UIButton(type: .system, primaryAction: UIAction(handler: { (action) in
            
        }))
        trailingButton.setTitle("Cancel", for: .normal)
        headerView.trailingButton = trailingButton

        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        headerView.searchBar = searchBar
    }
}
