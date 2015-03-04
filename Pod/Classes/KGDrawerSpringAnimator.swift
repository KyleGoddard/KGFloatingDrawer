//
//  KGDrawerAnimator.swift
//  KGDrawerViewController
//
//  Created by Kyle Goddard on 2015-02-10.
//  Copyright (c) 2015 Kyle Goddard. All rights reserved.
//

import UIKit

public class KGDrawerSpringAnimator: NSObject {
    
    let kKGCenterViewDestinationScale:CGFloat = 0.7
    
    public var animationDelay: NSTimeInterval        = 0.0
    public var animationDuration: NSTimeInterval     = 0.7
    public var initialSpringVelocity: CGFloat        = 9.8 // 9.1 m/s == earth gravity accel.
    public var springDamping: CGFloat                = 0.8
    
    // TODO: can swift have private functions in a protocol?
    private func applyTransforms(side: KGDrawerSide, drawerView: UIView, centerView: UIView) {
        
        let direction = side.rawValue
        let sideWidth = CGRectGetWidth(drawerView.bounds)
        let centerWidth = CGRectGetWidth(centerView.bounds)
        let centerHorizontalOffset = direction * sideWidth
        let scaledCenterViewHorizontalOffset = direction * (sideWidth - (centerWidth - kKGCenterViewDestinationScale * centerWidth) / 2.0)
        
        let sideTransform = CGAffineTransformMakeTranslation(centerHorizontalOffset, 0.0)
        drawerView.transform = sideTransform
        
        let centerTranslate = CGAffineTransformMakeTranslation(scaledCenterViewHorizontalOffset, 0.0)
        let centerScale = CGAffineTransformMakeScale(kKGCenterViewDestinationScale, kKGCenterViewDestinationScale)
        centerView.transform = CGAffineTransformConcat(centerScale, centerTranslate)
        
    }
    
    private func resetTransforms(views: [UIView]) {
        for view in views {
            view.transform = CGAffineTransformIdentity
        }
    }

}

extension KGDrawerSpringAnimator: KGDrawerAnimating {
    
    public func openDrawer(side: KGDrawerSide, drawerView: UIView, centerView: UIView, animated: Bool, complete: (finished: Bool) -> Void) {
        if (animated) {
            UIView.animateWithDuration(animationDuration,
                delay: animationDelay,
                usingSpringWithDamping: springDamping,
                initialSpringVelocity: initialSpringVelocity,
                options: UIViewAnimationOptions.CurveLinear,
                animations: {
                    self.applyTransforms(side, drawerView: drawerView, centerView: centerView)
                    
                }, completion: complete)
        } else {
            self.applyTransforms(side, drawerView: drawerView, centerView: centerView)
        }
    }
    
    public func dismissDrawer(side: KGDrawerSide, drawerView: UIView, centerView: UIView, animated: Bool, complete: (finished: Bool) -> Void) {
        if (animated) {
            UIView.animateWithDuration(animationDuration,
                delay: animationDelay,
                usingSpringWithDamping: springDamping,
                initialSpringVelocity: initialSpringVelocity,
                options: UIViewAnimationOptions.CurveLinear,
                animations: {
                    self.resetTransforms([drawerView, centerView])
            }, completion: complete)
        } else {
            self.resetTransforms([drawerView, centerView])
        }
    }
    
    public func willRotateWithDrawerOpen(side: KGDrawerSide, drawerView: UIView, centerView: UIView) {
        
    }
    
    public func didRotateWithDrawerOpen(side: KGDrawerSide, drawerView: UIView, centerView: UIView) {
        UIView.animateWithDuration(animationDuration,
            delay: animationDelay,
            usingSpringWithDamping: springDamping,
            initialSpringVelocity: initialSpringVelocity,
            options: UIViewAnimationOptions.CurveLinear,
            animations: {}, completion: nil )
    }
    
}
