//
//  UIViewController.swift
//  Navigem
//
//  Created by Ryan The on 22/11/20.
//

import UIKit

extension UIViewController {
    func present(_ sheetControllerToPresent: SheetViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        var targetViewController: UIViewController
        if let parent = parent {
            targetViewController = parent
        } else {
            targetViewController = self
        }
        targetViewController.addChild(sheetControllerToPresent)
        targetViewController.view.addSubview(sheetControllerToPresent.view)
        
        sheetControllerToPresent.didMove(toParent: self)
    }
}
