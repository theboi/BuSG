//
//  LaunchViewController.swift
//  BuSG
//
//  Created by Ryan The on 8/12/20.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        isModalInPresentation = true

        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 100), primaryAction: UIAction(handler: { _ in
            self.dismiss(animated: true)
        }))
        button.backgroundColor = .red
        view.addSubview(button)
    }

}
