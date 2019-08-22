//  UITextField+MTExt.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.


import UIKit


public extension UITextField {
    /// 是否空，包括长度为0 (Check if text field is empty.)
    public var isEmpty: Bool {
        if let text = self.text {
            return text.isEmpty
        }
        return true
    }
    
    /// Return text with no spaces or new lines in beginning and end.
    public var trimmedText: String? {
        return text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    /// Automatically sets these values: backgroundColor = clearColor, textColor = ThemeNicknameColor, clipsToBounds = true,
    /// textAlignment = Left, userInteractionEnabled = true, editable = false, scrollEnabled = false, fontsize = 17
    public convenience init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
        self.init(x: x, y: y, w: w, h: h, fontSize: 17)
    }
    
    /// Automatically sets these values: backgroundColor = clearColor, textColor = ThemeNicknameColor, clipsToBounds = true,
    /// textAlignment = Left, userInteractionEnabled = true, editable = false, scrollEnabled = false
    public convenience init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, fontSize: CGFloat) {
        self.init(frame: CGRect(x: x, y: y, width: w, height: h))
        font = UIFont.systemFont(ofSize: fontSize)
        backgroundColor = UIColor.clear
        clipsToBounds = true
        textAlignment = NSTextAlignment.left
        isUserInteractionEnabled = true
    }
    
}

// MARK: - Methods
public extension UITextField {
    
    /// 清空文本 (Clear text.)
    public func clear() {
        text = ""
        attributedText = NSAttributedString(string: "")
    }
    
    /// Set placeholder text color.
    ///
    /// - Parameter color: placeholder text color.
    public func setPlaceHolderTextColor(_ color: UIColor) {
        guard let holder = placeholder, !holder.isEmpty else { return }
        self.attributedPlaceholder = NSAttributedString(string: holder, attributes: [.foregroundColor: color])
    }
    
    /// 在文本的左侧添加填充。(Add padding to the left of the textfield rect.)
    ///
    /// - Parameter padding: amount of padding to apply to the left of the textfield rect.
    public func addPaddingLeft(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
    }
    
    /// 在文本的左侧添加图片填充。(Add padding to the left of the textfield rect.)
    ///
    /// - Parameters:
    ///   - image: left image
    ///   - padding: amount of padding between icon and the left of textfield
    public func addPaddingLeftIcon(_ image: UIImage, padding: CGFloat) {
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        self.leftView = imageView
        self.leftView?.frame.size = CGSize(width: image.size.width + padding, height: image.size.height)
        self.leftViewMode = UITextField.ViewMode.always
    }
    
}


public extension UITextField {
    
    /// 设置底部边线阴影
    public func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}


/// canPerformAction key
fileprivate var textFieldCanPerformKey: Void?

extension UITextField {
    // MARK: - 不可复制粘贴选择的输入框
    
    /// 是否允许长按显示菜单  此处屏蔽 复制，选择全部，粘贴
    @IBInspectable open var canPerformAction: Bool {
        get { return (objc_getAssociatedObject(self, &textFieldCanPerformKey) as? Bool) ?? true }
        set(newValue) { objc_setAssociatedObject(self, &textFieldCanPerformKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
        
    }
    
    
    //    override func caretRect(for position: UITextPosition) -> CGRect {
    //        return CGRect.zero
    //    }
    
    //    override func selectionRects(for range: UITextRange) -> [Any] {
    //        return []
    //    }
    
    /// override canPerformAction
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if action == #selector(copy(_:)) || action == #selector(selectAll(_:)) || action == #selector(paste(_:)) {
            return canPerformAction
        }
        return super.canPerformAction(action, withSender: sender)
    }
}



