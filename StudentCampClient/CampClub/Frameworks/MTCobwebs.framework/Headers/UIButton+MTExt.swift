//
//  UIButton+MTExt.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.

import UIKit

/// 按钮图片位置
public enum UIButtonImageHorizontalAlignment {
    case left, right
}

public extension UIButton {

    /// 图文排版   最好在viewWillLayoutSubviews里面调用，保证界面位置正确
    ///
    /// - Parameters:
    ///   - spacing: 间隔值
    ///   - imageSize: 显示的图片大小
    ///   - vertical: 是否垂直 true：垂直 false：水平    默认水平
    ///   - align: 水平图片位置
    public func makeImageToTitle(_ spacing: CGFloat, imageSize: CGSize? = nil, vertical: Bool = false, align :UIButtonImageHorizontalAlignment = .left) {
        guard let image = imageView?.image, let title = titleLabel?.text else {return}
        if vertical {
            if imageSize != nil {
                let buttonSize: CGSize = frame.size
                let buttonTitle: String = title
                let titleSize: CGSize = buttonTitle.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font])
                let buttonImage: UIImage = image
                let buttonImageSize: CGSize = imageSize == nil ? buttonImage.size : imageSize!
                let offsetBetweenImageAndText: CGFloat = spacing
                // vertical space between image and text
                self.contentHorizontalAlignment = .left
                self.contentVerticalAlignment = .top
                
                self.imageEdgeInsets = UIEdgeInsets.init(top: (buttonSize.height - (titleSize.height + buttonImageSize.height)) / 2 - offsetBetweenImageAndText, left: (buttonSize.width - buttonImageSize.width) / 2, bottom: 0, right: 0)
                self.imageEdgeInsets = UIEdgeInsets.init(top: self.imageEdgeInsets.top, left: self.imageEdgeInsets.left, bottom: buttonSize.height - self.imageEdgeInsets.top - buttonImageSize.height, right: buttonSize.width - self.imageEdgeInsets.left - buttonImageSize.width)
                /// 设置图片大小
                self.titleEdgeInsets = UIEdgeInsets.init(top: (buttonSize.height - (titleSize.height + buttonImageSize.height)) / 2 + buttonImageSize.height + offsetBetweenImageAndText, left: titleSize.width + self.imageEdgeInsets.left > buttonSize.width ? -buttonImageSize.width + (buttonSize.width - titleSize.width) / 2: (buttonSize.width - titleSize.width) / 2 - buttonImageSize.width, bottom: 0, right: 0)
                
                /// 设置标题  注意： 一定要用 buttonImage.size
                self.titleEdgeInsets = UIEdgeInsets.init(top: (buttonSize.height - (titleSize.height + buttonImageSize.height)) / 2 + buttonImageSize.height + offsetBetweenImageAndText,
                                                        left: titleSize.width + self.imageEdgeInsets.left > buttonSize.width ? -buttonImage.size.width + (buttonSize.width - titleSize.width) / 2: (buttonSize.width - titleSize.width) / 2 - buttonImage.size.width, bottom: 0, right: 0)
                /// 一定要用 buttonImage.size
                //            self.titleEdgeInsets = UIEdgeInsetsMake(self.titleEdgeInsets.top, self.titleEdgeInsets.left,
                //                                self.imageEdgeInsets.bottom - titleSize.height - offsetBetweenImageAndText,
                //                                self.titleEdgeInsets.left)
            } else {
                let buttonSize: CGSize = frame.size
                let buttonTitle: String = title
                let titleSize: CGSize = buttonTitle.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font])
                let buttonImage: UIImage = image
                let buttonImageSize: CGSize = buttonImage.size
                let offsetBetweenImageAndText: CGFloat = spacing
                // vertical space between image and text
                self.contentHorizontalAlignment = .left
                self.contentVerticalAlignment = .top
                
                self.imageEdgeInsets = UIEdgeInsets.init(top: (buttonSize.height - (titleSize.height + buttonImageSize.height)) / 2 - offsetBetweenImageAndText, left: (buttonSize.width - buttonImageSize.width) / 2, bottom: 0, right: 0)
                self.titleEdgeInsets = UIEdgeInsets.init(top: (buttonSize.height - (titleSize.height + buttonImageSize.height)) / 2 + buttonImageSize.height + offsetBetweenImageAndText, left: titleSize.width + self.imageEdgeInsets.left > buttonSize.width ? -buttonImage.size.width + (buttonSize.width - titleSize.width) / 2: (buttonSize.width - titleSize.width) / 2 - buttonImage.size.width, bottom: 0, right: 0)
            }
        }
        else {
            
            let insetAmount: CGFloat = spacing / 2.0
            switch align {
            case .left:
                self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
                self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
                self.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
            case .right:
                let buttonTitle: String = title
                let titleSize: CGSize = buttonTitle.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font])
                //let buttonImage: UIImage = imageView!.image!
                //let buttonImageSize: CGSize = buttonImage.size
                self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -insetAmount - titleSize.width / 2 , bottom: 0, right: insetAmount)
                self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: insetAmount + titleSize.width, bottom: 0, right: -insetAmount)
                self.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
            }
        }
        
    }
    
}

