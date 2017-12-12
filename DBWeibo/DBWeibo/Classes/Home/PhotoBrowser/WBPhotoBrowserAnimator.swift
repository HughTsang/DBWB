//
//  WBPhotoBrowserAnimator.swift
//  DBWeibo
//
//  Created by zenghz on 2017/5/16.
//  Copyright © 2017年 Personal. All rights reserved.
//

import UIKit

// 面向协议(接口)开发
protocol AnimatorPresentedDelegate: NSObjectProtocol {
    
    func startedRect(indexPath: IndexPath) -> CGRect
    func endRect(indexPath: IndexPath) -> CGRect
    func imageView(indexPath: IndexPath) -> UIImageView
}

protocol AnimatorDismissDelegate: NSObjectProtocol {
    
    func indexPathForDismissView() -> IndexPath
    func imageViewForDismissView() -> UIImageView
}

class WBPhotoBrowserAnimator: NSObject {

    fileprivate var isPresented: Bool = false
    
    var presentedDelegate: AnimatorPresentedDelegate?
    var dismissDelegate: AnimatorDismissDelegate?
    var indexPath: IndexPath?
}

// MARK: - UIViewControllerTransitioningDelegate
extension WBPhotoBrowserAnimator: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = false
        return self
    }
    
}

// MARK: - UIViewControllerAnimatedTransitioning
extension WBPhotoBrowserAnimator: UIViewControllerAnimatedTransitioning {


    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        isPresented ? animationForPresentedView(transitionContext: transitionContext) : animationForDismissView(transitionContext: transitionContext)
    }
    
    private func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning) {
        
        // 0.nil值校验
        guard let presentedDelegate = presentedDelegate, let indexPath = indexPath else {
            return
        }
        
        // 1.取出弹出的View
        let presentedView = transitionContext.view(forKey: .to)!
        
        // 2.将presentedView添加到containerView中
        transitionContext.containerView.addSubview(presentedView)
        
        // 3.获取执行动画的imageView
        let starteRect = presentedDelegate.startedRect(indexPath: indexPath)
        let imageView = presentedDelegate.imageView(indexPath: indexPath)
        transitionContext.containerView.addSubview(imageView)
        imageView.frame = starteRect
        
        // 4.执行动画
        presentedView.alpha = 0;
        transitionContext.containerView.backgroundColor = UIColor.black
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            imageView.frame = presentedDelegate.endRect(indexPath: indexPath)
            
        }) { (_) in
            
            presentedView.alpha = 1.0
            imageView.removeFromSuperview()
            transitionContext.containerView.backgroundColor = UIColor.clear
            transitionContext.completeTransition(true)
        }
    }
    
    private func animationForDismissView(transitionContext: UIViewControllerContextTransitioning) {
        
        // 0.nil值校验
        guard let dismissDelegate = dismissDelegate, let presentedDelegate = presentedDelegate else {
            return
        }
        
        // 1.取出消失的View
        let dismissView = transitionContext.view(forKey: .from)!
        dismissView.removeFromSuperview()
        
        // 2.获取执行动画的imageView
        let imageView = dismissDelegate.imageViewForDismissView()
        transitionContext.containerView.addSubview(imageView)
        let indexPath = dismissDelegate.indexPathForDismissView()
        
        // 2.执行动画
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            
            imageView.frame = presentedDelegate.startedRect(indexPath: indexPath)
        }) { (_) in
            
            imageView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
