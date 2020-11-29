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
        
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        headerView.searchBar = searchBar
    }
}
