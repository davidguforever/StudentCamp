//  UIView+MTExt.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.

import UIKit


public extension UIView {
    // MARK: - UIView Rect    
    
    /// 高度
	public var height: CGFloat {
		get { return frame.size.height }
		set { frame.size.height = newValue }
	}
    /// 宽度
	public var width: CGFloat {
		get { return frame.size.width }
		set { frame.size.width = newValue }
	}
    /// 横坐标
	public var x: CGFloat {
		get { return frame.origin.x }
		set {
			var frame = self.frame
			frame.origin.x = newValue
			self.frame = frame
		}
	}
    /// Y 坐标
	public var y: CGFloat {
		get { return frame.origin.y }
		set {
			var frame = self.frame
			frame.origin.y = newValue
			self.frame = frame
		}
	}
    /// 最小 X
	public var minX: CGFloat {
		return frame.minX
	}
    /// 最小 Y
	public var minY: CGFloat {
		return frame.minY
	}

	/// The horizontal center coordinate of the UIView.
	public var centerX: CGFloat {
		get {
			return frame.centerX
		}
		set(value) {
			var frame = self.frame
			frame.centerX = value
			self.frame = frame
		}
	}

	/// The vertical center coordinate of the UIView.
	public var centerY: CGFloat {
		get {
			return frame.centerY
		}
		set(value) {
			var frame = self.frame
			frame.centerY = value
			self.frame = frame
		}
	}
    /// 最大 X
	public var maxX: CGFloat {
		return frame.maxX
	}
    /// 最大 Y
	public var maxY: CGFloat {
		return frame.maxY
	}

}

@IBDesignable
public extension UIView {
    // MARK: - Useful param to UIView in xib
    
    /// 圆角 (masksToBounds = true)
	@IBInspectable public var cornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set {
            layer.masksToBounds = true
			layer.cornerRadius = newValue
		}
	}
    /// 边角宽度
	@IBInspectable public var borderWidth: CGFloat {
		get {
			return layer.borderWidth
		}
		set {
			layer.borderWidth = newValue
		}
	}
	/// 边角颜色
	@IBInspectable public var borderColor: UIColor? {
		get {
			guard let color = layer.borderColor else { return nil }
			return UIColor(cgColor: color)
		}
		set {
			layer.borderColor = newValue?.cgColor
		}
	}
}

public extension UIView {
    
    /// Recursively find the first responder.
    public func firstResponder() -> UIView? {
        var views = [UIView](arrayLiteral: self)
        var i = 0
        repeat {
            let view = views[i]
            if view.isFirstResponder {
                return view
            }
            views.append(contentsOf: view.subviews)
            i += 1
        } while i < views.count
        return nil
    }
    
    /// bounds center
    public var centerPoint: CGPoint {
        
        return CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
    }
    
    
    /// Add array of subviews to view.
    ///
    /// - Parameter subviews: array of subviews to add to self.
    public func addSubviews(_ subviews: [UIView]) {
        subviews.forEach({ self.addSubview($0) })
    }
    
    /// 添加多个view
    public func addSubviews(_ subviews: UIView...) {
        subviews.forEach(addSubview)
        //for view in subviews { self.addSubview(view) }
    }
    
    /// 移除所有子界面 Remove all subviews in view.
    public func removeSubviews() {
        subviews.forEach({ $0.removeFromSuperview() })
    }
    
    /// 移除手势 (Remove all gesture recognizers from view.)
    public func removeGestureRecognizers() {
        gestureRecognizers?.forEach(removeGestureRecognizer)
    }

    
    /// 动画
    ///
    /// - Parameters:
    ///   - duration: 时间
    ///   - delay: 延迟
    ///   - animations: 动画
    public static func animateWithDuration(_ duration: TimeInterval, delay: TimeInterval, animations: @escaping () -> Void) {
        
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions(), animations: animations, completion: nil)
    }
    
    /// 动画
    ///
    /// - Parameters:
    ///   - duration: 时间
    ///   - delay: 延迟
    ///   - animations: 动画
    ///   - completion: 动画完成后
    public static func animateWithDuration(_ duration: TimeInterval, delay: TimeInterval, animations: @escaping () -> Void, completion: ((Bool) -> Void)?) {
        
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions(), animations: animations, completion: completion)
    }
}


