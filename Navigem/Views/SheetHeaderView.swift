//
//  HeaderSheetView.swift
//  Navigem
//
//  Created by Ryan The on 28/11/20.
//

import UIKit

class SheetHeaderView: UIView {
    
    private var stackView = UIStackView(arrangedSubviews: [UIView(), UIView()])
    
    /// An optional trailing button such as close or cancel buttons.
    var trailingButton: UIButton? {
        didSet {
            if let trailingButton = trailingButton {
                stackView.insertArrangedSubview(trailingButton, at: 1)
            }
        }
        willSet {
//            if let trailingButton = trailingButton {
//                stackView.removeArrangedSubview(trailingButton)
//            }
        }
    }
    
    /// An optional search bar. Setting this will override `textView` and cause it to be hidden.
    var searchBar: UISearchBar? {
        didSet {
            if let searchBar = searchBar {
                stackView.insertArrangedSubview(searchBar, at: 0)
            }
        } willSet {
//            if let searchBar = searchBar {
//                stackView.removeArrangedSubview(searchBar)
//            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(stackView)
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: K.margin.large),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: K.margin.large),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -K.margin.large),
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