public extension UIButton {


    /// 初始化UIButton
    ///
    /// - Parameters:
    ///   - x: x
    ///   - y: y
    ///   - w: width
    ///   - h: height
    ///   - target: target
    ///   - action: action
	public convenience init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, target: AnyObject, action: Selector) {
		self.init(frame: CGRect(x: x, y: y, width: w, height: h))
		addTarget(target, action: action, for: UIControl.Event.touchUpInside)
	}

    /// 设置背景颜色 (颜色生成图片)
    ///
    /// - Parameters:
    ///   - color: 背景颜色
    ///   - forState: 按钮状态
	public func setBackgroundColor(_ color: UIColor, forState: UIControl.State) {
		UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
		UIGraphicsGetCurrentContext()?.setFillColor(color.cgColor)
		UIGraphicsGetCurrentContext()?.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
		let colorImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		self.setBackgroundImage(colorImage, for: forState)
	}

}


#if os(iOS) || os(tvOS)
    import UIKit
    /*
    // MARK: - Properties
    public extension UIButton {
        
        ///  Image of disabled state for button; also inspectable from Storyboard.
        @IBInspectable public var imageForDisabled: UIImage? {
            get {
                return image(for: .disabled)
            }
            set {
                setImage(newValue, for: .disabled)
            }
        }
        
        ///  Image of highlighted state for button; also inspectable from Storyboard.
        @IBInspectable public var imageForHighlighted: UIImage? {
            get {
                return image(for: .highlighted)
            }
            set {
                setImage(newValue, for: .highlighted)
            }
        }
        
        ///  Image of normal state for button; also inspectable from Storyboard.
        @IBInspectable public var imageForNormal: UIImage? {
            get {
                return image(for: .normal)
            }
            set {
                setImage(newValue, for: .normal)
            }
        }
        
        ///  Image of selected state for button; also inspectable from Storyboard.
        @IBInspectable public var imageForSelected: UIImage? {
            get {
                return image(for: .selected)
            }
            set {
                setImage(newValue, for: .selected)
            }
        }
        
        ///  Title color of disabled state for button; also inspectable from Storyboard.
        @IBInspectable public var titleColorForDisabled: UIColor? {
            get {
                return titleColor(for: .disabled)
            }
            set {
                setTitleColor(newValue, for: .disabled)
            }
        }
        
        ///  Title color of highlighted state for button; also inspectable from Storyboard.
        @IBInspectable public var titleColorForHighlighted: UIColor? {
            get {
                return titleColor(for: .highlighted)
            }
            set {
                setTitleColor(newValue, for: .highlighted)
            }
        }
        
        ///  Title color of normal state for button; also inspectable from Storyboard.
        @IBInspectable public var titleColorForNormal: UIColor? {
            get {
                return titleColor(for: .normal)
            }
            set {
                setTitleColor(newValue, for: .normal)
            }
        }
        
        ///  Title color of selected state for button; also inspectable from Storyboard.
        @IBInspectable public var titleColorForSelected: UIColor? {
            get {
                return titleColor(for: .selected)
            }
            set {
                setTitleColor(newValue, for: .selected)
            }
        }
        
        ///  Title of disabled state for button; also inspectable from Storyboard.
        @IBInspectable public var titleForDisabled: String? {
            get {
                return title(for: .disabled)
            }
            set {
                setTitle(newValue, for: .disabled)
            }
        }
        
        ///  Title of highlighted state for button; also inspectable from Storyboard.
        @IBInspectable public var titleForHighlighted: String? {
            get {
                return title(for: .highlighted)
            }
            set {
                setTitle(newValue, for: .highlighted)
            }
        }
        
        ///  Title of normal state for button; also inspectable from Storyboard.
        @IBInspectable public var titleForNormal: String? {
            get {
                return title(for: .normal)
            }
            set {
                setTitle(newValue, for: .normal)
            }
        }
        
        ///  Title of selected state for button; also inspectable from Storyboard.
        @IBInspectable public var titleForSelected: String? {
            get {
                return title(for: .selected)
            }
            set {
                setTitle(newValue, for: .selected)
            }
        }
        
    }
    */

    // MARK: - Methods
    public extension UIButton {
        
        private var states: [UIControl.State] {
            return [.normal, .selected, .highlighted, .disabled]
        }
        
        ///  Set image for all states.
        ///
        /// - Parameter image: UIImage.
        public func setImageForAllStates(_ image: UIImage) {
            states.forEach { self.setImage(image, for: $0) }
        }
        
        ///  Set title color for all states.
        ///
        /// - Parameter color: UIColor.
        public func setTitleColorForAllStates(_ color: UIColor) {
            states.forEach { self.setTitleColor(color, for: $0) }
        }
        
        ///  Set title for all states.
        ///
        /// - Parameter title: title string.
        public func setTitleForAllStates(_ title: String) {
            states.forEach { self.setTitle(title, for: $0) }
        }
        
        ///  Center align title text and image on UIButton
        ///
        /// - Parameter spacing: spacing between UIButton title text and UIButton Image.
        public func centerTextAndImage(spacing: CGFloat) {
            let insetAmount = spacing / 2
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
        }
        
}
#endif
