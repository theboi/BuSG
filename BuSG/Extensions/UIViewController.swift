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
            (parent as! MainViewController).currentlyPresentingSheetController = sheetControllerToPresent
        } else {
            parentViewController = self
            (parentViewController as! MainViewController).currentlyPresentingSheetController = sheetControllerToPresent
        }
        
        if let presentingSheetController = self as? SheetController {
            sheetControllerToPresent.presentingSheetController = presentingSheetController
            presentingSheetController.isHidden = true
        }
        
        parentViewController.addChild(sheetControllerToPresent)
        parentViewController.view.addSubview(sheetControllerToPresent.view)
        
        sheetControllerToPresent.didMove(toParent: self)
        
        completion?()
    }
}
