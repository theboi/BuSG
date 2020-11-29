//
//  HeaderSheetView.swift
//  Navigem
//
//  Created by Ryan The on 28/11/20.
//

import UIKit

class SheetHeaderView: UIView {
    
    var textView: UIStackView!
    
    var titleText: String? {
        didSet { updateHeader() }
    }
    
    var detailText: String? {
        didSet { updateHeader() }
    }
    
    /// An optional trailing button such as close or cancel buttons.
    var trailingButton: UIButton? {
        didSet { updateHeader() }
        willSet { trailingButton?.removeFromSuperview() }
    }
    
    /// An optional search bar. Setting this will override `textView` and cause it to be hidden.
    var searchBar: UISearchBar? {
        didSet { updateHeader() }
    }
    
    private func updateHeader() {
        if let trailingButton = trailingButton {
            self.addSubview(trailingButton)
            trailingButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            trailingButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                trailingButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -K.margin.large),
                trailingButton.topAnchor.constraint(equalTo: self.topAnchor, constant: K.margin.large),
            ])
        }
        
        if let searchBar = searchBar {
            self.addSubview(searchBar)
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                searchBar.topAnchor.constraint(equalTo: self.topAnchor, constant: K.margin.small-2),
                searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: K.margin.small),
                searchBar.trailingAnchor.constraint(equalTo: trailingButton?.leadingAnchor ?? self.trailingAnchor, constant: -K.margin.small),
            ])
            return
        }
        
        if let titleText = titleText, let detailText = detailText {
            let titleLabel = UILabel()
            titleLabel.text = titleText
            let detailLabel = UILabel()
            detailLabel.text = detailText
            textView = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
            textView.axis = .vertical
            self.addSubview(textView)
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.setContentHuggingPriority(.defaultLow, for: .horizontal)
            NSLayoutConstraint.activate([
                textView.topAnchor.constraint(equalTo: self.topAnchor, constant: K.margin.large),
                textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: K.margin.large),
                textView.trailingAnchor.constraint(equalTo: trailingButton?.leadingAnchor ?? self.trailingAnchor, constant: -K.margin.large),
            ])
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateHeader()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
