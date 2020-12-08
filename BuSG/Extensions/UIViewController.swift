//
//  UIViewController.swift
//  Navigem
//
//  Created by Ryan The on 22/11/20.
//

import UIKit

extension UIViewController {
    // TODO: Move present(_:animted:completion:) to SheetController
    /// Extension method to present `SheetController`s
    func present(_ sheetControllerToPresent: SheetController, animated flag: Bool, completion: (() -> Void)? = nil) {

        var parentViewController: UIViewController
        
        if let parent = parent {
            parentViewController = parent
        } else {
            parentViewController = self
        }
        
        if let presentingSheetController = self as? SheetController {
            sheetControllerToPresent.presentingSheetController = presentingSheetController
            presentingSheetController.presentedSheetController = sheetControllerToPresent
            presentingSheetController.isHidden = true
        }
        
        parentViewController.addChild(sheetControllerToPresent)
        parentViewController.view.addSubview(sheetControllerToPresent.view)
        
        sheetControllerToPresent.didMove(toParent: self)
        
        completion?()
    }
}
