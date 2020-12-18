//
//  HeaderSheetView.swift
//   BuSG
//
//  Created by Ryan The on 28/11/20.
//

import UIKit

class SheetHeaderView: UIView {
    
    private lazy var trailingButtonWidthConstraint = {
        trailingButton?.widthAnchor.constraint(equalToConstant: 0)
    }()
        
    public var trailingButtonIsHidden = true {
        didSet {
            trailingButtonWidthConstraint?.isActive = trailingButtonIsHidden
        }
    }
    
    private var textView: UIStackView!
    
    public lazy var customView = UIView()
    
    public lazy var titleLabel = UILabel()
    public lazy var detailLabel = UILabel()
    
    /// An optional trailing button such as close or cancel buttons.
    public var trailingButton: UIButton? {
        didSet {
            if let trailingButton = trailingButton {
                addSubview(trailingButton)
                trailingButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
                trailingButton.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    trailingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -K.margin.small),
                    trailingButton.topAnchor.constraint(equalTo: topAnchor, constant: K.margin.large),
                ])
                trailingButtonWidthConstraint?.isActive = true
                customView.trailingAnchor.constraint(equalTo: trailingButton.leadingAnchor).isActive = true
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: topAnchor, constant: K.margin.small-2),
            customView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.margin.small),
        ])
        
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        textView = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
        textView.axis = .vertical
        addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor, constant: K.margin.large),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.margin.large),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -K.margin.large),
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