public extension UIView {
    // MARK: - UIView Tap To Close Editing

    /// 给 UIView 添加点击关闭编辑
	public func addTapToCloseEditing() {
		let tapToHideKeyBoard = UITapGestureRecognizer(target: self, action: #selector(UIView.hideKeyboard))
		addGestureRecognizer(tapToHideKeyBoard)
	}
    
    /// 隐藏键盘结束编辑
    @objc public  func hideKeyboard() {
		endEditing(true)
	}

}



public extension UIView {
    // MARK: - UIView 截屏
    
    /// 对 UIView 截屏
    ///
    /// - Returns: 结果图片
	public func screenshot() -> UIImage {
		UIGraphicsBeginImageContextWithOptions(frame.size, false, 2.0)
		layer.render(in: UIGraphicsGetCurrentContext()!)
		let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()

		return image
	}
    
    /// Take a screenshot of the current view
    ///
    /// - Parameter save: Save the screenshot in user pictures. Default is false.
    /// - Returns: Returns screenshot as UIImage
    public func screenshot(save: Bool = false) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        self.layer.render(in: context)
        
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        
        UIGraphicsEndImageContext()
        
        if save {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        
        return image
    }
}



public extension UIView {
    // MARK: - UIView simple shake
    

    ///  震动 (Shakes the view for as many number of times as given in the argument)
    ///
    /// - Parameter times: 次数
	public func shakeWith(_ times: Int) {
		let anim = CAKeyframeAnimation(keyPath: "transform")
		anim.values = [
			NSValue(caTransform3D: CATransform3DMakeTranslation(-5, 0, 0)),
			NSValue(caTransform3D: CATransform3DMakeTranslation(5, 0, 0))
		]
		anim.autoreverses = true
		anim.repeatCount = Float(times)
		anim.duration = 7 / 100

		self.layer.add(anim, forKey: nil)
	}

}


public extension UIView {
    // MARK: - UIView Gesture Extensions
    

    /// 添加点击手势，并绑定事件   http://stackoverflow.com/questions/4660371/how-to-add-a-touch-event-to-a-uiview/32182866#32182866
    ///
    /// - Parameters:
    ///   - tapNumber: 点击次数  默认 1
    ///   - target: 目标
    ///   - action: 事件函数
	public func addTapGesture(tapNumber: Int = 1, target: AnyObject, action: Selector) {
		let tap = UITapGestureRecognizer(target: target, action: action)
		tap.numberOfTapsRequired = tapNumber
		addGestureRecognizer(tap)
		isUserInteractionEnabled = true
	}

    /// 添加点击手势，并绑定事件 `BlockTap`
    ///
    /// - Parameters:
    ///   - tapNumber: 点击次数  默认 1
    ///   - action: 事件函数
	public func addTapGesture(tapNumber: Int = 1, action: ((UITapGestureRecognizer) -> ())?) {
		let tap = BlockTap(tapCount: tapNumber, fingerCount: 1, action: action)
		addGestureRecognizer(tap)
		isUserInteractionEnabled = true
	}

    /// 添加轻扫手势，并绑定事件
    ///
    /// - Parameters:
    ///   - direction: 方向
    ///   - numberOfTouches: 点击的次数
    ///   - target: target
    ///   - action: 事件函数
	public func addSwipeGesture(direction: UISwipeGestureRecognizer.Direction, numberOfTouches: Int = 1, target: AnyObject, action: Selector) {
		let swipe = UISwipeGestureRecognizer(target: target, action: action)
		swipe.direction = direction
		swipe.numberOfTouchesRequired = numberOfTouches
		addGestureRecognizer(swipe)
		isUserInteractionEnabled = true
	}

    
    ///  添加轻扫手势，并绑定事件 `BlockSwipe`
    ///
    /// - Parameters:
    ///   - direction: 方向
    ///   - numberOfTouches: 点击的次数
    ///   - action: 事件函数
	public func addSwipeGesture(direction: UISwipeGestureRecognizer.Direction, numberOfTouches: Int = 1, action: ((UISwipeGestureRecognizer) -> ())?) {
		let swipe = BlockSwipe(direction: direction, fingerCount: numberOfTouches, action: action)
		addGestureRecognizer(swipe)
		isUserInteractionEnabled = true
	}


