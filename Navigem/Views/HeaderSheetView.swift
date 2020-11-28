//
//  HeaderSheetView.swift
//  Navigem
//
//  Created by Ryan The on 28/11/20.
//

import UIKit

class HeaderSheetView: UIView {

    /// An optional trailing button such as close or cancel buttons.
    var trailingButton: UIButton? {
        didSet {
            if let trailingButton = trailingButton {
                self.addSubview(trailingButton)
                
                trailingButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    trailingButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -K.margin.large),
                    trailingButton.topAnchor.constraint(equalTo: self.topAnchor, constant: K.margin.large),
                ])
            }
        }
        willSet {
            trailingButton?.removeFromSuperview()
        }
    }
    
    var title: String? {
        didSet {
            
        }
    }
    
    var detail: String? = nil
    
    private var textView = {
        return UIView()
    }()
    
    /// An optional search bar. Setting this will override `textView` and cause it to be hidden.
    var searchBar: UISearchBar? {
        didSet {
            if let searchBar = searchBar {
                self.addSubview(searchBar)
                
                searchBar.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    searchBar.topAnchor.constraint(equalTo: self.topAnchor, constant: K.margin.small),
                    searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: K.margin.small),
                    searchBar.trailingAnchor.constraint(equalTo: trailingButton?.leadingAnchor ?? self.trailingAnchor, constant: -K.margin.small),
                ])
            }
        }
    }
}
