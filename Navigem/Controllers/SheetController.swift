//
//  BottomSheetViewController.swift
//  Navigem
//
//  Created by Ryan The on 16/11/20.
//

import UIKit

enum SheetState {
    case min, mid, max
}

protocol SheetControllerDelegate: class {
    func sheetController(_ sheetController: SheetController, didUpdateSize state: SheetState)
}

class SheetController: UIViewController, UIGestureRecognizerDelegate {
    
    weak var delegate: SheetControllerDelegate?
    
    /// Contains presenting `SheetController`. If the current `SheetController` was not presented by a sheet, this value is `nil`
    var presentingSheetController: SheetController?
    
    /// Holds information about current sheet's state. **Never directly set this**.
    private var state: SheetState = .mid
    
    var isHidden = false {
        didSet { updateView(for: state) }
    }
    
    var headerView = SheetHeaderView()
    
    var contentView = SheetContentView()
    
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
        updateView(for: .mid)
    }
    
    private func styleView() {
        view.frame = getSheetRect(with: 0)
        view.layer.cornerRadius = K.cornerRadius
        view.layer.masksToBounds = true
        if !UIAccessibility.isReduceTransparencyEnabled {
            view.backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: .systemMaterial)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
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
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity, options: [.allowUserInteraction], animations: {
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
            
            let midHeight = self.getSheetHeight(for: .mid)
            let threshold: CGFloat = abs(velocity)*15
            // FIXME: Redo scroll snapping. Currently is biased towards swiping towards center as threshold increases from centre.
            let newState: SheetState = {
                switch self.view.frame.height {
                case (midHeight-threshold)...(midHeight+threshold): return .mid
                case ...(midHeight-threshold): return .min
                case (midHeight+threshold)...: fallthrough
                default: return .max
                }
            }()
            
            updateView(for: newState, velocity: velocity)
        }
    }
    
    //    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    //        let gesture = (gestureRecognizer as! UIPanGestureRecognizer)
    //        let direction = gesture.velocity(in: view).y
    //
    //        let y = view.frame.minY
    //        if (y == fullView && (view as! BottomSheetView).tableView.contentOffset.y == 0 && direction > 0) || (y == partialView) {
    //            tableView.isScrollEnabled = false
    //        } else {
    //            tableView.isScrollEnabled = true
    //        }
    //
    //        return false
    //    }
    
    // MARK: Navigation
    
    public func popSheet() {
        if let presentingSheetController = presentingSheetController {
            presentingSheetController.isHidden = false
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
        case .max: return UIScreen.main.bounds.height-100
        case .min: return 100
        case .mid: fallthrough
        default: return 500
        }
    }
    
    private func getSheetRect(with height: CGFloat) -> CGRect {
        return CGRect(x: 0, y: screenBounds.height-height, width: screenBounds.width, height: height)
    }
}