    /// 添加点击手势
    ///
    /// - Parameters:
    ///   - target: target
    ///   - action:  执行的事件
	public func addPanGesture(target: AnyObject, action: Selector) {
		let pan = UIPanGestureRecognizer(target: target, action: action)
		addGestureRecognizer(pan)
		isUserInteractionEnabled = true
	}


    /// 添加点击手势 use `BlockPan`
    ///
    /// - Parameter action: 执行的Block
	public func addPanGesture(action: ((UIPanGestureRecognizer) -> ())?) {
		let pan = BlockPan(action: action)
		addGestureRecognizer(pan)
		isUserInteractionEnabled = true
	}
    
    
    /// 添加捏合手势
    ///
    /// - Parameters:
    ///   - target: target
    ///   - action: 执行的Block
	public func addPinchGesture(target: AnyObject, action: Selector) {
		let pinch = UIPinchGestureRecognizer(target: target, action: action)
		addGestureRecognizer(pinch)
		isUserInteractionEnabled = true
	}

    
    /// 添加捏合手势 use `BlockPinch`
    ///
    /// - Parameter action: 执行的Block
	public func addPinchGesture(action: ((UIPinchGestureRecognizer) -> ())?) {
		let pinch = BlockPinch(action: action)
		addGestureRecognizer(pinch)
		isUserInteractionEnabled = true
	}

    
    /// 添加长按手势
    ///
    /// - Parameters:
    ///   - target: target
    ///   - action: 执行的事件
	public func addLongPressGesture(target: AnyObject, action: Selector) {
		let longPress = UILongPressGestureRecognizer(target: target, action: action)
		addGestureRecognizer(longPress)
		isUserInteractionEnabled = true
	}
    
    /// 添加长按手势 use `BlockLongPress`
    ///
    /// - Parameter action:  执行的Block
	public func addLongPressGesture(action: ((UILongPressGestureRecognizer) -> ())?) {
		let longPress = BlockLongPress(action: action)
		addGestureRecognizer(longPress)
		isUserInteractionEnabled = true
	}
}


public extension UIView {
    // MARK: - UIView Corner
    
	// 圆角 [UIRectCorner.TopLeft, UIRectCorner.TopRight]
	public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
		let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
		let mask = CAShapeLayer()
		mask.path = path.cgPath
		layer.mask = mask
	}
    
    /// 圆形 UIView
	public func roundView() {
		layer.cornerRadius = min(frame.size.height, frame.size.width) / 2
	}

    
    ///  添加阴影 (Add shadow to view.)
    ///
    /// - Parameters:
    ///   - color: shadow color (default is #137992).
    ///   - radius: shadow radius (default is 3).
    ///   - offset: shadow offset (default is .zero).
    ///   - opacity: shadow opacity (default is 0.5).
    public func addShadow(ofColor color: UIColor = UIColor(red: 0.07, green: 0.47, blue: 0.57, alpha: 1.0), radius: CGFloat = 3, offset: CGSize = .zero, opacity: Float = 0.5) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }

}

private let UIViewAnimationDuration: TimeInterval = 1
private let UIViewAnimationSpringDamping: CGFloat = 0.5
private let UIViewAnimationSpringVelocity: CGFloat = 0.5



public extension UIView {
    
    // MARK: - Animation Extensions

    
    /// spring 动画  时间默认1秒
    ///
    /// - Parameters:
    ///   - animations: 动画事件
    ///   - completion: 动画完成后执行事件
	public func spring(animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
		spring(duration: UIViewAnimationDuration, animations: animations, completion: completion)
	}
    
    /// spring 动画
    ///
    /// - Parameters:
    ///   - duration: 动画时间
    ///   - animations: 动画事件
    ///   - completion: 动画完成后执行事件
	public func spring(duration: TimeInterval, animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
		UIView.animate(withDuration: UIViewAnimationDuration, delay: 0, usingSpringWithDamping: UIViewAnimationSpringDamping, initialSpringVelocity: UIViewAnimationSpringVelocity, options: UIView.AnimationOptions.allowAnimatedContent, animations: animations, completion: completion)
	}

    
    /// 缩放
	public func pop() {
		setScale(x: 1.1, y: 1.1)
		spring(duration: 0.2, animations: { [unowned self]() -> Void in
			self.setScale(x: 1, y: 1)
		})
	}
    
