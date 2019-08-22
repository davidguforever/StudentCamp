//  UIView+Shake.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.

import UIKit


/// 摇动方向
public enum ShakeDirection: Int {

    ///  水平方向
	case horizontal
    
    ///  垂直方向
	case vertical

	fileprivate func startPosition() -> ShakePosition {
		switch self {
		case .horizontal:
			return ShakePosition.left
		default:
			return ShakePosition.top
		}
	}
}


/// 震动默认配置
public struct DefaultValues {
    /// 震动次数 5
	public static let numberOfTimes = 5
    /// 震动时间 0.5
	public static let totalDuration: Float = 0.5
}
// MARK: - UIView Shake
public extension UIView {

    /// 在指定的持续时间和给定的次数来回摇动。
    /// 如果给定的总的持续时间为1秒，和抖动的数目是5时，它将使用0.20秒抖动一次。
    /// 当完成摇晃后，完成指定处理事件
    ///
    /// - Parameters:
    ///   - direction: 摇动方向 (horizontal or vertical motion) `ShakeDirection`
    ///   - numberOfTimes:  摇动总次数，默认 5
    ///   - totalDuration: 摇动总时间，默认 0.5 seconds
    ///   - completion: 完成后处理事件(可选)
    /// - Returns: uiview 
	public func shake(_ direction: ShakeDirection, numberOfTimes: Int = DefaultValues.numberOfTimes, totalDuration: Float = DefaultValues.totalDuration, completion: (() -> Void)? = nil) -> UIView? {
		if UIAccessibility.isVoiceOverRunning {
			return self
		} else {
			let timePerShake = Double(totalDuration) / Double(numberOfTimes)
			shake(numberOfTimes, position: direction.startPosition(), durationPerShake: timePerShake, completion: completion)
			return nil
		}
	}
    
	fileprivate func postAccessabilityNotification(text: String) {
		var hasRead = false
		NotificationCenter.default.addObserver(forName: UIAccessibility.announcementDidFinishNotification, object: nil, queue: nil) { (notification) -> Void in
			if hasRead == false {
				UIAccessibility.post(notification: UIAccessibility.Notification.announcement, argument: text)
				hasRead = true
				NotificationCenter.default.removeObserver(self, name: UIAccessibility.announcementDidFinishNotification, object: nil)
			}
		}
		// seems to be a bug with UIAccessability that does not allow to post a notification with text in the action when tapping a button
		let time = DispatchTime.now() + Double(Int64(0.01 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
		DispatchQueue.main.asyncAfter(deadline: time) {
			UIAccessibility.post(notification: UIAccessibility.Notification.announcement, argument: " ")
		}
	}

	fileprivate func didFinishReadingAccessabilityLabel() {
		DispatchQueue.main.async(execute: {
			UIAccessibility.post(notification: UIAccessibility.Notification.announcement, argument: "hello world")
		})
	}

	fileprivate func shake(_ forTimes: Int, position: ShakePosition, durationPerShake: TimeInterval, completion: (() -> Void)?) {
		UIView.animate(withDuration: durationPerShake, animations: { () -> Void in

			switch position.direction {
			case .horizontal:
				self.layer.setAffineTransform(CGAffineTransform(translationX: 2 * position.value, y: 0))
				break
			case .vertical:
				self.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: 2 * position.value))
				break
			}
		}, completion: { (complete) -> Void in
			if (forTimes == 0) {
				UIView.animate(withDuration: durationPerShake, animations: { () -> Void in
					self.layer.setAffineTransform(CGAffineTransform.identity)
					}, completion: { (complete) -> Void in
					completion?()
				})
			} else {
				self.shake(forTimes - 1, position: position.oppositePosition(), durationPerShake: durationPerShake, completion: completion)
			}
		}) 
	}

}


private struct ShakePosition {

	let value: CGFloat
	let direction: ShakeDirection

	init(value: CGFloat, direction: ShakeDirection) {
		self.value = value
		self.direction = direction
	}

	func oppositePosition() -> ShakePosition {
		return ShakePosition(value: (self.value * -1), direction: direction)
	}

	static var left: ShakePosition {
		return ShakePosition(value: 1, direction: .horizontal)
	}

	static var right: ShakePosition {
		return ShakePosition(value: -1, direction: .horizontal)
	}

	static var top: ShakePosition {
		return ShakePosition(value: 1, direction: .vertical)
	}

	static var bottom: ShakePosition {
		return ShakePosition(value: -1, direction: .vertical)
	}

}
