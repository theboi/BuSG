//
//  BusLocationsTableViewCell.swift
//  Navigem
//
//  Created by Xavier Koh on 5/12/20.
//

import UIKit

class BusLocationsTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        print("selected 2")
    }
    
}