    /// 大幅度缩放
	public func popBig() {
		setScale(x: 1.25, y: 1.25)
		spring(duration: 0.2, animations: { [unowned self]() -> Void in
			self.setScale(x: 1, y: 1)
		})
	}
}



public extension UIView {

    // MARK: Transform Extensions
    
    /// CATransform3DRotate x
	public func setRotationX(_ x: CGFloat) {
		var transform = CATransform3DIdentity
		transform.m34 = 1.0 / -1000.0
		transform = CATransform3DRotate(transform, degreesToRadians(x), 1.0, 0.0, 0.0)
		layer.transform = transform
	}
    
    /// CATransform3DRotate y
	public func setRotationY(_ y: CGFloat) {
		var transform = CATransform3DIdentity
		transform.m34 = 1.0 / -1000.0
		transform = CATransform3DRotate(transform, degreesToRadians(y), 0.0, 1.0, 0.0)
		layer.transform = transform
	}

    /// CATransform3DRotate z
	public func setRotationZ(_ z: CGFloat) {
		var transform = CATransform3DIdentity
		transform.m34 = 1.0 / -1000.0
		transform = CATransform3DRotate(transform, degreesToRadians(z), 0.0, 0.0, 1.0)
		layer.transform = transform
	}

    /// CATransform3DRotate x y z
	public func setRotation(x: CGFloat, y: CGFloat, z: CGFloat) {
		var transform = CATransform3DIdentity
		transform.m34 = 1.0 / -1000.0
		transform = CATransform3DRotate(transform, degreesToRadians(x), 1.0, 0.0, 0.0)
		transform = CATransform3DRotate(transform, degreesToRadians(y), 0.0, 1.0, 0.0)
		transform = CATransform3DRotate(transform, degreesToRadians(z), 0.0, 0.0, 1.0)
		layer.transform = transform
	}

    /// 放大缩小
    ///
    /// - Parameters:
    ///   - x: x
    ///   - y: y
	public func setScale(x: CGFloat, y: CGFloat) {
		var transform = CATransform3DIdentity
		transform.m34 = 1.0 / -1000.0
		transform = CATransform3DScale(transform, x, y, 1)
		layer.transform = transform
	}

}


// MARK: - UIView animatable extension
/// Extends UIView with animatable functions.
extension UIView {
    
    /// 创建一个脉冲效果。(Create a pulse effect.)
    ///
    /// - Parameters:
    ///   - count: Pulse count. Default is 1.
    ///   - duration: Pulse duration. Default is 1.
    public func pulse(count: Float = 1, duration: TimeInterval = 1) {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.autoreverses = true
        animation.repeatCount = count
        
        self.layer.add(animation, forKey: "pulse")
    }
    
    /// 创建心跳效果。(Create a heartbeat effect.)
    ///
    /// - Parameters:
    ///   - count: Seconds of animation. Default is 1.
    ///   - maxSize: Maximum size of the object to animate. Default is 1.4.
    ///   - durationPerBeat: Duration per beat. Default is 0.5.
    public func heartbeat(count: Float = 1, maxSize: CGFloat = 1.4, durationPerBeat: TimeInterval = 0.5) {
        let animation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "transform")
        
        let scale1: CATransform3D = CATransform3DMakeScale(0.8, 0.8, 1)
        let scale2: CATransform3D = CATransform3DMakeScale(maxSize, maxSize, 1)
        let scale3: CATransform3D = CATransform3DMakeScale(maxSize - 0.3, maxSize - 0.3, 1)
        let scale4: CATransform3D = CATransform3DMakeScale(1.0, 1.0, 1)
        
        let frameValues = [NSValue(caTransform3D: scale1), NSValue(caTransform3D: scale2), NSValue(caTransform3D: scale3), NSValue(caTransform3D: scale4)]
        
        animation.values = frameValues
        
        let frameTimes = [NSNumber(value: 0.05), NSNumber(value: 0.2), NSNumber(value: 0.6), NSNumber(value: 1.0)]
        animation.keyTimes = frameTimes
        
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.duration = durationPerBeat
        animation.repeatCount = count / Float(durationPerBeat)
        
