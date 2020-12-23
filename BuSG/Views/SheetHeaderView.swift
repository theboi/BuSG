//
//  HeaderSheetView.swift
//   BuSG
//
//  Created by Ryan The on 28/11/20.
//

import UIKit

class SheetHeaderView: UIView {
    
    private var textView: UIStackView!
        
    public lazy var titleLabel = UILabel()
    public lazy var detailLabel = UILabel()
    
    public var trailingButton: UIButton!
    
    init(for sheetController: SheetController) {
        super.init(frame: CGRect())
        
        trailingButton = UIButton(type: .close, primaryAction: UIAction(handler: { _ in
            sheetController.dismissSheet()
        }))
        
        addSubview(trailingButton)
        trailingButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        trailingButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            trailingButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -K.margin.two),
            trailingButton.topAnchor.constraint(equalTo: topAnchor, constant: K.margin.two),
        ])
        
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        
        textView = UIStackView(arrangedSubviews: [titleLabel, detailLabel])
        textView.axis = .vertical
        addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: topAnchor, constant: K.margin.two),
            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: K.margin.two),
            textView.trailingAnchor.constraint(equalTo: trailingButton.leadingAnchor, constant: -K.margin.two),
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
