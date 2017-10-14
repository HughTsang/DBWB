//
//  WBPopverAnimator.swift
//  DBWeibo
//
//  Created by zenghz on 2017/2/20.
//  Copyright © 2017年 Personal. All rights reserved.
//

import UIKit

class WBPopverAnimator: NSObject {

    // MARK: - 对外提供的属性
    @objc var isPresented: Bool = false
    @objc var presentedFrame: CGRect = CGRect.zero
    
    @objc var callBack: ((_ isPresented: Bool) -> ())?
    
    //注意: 如果自定义了一个构造函数,但是没有对默认的构造函数init()进行重写,那么自定义的构造函数会覆盖默认的init()构造函数
    // MARK: - 自定义构造函数
    init(callBack: @escaping (_ isPresented: Bool) -> ()) {
        self.callBack = callBack
    }
}

// MARK: - 自定义转场代理方法 UIViewControllerTransitioningDelegate
extension WBPopverAnimator: UIViewControllerTransitioningDelegate {
    
    // 目的:  改变弹出View的尺寸
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let presentation = WBPresentationController(presentedViewController: presented, presenting: presenting)
        presentation.presentedFrame = presentedFrame
        
        return presentation
    }
    
    //目的: 自定义弹出的动画
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = true
        callBack?(isPresented)
        return self
    }
    
    //目的: 自定义消失动画
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        isPresented = false
        callBack?(isPresented)
        return self
    }
}

// MARK: - 弹出和消失动画代理的方法
extension WBPopverAnimator: UIViewControllerAnimatedTransitioning {
    
    /// 动画执行的时间
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        
        return 0.5
    }
    
    /// 获取转场的上下文: 可以通过转场上下文获取弹出的View和消失的View
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        isPresented ? animationForPresentedView(transitionContext: transitionContext) : animationForDismissedView(transitionContext: transitionContext)
        
    }
    
    //自定义弹出动画
    fileprivate func animationForPresentedView(transitionContext: UIViewControllerContextTransitioning) {
        
        //1.获取弹出的View
        //UITransitionContextFromViewKey:   获取消失的View
        //UITransitionContextToViewKey:     获取弹出的View
        guard let presentedView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
            HZLog("获取不到presentedView")
            return
        }
        
        //2.将弹出的View添加到containerView中
        transitionContext.containerView.addSubview(presentedView)
        
        //3.执行动画
        presentedView.transform = CGAffineTransform(scaleX: 1.0, y: 0.0)
        presentedView.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            
            presentedView.transform = CGAffineTransform.identity
            
        }) { (_) in
            //必须告诉转场上下文你已经完成动画
            transitionContext.completeTransition(true)
        }
    }
    
    //自定义消失动画
    fileprivate func animationForDismissedView(transitionContext: UIViewControllerContextTransitioning) {
        
        //1.获取消失的View
        //UITransitionContextFromViewKey:   获取消失的View
        //UITransitionContextToViewKey:     获取弹出的View
        guard let dismissedView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
            HZLog("获取不到dismissedView")
            return
        }
        
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            
            dismissedView.transform = CGAffineTransform(scaleX: 1.0, y: 0.00001)
            
        }) { (_) in
            dismissedView.removeFromSuperview()
            //必须告诉转场上下文你已经完成动画
            transitionContext.completeTransition(true)
        }
    }
}
