//
//  BottomSheetView.swift
//  Navigem
//
//  Created by Ryan The on 17/11/20.
//

import UIKit

class BottomSheetView: UIView {

    var tableView: UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let text = UILabel(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
        text.text = "Helo"
        self.backgroundColor = .red
        self.addSubview(text)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
