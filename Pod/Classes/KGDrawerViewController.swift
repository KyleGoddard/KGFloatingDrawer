//
//  KGDrawerViewController.swift
//  KGDrawerViewController
//
//  Created by Kyle Goddard on 2015-02-10.
//  Copyright (c) 2015 Kyle Goddard. All rights reserved.
//

import UIKit

public enum KGDrawerSide: CGFloat {
    case none  = 0
    case left  = 1
    case right = -1
}

open class KGDrawerViewController: UIViewController {
    
    let defaultDuration:TimeInterval = 0.3
    
    // MARK: Initialization
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func loadView() {
        view = drawerView
    }
    
    
    fileprivate var _drawerView: KGDrawerView?
    var drawerView: KGDrawerView {
        get {
            if let retVal = _drawerView {
                return retVal
            }
            let rect = UIScreen.main.bounds
            let retVal = KGDrawerView(frame: rect)
            _drawerView = retVal
            return retVal
        }
    }
    
    // TODO: Add ability to supply custom animator.
    
    fileprivate var _animator: KGDrawerSpringAnimator?
    open var animator: KGDrawerSpringAnimator {
        get {
            if let retVal = _animator {
                return retVal
            }
            let retVal = KGDrawerSpringAnimator()
            _animator = retVal
            return retVal
        }
    }
    
    // MARK: Interaction
    
    open func openDrawer(_ side: KGDrawerSide, animated:Bool, complete: @escaping (Bool) -> Void) {
        if currentlyOpenedSide != side {
            if let sideView = drawerView.viewContainerForDrawerSide(side) {
                let centerView = drawerView.centerViewContainer
                if currentlyOpenedSide != .none {
                    closeDrawer(side, animated: animated) { finished in
                            self.animator.openDrawer(side, drawerView: sideView, centerView: centerView, animated: animated, complete: complete)
                    }
                } else {
                    self.animator.openDrawer(side, drawerView: sideView, centerView: centerView, animated: animated, complete: complete)
                }
                
                addDrawerGestures()
                drawerView.willOpenDrawer(self)
            }
        }
        
        currentlyOpenedSide = side
    }
    
    open func closeDrawer(_ side: KGDrawerSide, animated: Bool, complete: @escaping (Bool) -> Void) {
        if (currentlyOpenedSide == side && currentlyOpenedSide != .none) {
            if let sideView = drawerView.viewContainerForDrawerSide(side) {
                let centerView = drawerView.centerViewContainer
                animator.dismissDrawer(side, drawerView: sideView, centerView: centerView, animated: animated, complete: complete)
                currentlyOpenedSide = .none
                restoreGestures()
                drawerView.willCloseDrawer(self)
            }
        }
    }
    
    open func toggleDrawer(_ side: KGDrawerSide, animated: Bool, complete: @escaping (_ finished: Bool) -> Void) {
        if side != .none {
            if side == currentlyOpenedSide {
                closeDrawer(side, animated: animated, complete: complete)
            } else {
                openDrawer(side, animated: animated, complete: complete)
            }
        }
    }
    
    // MARK: Gestures
    
    func addDrawerGestures() {
        centerViewController?.view.isUserInteractionEnabled = false
        drawerView.centerViewContainer.addGestureRecognizer(toggleDrawerTapGestureRecognizer)
    }
    
    func restoreGestures() {
        drawerView.centerViewContainer.removeGestureRecognizer(toggleDrawerTapGestureRecognizer)
        centerViewController?.view.isUserInteractionEnabled = true
    }
    
    func centerViewContainerTapped(_ sender: AnyObject) {
        closeDrawer(currentlyOpenedSide, animated: true) { (finished) -> Void in
            // Do nothing
        }
    }
    
    // MARK: Helpers
    
    func viewContainer(_ side: KGDrawerSide) -> UIViewController? {
        switch side {
        case .left:
            return self.leftViewController
        case .right:
            return self.rightViewController
        case .none:
            return nil
        }
    }
    
    func replaceViewController(_ sourceViewController: UIViewController?, destinationViewController: UIViewController, container: UIView) {
        
        sourceViewController?.willMove(toParentViewController: nil)
        sourceViewController?.view.removeFromSuperview()
        sourceViewController?.removeFromParentViewController()
        
        self.addChildViewController(destinationViewController)
        container.addSubview(destinationViewController.view)
        
        let destinationView = destinationViewController.view
        destinationView?.translatesAutoresizingMaskIntoConstraints = false
        
        container.removeConstraints(container.constraints)
        
        let views: [String:UIView] = ["v1" : destinationView!]
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v1]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        container.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v1]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        
        destinationViewController.didMove(toParentViewController: self)
    }
    
    // MARK: Private computed properties
    
    open var currentlyOpenedSide: KGDrawerSide = .none
    
    // MARK: Accessors
    fileprivate var _leftViewController: UIViewController?
    open var leftViewController: UIViewController? {
        get {
            return _leftViewController
        }
        set {
            self.replaceViewController(self.leftViewController, destinationViewController: newValue!, container: self.drawerView.leftViewContainer)
            _leftViewController = newValue!
        }
    }
    
    fileprivate var _rightViewController: UIViewController?
    open var rightViewController: UIViewController? {
        get {
            return _rightViewController
        }
        set {
            self.replaceViewController(self.rightViewController, destinationViewController: newValue!, container: self.drawerView.rightViewContainer)
            _rightViewController = newValue
        }
    }
    
    fileprivate var _centerViewController: UIViewController?
    open var centerViewController: UIViewController? {
        get {
            return _centerViewController
        }
        set {
            self.replaceViewController(self.centerViewController, destinationViewController: newValue!, container: self.drawerView.centerViewContainer)
            _centerViewController = newValue
        }
    }
    
    fileprivate lazy var toggleDrawerTapGestureRecognizer: UITapGestureRecognizer = {
        [unowned self] in
        let gesture = UITapGestureRecognizer(target: self, action: #selector(KGDrawerViewController.centerViewContainerTapped(_:)))
        return gesture
    }()
    
    open var leftDrawerWidth: CGFloat {
        get  {
            return drawerView.leftViewContainerWidth
        }
        set {
            drawerView.leftViewContainerWidth = newValue
        }
    }
    
    open var rightDrawerWidth: CGFloat {
        get {
            return drawerView.rightViewContainerWidth
        }
        set {
            drawerView.rightViewContainerWidth = newValue
        }
    }
    
    open var leftDrawerRevealWidth: CGFloat {
        get {
            return drawerView.leftViewContainerWidth
        }
    }
    
    open var rightDrawerRevealWidth: CGFloat {
        get {
            return drawerView.rightViewContainerWidth
        }
    }
    
    open var backgroundImage: UIImage? {
        get {
            return drawerView.backgroundImageView.image
        }
        set {
            drawerView.backgroundImageView.image = newValue
        }
    }
    
    // MARK: Status Bar
    
    override open var childViewControllerForStatusBarHidden : UIViewController? {
        return centerViewController
    }
    
    override open var childViewControllerForStatusBarStyle : UIViewController? {
        return centerViewController
    }
    
    // MARK: Memory Management
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
