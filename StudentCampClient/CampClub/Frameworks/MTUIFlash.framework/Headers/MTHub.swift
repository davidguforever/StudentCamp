//  MTHub.swift
//  
//  Copyright © 2016-2018年 Mantis Group. All rights reserved.
//

import UIKit

 fileprivate let hubBound = CGRect(x: 0, y: 0, width: 60, height: 60)


/// 加载框  超时60秒
///
///     MTHub.show()
///     MTHub.hide()
public class MTHub: NSObject {
    /// 超时时间
    public var indicatorTimeount : TimeInterval = 60
    
    static let shared = MTHub()
    
    var isShowing = false
    var dismissTimer: Timer?
    
    lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.frame = UIScreen.main.bounds
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .white)
        return view
    }()
    
    /// 显示
    public static func show() {
        showActivityIndicatorWhileBlockingUI(blockingUI: true)
    }
    
    /// 显示
    static func showActivityIndicatorWhileBlockingUI(blockingUI: Bool) {
        
        if shared.isShowing {
            return // TODO: 或者用新的取代旧的
        }
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            if let window = UIApplication.shared.keyWindow {
                
                shared.isShowing = true
                window.addSubview(shared.overlayView)
                shared.containerView.isUserInteractionEnabled = blockingUI
                
                shared.containerView.alpha = 0
                window.addSubview(shared.containerView)
                shared.containerView.frame = hubBound //window.bounds
                
                shared.containerView.center = window.center
                
                UIView.animate(withDuration: 0, animations: { 
                    shared.containerView.alpha = 1
                }, completion: { (_) in
                    shared.containerView.addSubview(shared.activityIndicator)
                    shared.activityIndicator.center =  shared.containerView.bounds.center
                    shared.activityIndicator.startAnimating()

                    shared.activityIndicator.alpha = 0
                    shared.activityIndicator.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
                    
                    UIView.animate(withDuration: 0.05, delay: 0.0, options: UIView.AnimationOptions(rawValue: 0), animations: {
                        shared.activityIndicator.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        shared.activityIndicator.alpha = 1
                    }, completion: { (_) in
                        shared.activityIndicator.transform = CGAffineTransform.identity
                        
                        if let dismissTimer = shared.dismissTimer {
                            dismissTimer.invalidate()
                        }
                        shared.dismissTimer = Timer.scheduledTimer(shared.indicatorTimeount, block: { (_) in
                            MTHub.forcedHide()
                        }, repeats: false)
                        
                    })


                })
            }
        }
    }
    
    /// 隐藏
    static func forcedHide() {
        hide() {
//            if
//                let appDelegate = UIApplication.shared.delegate as? AppDelegate,
//                let viewController = appDelegate.window?.rootViewController {
            
                //YepAlert.alertSorry(message: NSLocalizedString("Wait too long, the operation may not be completed.", comment: ""), inViewController: viewController)
//            }
        }
    }
    
    /// 隐藏
    public static func hide() {
        hide() { }
    }
    
    /// 隐藏
    public static func hide(completion: @escaping () -> Void) {
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if shared.isShowing {
                
                shared.activityIndicator.transform = CGAffineTransform.identity
                
                UIView.animate(withDuration: 0.05, delay: 0.0, options: UIView.AnimationOptions(rawValue: 0), animations: {
                    
                    shared.activityIndicator.transform = CGAffineTransform.init(scaleX: 0.0001, y: 0.0001)
                    shared.activityIndicator.alpha = 0
                }, completion: { (_) in
                    UIView.animate(withDuration: 0.05, delay: 0.0, options: UIView.AnimationOptions(rawValue: 0), animations: {
                        shared.containerView.alpha = 0
                    }, completion: { (_) in
                        shared.overlayView.removeFromSuperview()
                        shared.containerView.removeFromSuperview()
                        completion()
                    })
                })
            }
            
            shared.isShowing = false
        }
    }
}



fileprivate extension CGRect {
    
    /// The center x coordinate of the rect.
    var centerX: CGFloat {
        get {
            return origin.x + size.width / 2
        }
        set (value) {
            origin.x = value - size.width / 2
        }
    }
    
    /// The center y coordinate of the rect.
    var centerY: CGFloat {
        get {
            return origin.y + size.height / 2
        }
        set (value) {
            origin.y = value - size.height / 2
        }
    }

    /// The center of the rect.
    var center: CGPoint {
        get {
            return CGPoint(x: centerX, y: centerY)
        }
        set (value) {
            centerX = value.x
            centerY = value.y
        }
    }
}


private class BlockWrapper<T> {
    let block: T
    
    init(block: T) {
        self.block = block
    }
}

fileprivate extension Timer {

    /// 间隔执行事件
    ///
    /// - Parameters:
    ///   - interval: 间隔时间
    ///   - block: 处理事件
    ///   - repeats: 是否循环
    /// - Returns: Timer
    static func scheduledTimer(_ interval: TimeInterval, block: @escaping ((Timer) -> ()), repeats: Bool) -> Timer {
        let userInfo = BlockWrapper(block: block)
        
        return scheduledTimer(timeInterval: interval, target: self, selector: #selector(Timer.executeBlock(_:)), userInfo: userInfo, repeats: repeats)
    }
    
    /// execute block
    @objc static func executeBlock(_ timer: Timer) {
        guard let wrapper = timer.userInfo as? BlockWrapper < (Timer) -> Void > else {
            return
        }
        
        wrapper.block(timer)
    }
}