        self.layer.add(animation, forKey: "heartbeat")
    }
    
    /// 翻转动画的方向。(Direction of flip animation.)
    ///
    /// - top: Flip animation from top.
    /// - left: Flip animation from left.
    /// - right: Flip animation from right.
    /// - bottom: Flip animation from bottom.
    public enum UIViewAnimationFlipDirection: String {
        case top = "fromTop"
        case left = "fromLeft"
        case right = "fromRight"
        case bottom = "fromBottom"
    }

    
    /// 翻转动画。(Create a flip effect.)
    ///
    /// - Parameters:
    ///   - duration: Seconds of animation.
    ///   - direction: Direction of the flip animation.
    public func flip(duration: TimeInterval, direction: CATransitionSubtype) {
        let transition: CATransition = CATransition()
        transition.subtype = direction
        transition.startProgress = 0
        transition.endProgress = 1.0
        transition.type = CATransitionType.reveal   //convertToCATransitionType("flip")
        transition.duration = duration
        transition.repeatCount = 1
        transition.autoreverses = true
        
        self.layer.add(transition, forKey: "flip")
    }
    
    /// Direction of the translation. see `translateAround`
    ///
    /// - leftToRight: Translation from left to right.
    /// - rightToLeft: Translation from right to left.
    public enum UIViewAnimationTranslationDirection: Int {
        /// Translation from left to right.
        case leftToRight
        /// Translation from right to left.
        case rightToLeft
    }
    
    /// Translate the UIView around the topView.
    ///
    /// - Parameters:
    ///   - topView: Top view to translate to.
    ///   - duration: Duration of the translation.
    ///   - direction: Direction of the translation.
    ///   - repeatAnimation: If the animation must be repeat or no.
    ///   - startFromEdge: If the animation must start from the edge.
    public func translateAround(topView: UIView, duration: CGFloat, direction: UIViewAnimationTranslationDirection, repeatAnimation: Bool = true, startFromEdge: Bool = true) {
        var startPosition: CGFloat = self.center.x, endPosition: CGFloat
        switch direction {
        case .leftToRight:
            startPosition = self.frame.size.width / 2
            endPosition = -(self.frame.size.width / 2) + topView.frame.size.width
        case .rightToLeft:
            startPosition = -(self.frame.size.width / 2) + topView.frame.size.width
            endPosition = self.frame.size.width / 2
        }
        
        if startFromEdge {
            self.center = CGPoint(x: startPosition, y: self.center.y)
        }
        
        UIView.animate(withDuration: TimeInterval(duration / 2), delay: 1, options: UIView.AnimationOptions(), animations: {
            self.center = CGPoint(x: endPosition, y: self.center.y)
        }) { finished in
            if finished {
                UIView.animate(withDuration: TimeInterval(duration / 2), delay: 1, options: UIView.AnimationOptions(), animations: {
                    self.center = CGPoint(x: startPosition, y: self.center.y)
                }) { finished in
                    if finished {
                        if repeatAnimation {
                            self.translateAround(topView: topView, duration: duration, direction: direction, repeatAnimation: repeatAnimation, startFromEdge: startFromEdge)
                        }
                    }
                }
            }
        }
    }
    
    /// 沿路径动画。(Animate along path.)
    ///
    /// - Parameters:
    ///   - path: Path to follow.
    ///   - count: Animation repeat count. Default is 1.
    ///   - duration: Animation duration.
    public func animate(path: UIBezierPath, count: Float = 1, duration: TimeInterval, autoreverses: Bool = false) {
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.repeatCount = count
        animation.duration = duration
        animation.autoreverses = false
        
        self.layer.add(animation, forKey: "animateAlongPath")
    }
}



