//  MTBadgeBarButton.swift
//  
//  Copyright © 2016-2018年 Mantis Group. All rights reserved.
//

import UIKit


/// 导航按钮的标记提示
open class MTBadgeBarButton: UIBarButtonItem {
    
	/// Badge value to be display
	open var badgeValue: String = "" {
		didSet {
			if ((self.badgeValue == "0") && self.shouldHideBadgeAtZero == true) || self.badgeValue.isEmpty {
				removeBadge()
			}
			else if ((self.badge.text?.isEmpty) != nil) {
				updateBadgeValueAnimated(true)
			} else {
				self.badge = UILabel.init(frame: CGRect(x: self.badgeOriginX, y: self.badgeOriginY, width: 20.0, height: 20.0))
				self.badge.textColor = self.badgeTextColor
				self.badge.backgroundColor = self.badgeBGColor
				self.badge.font = self.badgeFont
				self.badge.textAlignment = NSTextAlignment .center
				self.customView?.addSubview(self.badge)

				updateBadgeValueAnimated(true)
			}
		}
	}

	/// Badge background color
	open var badgeBGColor = UIColor()
	
    /// Badge text color
	open var badgeTextColor = UIColor()
	
    /// Badge font
	open var badgeFont = UIFont()
	
    /// Padding value for the badge
	open var badgePadding = CGFloat()
    
	/// Minimum size badge to small
	var badgeMinSize = CGFloat()
    
	/// Values for offseting x the badge over the BarButtonItem you picked
	var badgeOriginX: CGFloat = 0 {
		didSet {
			updateBadgeFrame()
		}
	}
    /// Values for offseting y the badge over the BarButtonItem you picked
	var badgeOriginY: CGFloat = 0 {
		didSet {
			updateBadgeFrame()
		}
	}

	/// In case of numbers, remove the badge when reaching zero
	var shouldHideBadgeAtZero = Bool()
    
	/// Badge has a bounce animation when value changes
	var shouldAnimateBadge = Bool()

	/// The badge displayed over the BarButtonItem
	var badge = UILabel()


    /// 初始化并添加自定义界面 默认：背景红色，字体白色，字体14
	open func initWithCustomBadgeBarButton(_ customButton: UIButton) -> MTBadgeBarButton {
		self.customView = customButton
		initializer()
		return self
	}

	func printAndCount(_ stringToPrint: String) -> Int {
		print(stringToPrint)
		return stringToPrint.count
	}

	func initializer() {
		self.badgeBGColor = UIColor.red
		self.badgeTextColor = UIColor.white

		self.badgeFont = UIFont.systemFont(ofSize: 14.0)
		self.badgePadding = 4.0
		self.badgeMinSize = 10.0
		self.badgeOriginX = 0
		self.badgeOriginY = 0
		self.shouldHideBadgeAtZero = true
		self.shouldAnimateBadge = true
		self.customView?.clipsToBounds = false
	}

	
    /// 更新标示位置
	open func updateBadgeFrame() {
		let lbl_Frame = duplicateLabel(self.badge)
		lbl_Frame.sizeToFit()

		let expectedLabelSize = lbl_Frame.frame.size

		var minHeight = expectedLabelSize.height
		minHeight = (minHeight < self.badgeMinSize) ? self.badgeMinSize : expectedLabelSize.height

		var minWidth = expectedLabelSize.width
		minWidth = (minWidth < minHeight) ? minHeight : expectedLabelSize.width

		let padding = self.badgePadding

		self.badge.frame = CGRect(x: self.badgeOriginX, y: self.badgeOriginY, width: minWidth + padding, height: minHeight + padding)
		self.badge.layer.cornerRadius = self.badge.frame.width / 2
		self.badge.layer.masksToBounds = true
	}

	func duplicateLabel(_ lbl_ToCopy: UILabel) -> UILabel {
		let lbl_duplicate = UILabel .init(frame: lbl_ToCopy.frame)
		lbl_duplicate.text = lbl_ToCopy.text
		lbl_duplicate.font = lbl_ToCopy.font

		return lbl_duplicate
	}

    /// 动画更新标示值
    ///
    /// - Parameter animated: 是否显示动画效果
	open func updateBadgeValueAnimated(_ animated: Bool) {
		if (animated == true && self.shouldAnimateBadge && self.badge.text != self.badgeValue) {

			let animation = CABasicAnimation .init(keyPath: "transform.scale")
			animation.fromValue = 1.5
			animation.toValue = 1
			animation.duration = 0.2
			animation.timingFunction = CAMediaTimingFunction .init(controlPoints: 0.4, 1.3, 1, 1)
			self.badge.layer.add(animation, forKey: "bounceAnimation")
		}
		self.badge.text = self.badgeValue
		updateBadgeFrame()
	}

    /// 移除标示
	open func removeBadge() {
		UIView .animate(withDuration: 0.2, animations: {
			self.badge.transform = CGAffineTransform(scaleX: 0, y: 0)
			}, completion: {
			(value: Bool) in
			self.badge .removeFromSuperview()
		})
	}
}
