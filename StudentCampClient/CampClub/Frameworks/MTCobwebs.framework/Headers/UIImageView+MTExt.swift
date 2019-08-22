//
//  UIImageView+MTExt.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.
//

import UIKit
import CoreLocation



private var activityIndicatorKey: Void?
private var showActivityIndicatorWhenLoadingKey: Void?

public extension UIImageView {
    // MARK: - ActivityIndicator
	fileprivate var mt_activityIndicator: UIActivityIndicatorView? {
		return objc_getAssociatedObject(self, &activityIndicatorKey) as? UIActivityIndicatorView
	}

	fileprivate func mt_setActivityIndicator(_ activityIndicator: UIActivityIndicatorView?) {
		objc_setAssociatedObject(self, &activityIndicatorKey, activityIndicator, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
	}
    
	/// 在图片上显示加载进度 
	public var mt_showActivityIndicatorWhenLoading: Bool {
		get {
			guard let result = objc_getAssociatedObject(self, &showActivityIndicatorWhenLoadingKey) as? NSNumber else {
				return false
			}

			return result.boolValue
		}

		set {
			if mt_showActivityIndicatorWhenLoading == newValue {
				return

			} else {
				if newValue {
					let indicatorStyle = UIActivityIndicatorView.Style.gray
					let indicator = UIActivityIndicatorView(style: indicatorStyle)
                    indicator.center = CGPoint(x: bounds.midX, y: bounds.midY)

					indicator.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin, .flexibleTopMargin]
					indicator.isHidden = true
					indicator.hidesWhenStopped = true

					self.addSubview(indicator)

					mt_setActivityIndicator(indicator)

				} else {
					mt_activityIndicator?.removeFromSuperview()
					mt_setActivityIndicator(nil)
				}

				objc_setAssociatedObject(self, &showActivityIndicatorWhenLoadingKey, NSNumber(value: newValue as Bool), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
			}
		}
	}
    

    /// 设置图片
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - animated: 是否动画
    ///   - animationDuration: 动画时间  默认 1秒
    public final func setImage(_ image: UIImage?, animated: Bool, animationDuration: TimeInterval = 1.0) {
        let change: () -> () = {
            self.image = image
        }
        if !animated {
            change()
        } else {
            let options: UIView.AnimationOptions = [.transitionCrossDissolve, .beginFromCurrentState, .allowUserInteraction]
            UIView.transition(with: self, duration: animationDuration, options: options, animations: change, completion: nil)
        }
    }
    
    /// Make image view blurry
    ///
    /// - Parameter style: UIBlurEffectStyle (default is .light).
    public func blur(withStyle style: UIBlurEffect.Style = .light) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        addSubview(blurEffectView)
        clipsToBounds = true
    }
    
    /// Blurred version of an image view
    ///
    /// - Parameter style: UIBlurEffectStyle (default is .light).
    /// - Returns: blurred version of self.
    public func blurred(withStyle style: UIBlurEffect.Style = .light) -> UIImageView {
        let imgView = self
        imgView.blur(withStyle: style)
        return imgView
    }

}