// MARK: - Methods
public extension UIView {

    
    /// Fade in view.
    ///
    /// - Parameters:
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil)
    public func fadeIn(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if isHidden {
            isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1
        }, completion: completion)
    }
    
    /// Fade out view.
    ///
    /// - Parameters:
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil)
    public func fadeOut(duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if isHidden {
            isHidden = false
        }
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }, completion: completion)
    }
    
    /// Load view from nib.
    ///
    /// - Parameters:
    ///   - name: nib name.
    ///   - bundle: bundle of nib (default is nil).
    /// - Returns: optional UIView (if applicable).
    public class func loadFromNib(named name: String, bundle: Bundle? = nil) -> UIView? {
        return UINib(nibName: name, bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }


    
    /// Scale view by offset.
    ///
    /// - Parameters:
    ///   - offset: scale offset
    ///   - animated: set true to animate scaling (default is false).
    ///   - duration: animation duration in seconds (default is 1 second).
    ///   - completion: optional completion handler to run with animation finishes (default is nil).
    public func scale(by offset: CGPoint, animated: Bool = false, duration: TimeInterval = 1, completion: ((Bool) -> Void)? = nil) {
        if animated {
            UIView.animate(withDuration: duration, delay: 0, options: .curveLinear, animations: { () -> Void in
                self.transform = self.transform.scaledBy(x: offset.x, y: offset.y)
            }, completion: completion)
        } else {
            transform = transform.scaledBy(x: offset.x, y: offset.y)
            completion?(true)
        }
    }
    

    /// Add Visual Format constraints.
    ///
    /// - Parameters:
    ///   - withFormat: visual Format language
    ///   - views: array of views which will be accessed starting with index 0 (example: [v0], [v1], [v2]..)
    @available(iOS 9, *) public func addConstraints(withFormat: String, views: UIView...) {
        // https://videos.letsbuildthatapp.com/
        var viewsDictionary: [String: UIView] = [:]
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: withFormat, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    /// Anchor all sides of the view into it's superview.
    @available(iOS 9, *) public func fillToSuperview() {
        // https://videos.letsbuildthatapp.com/
        translatesAutoresizingMaskIntoConstraints = false
        if let superview = superview {
            leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
            rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
            topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
            bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        }
    }
    
    /// Add anchors from any side of the current view into the specified anchors and returns the newly added constraints.
    ///
    /// - Parameters:
    ///   - top: current view's top anchor will be anchored into the specified anchor
    ///   - left: current view's left anchor will be anchored into the specified anchor
    ///   - bottom: current view's bottom anchor will be anchored into the specified anchor
    ///   - right: current view's right anchor will be anchored into the specified anchor
    ///   - topConstant: current view's top anchor margin
    ///   - leftConstant: current view's left anchor margin
    ///   - bottomConstant: current view's bottom anchor margin
    ///   - rightConstant: current view's right anchor margin
    ///   - widthConstant: current view's width
    ///   - heightConstant: current view's height
    /// - Returns: array of newly added constraints (if applicable).
    @available(iOS 9, *) @discardableResult public func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        left: NSLayoutXAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        right: NSLayoutXAxisAnchor? = nil,
        topConstant: CGFloat = 0,
        leftConstant: CGFloat = 0,
        bottomConstant: CGFloat = 0,
        rightConstant: CGFloat = 0,
        widthConstant: CGFloat = 0,
        heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        // https://videos.letsbuildthatapp.com/
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }
        
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }
        
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
    
    /// Anchor center X into current view's superview with a constant margin value.
    ///
    /// - Parameter constant: constant of the anchor constraint (default is 0).
    @available(iOS 9, *) public func anchorCenterXToSuperview(constant: CGFloat = 0) {
        // https://videos.letsbuildthatapp.com/
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerXAnchor {
            centerXAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    /// Anchor center Y into current view's superview with a constant margin value.
    ///
    /// - Parameter withConstant: constant of the anchor constraint (default is 0).
    @available(iOS 9, *) public func anchorCenterYToSuperview(constant: CGFloat = 0) {
        // https://videos.letsbuildthatapp.com/
        translatesAutoresizingMaskIntoConstraints = false
        if let anchor = superview?.centerYAnchor {
            centerYAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
        }
    }
    
    /// Anchor center X and Y into current view's superview
    @available(iOS 9, *) public func anchorCenterSuperview() {
        // https://videos.letsbuildthatapp.com/
        anchorCenterXToSuperview()
        anchorCenterYToSuperview()
    }
    
    
    /// 搜索所有超级视图，直到找到具有条件的视图。 Search all superviews until a view with the condition is found.
    ///
    /// - Parameter predicate: 条件 predicate to evaluate on superviews.
    public func ancestorView(where predicate: (UIView?) -> Bool) -> UIView? {
        if predicate(superview) {
            return superview
        }
        return superview?.ancestorView(where: predicate)
    }
    
    /// 搜索所有超级视图，直到找到具有此类的视图。 Search all superviews until a view with this class is found.
    ///
    /// - Parameter name: class of the view to search.
    public func ancestorView<T: UIView>(withClass name: T.Type) -> T? {
        return ancestorView(where: { $0 is T }) as? T
    }
}



