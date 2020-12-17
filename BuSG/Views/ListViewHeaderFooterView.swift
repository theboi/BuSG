//
//  ListViewHeaderFooterswift
//  BuSG
//
//  Created by Ryan The on 17/12/20.
//

import UIKit

class ListViewHeaderFooterView: UITableViewHeaderFooterView {

    public lazy var header = UILabel()
    public var trailingButton: UIButton?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        addSubview(header)
        header.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        header.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            header.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -K.margin.large),
            header.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.margin.extraLarge),
            header.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -K.margin.extraLarge),
        ])
        
        if let trailingButton = trailingButton {
            addSubview(trailingButton)
            trailingButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                trailingButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -K.margin.large),
                trailingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -K.margin.extraLarge),
            ])
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
