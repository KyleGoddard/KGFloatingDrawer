//
//  KGDrawerViewController.swift
//  KGDrawerViewController
//
//  Created by Kyle Goddard on 2015-02-10.
//  Copyright (c) 2015 Kyle Goddard. All rights reserved.
//

import UIKit

public enum KGDrawerSide: CGFloat {
    case None  = 0
    case Left  = 1
    case Right = -1
}

public class KGDrawerViewController: UIViewController {
    
    let defaultDuration:NSTimeInterval = 0.3
    
    // MARK: Initialization
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func loadView() {
        view = drawerView
    }
    
    
    private var _drawerView: KGDrawerView?
    var drawerView: KGDrawerView {
        get {
            if let retVal = _drawerView {
                return retVal
            }
            let rect = UIScreen.mainScreen().bounds
            let retVal = KGDrawerView(frame: rect)
            _drawerView = retVal
            return retVal
        }
    }
    
    // TODO: Add ability to supply custom animator.
    
    private var _animator: KGDrawerSpringAnimator?
    public var animator: KGDrawerSpringAnimator {
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
    
    public func openDrawer(side: KGDrawerSide, animated:Bool, complete: (finished: Bool) -> Void) {
        if currentlyOpenedSide != side {
            if let sideView = drawerView.viewContainerForDrawerSide(side) {
                let centerView = drawerView.centerViewContainer
                if currentlyOpenedSide != .None {
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
    
    public func closeDrawer(side: KGDrawerSide, animated: Bool, complete: (finished: Bool) -> Void) {
        if (currentlyOpenedSide == side && currentlyOpenedSide != .None) {
            if let sideView = drawerView.viewContainerForDrawerSide(side) {
                let centerView = drawerView.centerViewContainer
                animator.dismissDrawer(side, drawerView: sideView, centerView: centerView, animated: animated, complete: complete)
                currentlyOpenedSide = .None
                restoreGestures()
                drawerView.willCloseDrawer(self)
            }
        }
    }
    
    public func toggleDrawer(side: KGDrawerSide, animated: Bool, complete: (finished: Bool) -> Void) {
        if side != .None {
            if side == currentlyOpenedSide {
                closeDrawer(side, animated: animated, complete: complete)
            } else {
                openDrawer(side, animated: animated, complete: complete)
            }
        }
    }
    
    // MARK: Gestures
    
    func addDrawerGestures() {
        centerViewController?.view.userInteractionEnabled = false
        drawerView.centerViewContainer.addGestureRecognizer(toggleDrawerTapGestureRecognizer)
    }
    
    func restoreGestures() {
        drawerView.centerViewContainer.removeGestureRecognizer(toggleDrawerTapGestureRecognizer)
        centerViewController?.view.userInteractionEnabled = true
    }
    
    func centerViewContainerTapped(sender: AnyObject) {
        closeDrawer(currentlyOpenedSide, animated: true) { (finished) -> Void in
            // Do nothing
        }
    }
    
    // MARK: Helpers
    
    func viewContainer(side: KGDrawerSide) -> UIViewController? {
        switch side {
        case .Left:
            return self.leftViewController
        case .Right:
            return self.rightViewController
        case .None:
            return nil
        }
    }
    
    func replaceViewController(sourceViewController: UIViewController?, destinationViewController: UIViewController, container: UIView) {
        
        sourceViewController?.willMoveToParentViewController(nil)
        sourceViewController?.view.removeFromSuperview()
        sourceViewController?.removeFromParentViewController()
        
        self.addChildViewController(destinationViewController)
        container.addSubview(destinationViewController.view)
        
        let destinationView = destinationViewController.view
        destinationView.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        container.removeConstraints(container.constraints())
        
        let views: [String:UIView] = ["v1" : destinationView]
        container.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v1]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
        container.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[v1]|", options: NSLayoutFormatOptions(0), metrics: nil, views: views))
        
        destinationViewController.didMoveToParentViewController(self)
    }
    
    // MARK: Private computed properties
    
    public var currentlyOpenedSide: KGDrawerSide = .None
    
    // MARK: Accessors
    private var _leftViewController: UIViewController?
    public var leftViewController: UIViewController? {
        get {
            return _leftViewController
        }
        set {
            self.replaceViewController(self.leftViewController, destinationViewController: newValue!, container: self.drawerView.leftViewContainer)
            _leftViewController = newValue!
        }
    }
    
    private var _rightViewController: UIViewController?
    public var rightViewController: UIViewController? {
        get {
            return _rightViewController
        }
        set {
            self.replaceViewController(self.rightViewController, destinationViewController: newValue!, container: self.drawerView.rightViewContainer)
            _rightViewController = newValue
        }
    }
    
    private var _centerViewController: UIViewController?
    public var centerViewController: UIViewController? {
        get {
            return _centerViewController
        }
        set {
            self.replaceViewController(self.centerViewController, destinationViewController: newValue!, container: self.drawerView.centerViewContainer)
            _centerViewController = newValue
        }
    }
    
    private lazy var toggleDrawerTapGestureRecognizer: UITapGestureRecognizer = {
        [unowned self] in
        let gesture = UITapGestureRecognizer(target: self, action: "centerViewContainerTapped:")
        return gesture
    }()
    
    public var leftDrawerWidth: CGFloat {
        get  {
            return drawerView.leftViewContainerWidth
        }
        set {
            drawerView.leftViewContainerWidth = newValue
        }
    }
    
    public var rightDrawerWidth: CGFloat {
        get {
            return drawerView.rightViewContainerWidth
        }
        set {
            drawerView.rightViewContainerWidth = newValue
        }
    }
    
    public var leftDrawerRevealWidth: CGFloat {
        get {
            return drawerView.leftViewContainerWidth
        }
    }
    
    public var rightDrawerRevealWidth: CGFloat {
        get {
            return drawerView.rightViewContainerWidth
        }
    }
    
    public var backgroundImage: UIImage? {
        get {
            return drawerView.backgroundImageView.image
        }
        set {
            drawerView.backgroundImageView.image = newValue
        }
    }
    
    // MARK: Status Bar
    
    override public func childViewControllerForStatusBarHidden() -> UIViewController? {
        return centerViewController
    }
    
    override public func childViewControllerForStatusBarStyle() -> UIViewController? {
        return centerViewController
    }
    
    // MARK: Memory Management
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
