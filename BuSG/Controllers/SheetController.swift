//
//  BottomSheetViewController.swift
// BuSG
//
//  Created by Ryan The on 16/11/20.
//

import UIKit

enum SheetState {
    case full, regular, small, minimized
}

protocol SheetControllerDelegate: class {
    
    func sheetController(_ sheetController: SheetController, didUpdate state: SheetState)
    
    func sheetController(_ sheetController: SheetController, didReturnFromDismissalBy dismissingSheetController: SheetController)
    
}

class SheetController: UIViewController, UIGestureRecognizerDelegate {
    
    /// Delegate to handle all changes in sheet
    weak var delegate: SheetControllerDelegate?
    
    /// `SheetController` that presented the current `SheetController`. If the current `SheetController` was not presented by a sheet, this value is `nil`
    var presentingSheetController: SheetController?
    
    /// `SheetController` that the current `SheetController` presented. If the current `SheetController` was not presented by a sheet, this value is `nil`
    var presentedSheetController: SheetController?
    
    /// Holds information about current sheet's state. **Never directly set this**.
    private var state: SheetState = .regular
    
    /// Tells class if should prevent sheet from being seen.
    var isHidden = false {
        didSet { updateView(for: state) }
    }
    
    lazy var headerView = SheetHeaderView()
    
    lazy var contentView = SheetContentView()
    
    var screenBounds: CGRect {
        UIScreen.main.bounds
    }
    
    // MARK: Init SheetController
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: Override UIViewController lifecycle
    
    override func loadView() {
        // Do not call super
        view = UIView()
        
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: headerView.topAnchor),
            view.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
        ])
        let headerViewHeightAnchor = headerView.heightAnchor.constraint(equalToConstant: 60)
        headerViewHeightAnchor.priority = .defaultLow
        headerViewHeightAnchor.isActive = true
        
        view.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            headerView.bottomAnchor.constraint(equalTo: contentView.topAnchor),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onSlideDown(_:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        styleView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateView(for: state)
    }
    
    private func styleView() {
        view.frame = getSheetRect(with: 0)
        view.layer.cornerRadius = K.cornerRadius
        view.layer.masksToBounds = true
        if !UIAccessibility.isReduceTransparencyEnabled {
            view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.7)
            
            let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
            
            blurEffectView.frame = view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            view.insertSubview(blurEffectView, at: 0)
        } else {
            view.backgroundColor = .systemBackground
        }
    }
    
    // MARK: Scrolling/Snapping SheetView
    
    func updateView(for state: SheetState, velocity: CGFloat = 0) {
        self.state = state
        delegate?.sheetController(self, didUpdate: state)
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity, options: [.allowUserInteraction], animations: {
            let height = self.getSheetHeight(for: state)
            
            self.view.frame = self.getSheetRect(with: height)
        })
    }
    
    private func updateView(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let height = view.frame.height-translation.y
        
        view.frame = getSheetRect(with: height)
        recognizer.setTranslation(CGPoint.zero, in: view)
    }
    
    private var lastScrollHeight: CGFloat!
    @objc private func onSlideDown(_ sender: UIPanGestureRecognizer) {
        updateView(recognizer: sender)
        
        if sender.state == .began {
            lastScrollHeight = view.frame.height
        } else if sender.state == .ended {
            let distance = abs(lastScrollHeight-view.frame.height)
            let velocity = sender.velocity(in: view).y / distance
                        
            let goal = self.view.frame.height
            let states: [SheetState] = [.minimized, .small, .regular, .full]
            
            var closest: (Int, CGFloat)?
            for (index, state) in states.map({ self.getSheetHeight(for: $0) }).enumerated() {
                guard let closestUnwrapped = closest else {
                    closest = (index, state)
                    continue
                }
                closest = abs(state - goal) < abs(closestUnwrapped.1 - goal) ? (index, state) : closest
            }

            var nextStateIndex = closest!.0
            if velocity > 20, closest!.0 - 1 >= 0 {
                nextStateIndex = closest!.0 - 1
            } else if velocity < -20, closest!.0 + 1 <= states.count-1 {
                nextStateIndex = closest!.0 + 1
            }
            
            updateView(for: states[nextStateIndex], velocity: velocity)

        }
    }
    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
//        let direction = gesture.velocity(in: view).y
//
//        let height = view.frame.height
//
////        if (y == fullView && (view as! BottomSheetView).tableView.contentOffset.y == 0 && direction > 0) || (y == partialView) {
////            tableView.isScrollEnabled = false
////        } else {
////            tableView.isScrollEnabled = true
////        }
//
//        return false
//    }
    
    // MARK: Navigation
    
    fileprivate func didReturnFromDismissalBy(dismissingSheetController: SheetController) {
        delegate?.sheetController(self, didReturnFromDismissalBy: dismissingSheetController)
    }
    
    public func dismissSheet() {
        if let presentingSheetController = presentingSheetController {
            presentingSheetController.isHidden = false
            presentingSheetController.didReturnFromDismissalBy(dismissingSheetController: self)
            self.isHidden = true
            // Clean up container view controller
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
    }
    
    // MARK: Utility Methods
    private func getSheetHeight(for state: SheetState) -> CGFloat {
        if isHidden { return 0 }
        switch state {
        case .full: return UIScreen.main.bounds.height-50
        case .minimized: return 100
        case .small: return 300
        case .regular: fallthrough
        default: return 600
        }
    }
    
    private func getSheetRect(with height: CGFloat) -> CGRect {
        return CGRect(x: 0, y: screenBounds.height-height, width: screenBounds.width, height: height)
    }
}
