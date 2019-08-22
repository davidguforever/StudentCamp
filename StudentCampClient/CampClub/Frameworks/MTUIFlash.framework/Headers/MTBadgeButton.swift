//  MTBadgeButton.swift
//  
//  Copyright © 2016-2018年 Mantis Group. All rights reserved.
//

import UIKit
import Foundation


/// - Selecotr 语法糖（syntax-sugar）
private extension Selector {
    static let updateBadgeStatus = #selector(MTBadgeButton.updateBadgeStatus(_:))
}

/// 标记按钮
open class MTBadgeButton: UIButton {
	static let notificationKey = "adBadgeShowingKey"
    
    let badge: UILabel = {
        // create UILabel for badge view
        let lable = UILabel()
        lable.clipsToBounds = true
        lable.backgroundColor = .red
        lable.text = "N"
        lable.textAlignment = .center
        lable.textColor = .white
        lable.font = .boldSystemFont(ofSize: 13)
        return lable
    }()
    
	public var isShowingBadge: Bool?
	
    
    /// init with frame
    ///
    /// - Parameter frame: frame
    override public  init(frame: CGRect) {
		super.init(frame: frame)
		setUpBadge()
		hideBadge()
	}
    
    
    /// init
    ///
    /// - Parameter aDecoder: coder
	required public init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)!
		setUpBadge()
		self.addSubview(badge)
	}

	// setupBadge
	fileprivate func setUpBadge() {
        let scale = 0.38
        badge.frame = CGRect(x: self.frame.width - self.frame.width * CGFloat(scale), y: 0, width: self.frame.width * CGFloat(scale), height: self.frame.height * CGFloat(scale))
        badge.layer.cornerRadius = badge.frame.width / 2
    
		// setup autolayout
		addSubview(badge)
		badge.isHidden = true
		NotificationCenter.default.addObserver(self, selector: .updateBadgeStatus, name: NSNotification.Name(rawValue: MTBadgeButton.notificationKey), object: nil)
	}
    

    /// 更新标示显示状态
    @objc open func updateBadgeStatus(_ notification: Notification?) {
		if isBadge() {
			hideBadge()
		} else {
			showBadge()
		}
	}

	/// 动画显示标示 (show badge with animation)
	open func showBadge() {
		
        badge.isHidden = false
        UIView.animate(withDuration: 0.6, animations: { () -> Void in
            self.badge.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self.isShowingBadge = true
        })
		
	}

	/// 动画隐藏标示 (hide badge with animation)
	open func hideBadge() {
		
        UIView.animate(withDuration: 0.6, delay: 0, options: UIView.AnimationOptions(), animations: { () -> Void in
            self.badge.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            }, completion: { (stop) -> Void in
            self.badge.isHidden = true
            self.isShowingBadge = false
        })
		
	}


    /// 获取标示状态 whether badge is showing
	open func isBadge() -> Bool {
		if let b = isShowingBadge {
			if b {
				return true
			} else {
				return false
			}
		}
		return false
	}
}
