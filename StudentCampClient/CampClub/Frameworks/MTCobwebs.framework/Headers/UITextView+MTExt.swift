//  UITextView+MTExt.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.

import UIKit

public extension UITextView {
    /// Automatically sets these values: backgroundColor = clearColor, textColor = ThemeNicknameColor, clipsToBounds = true,
    /// textAlignment = Left, userInteractionEnabled = true, editable = false, scrollEnabled = false, font = ThemeFontName, fontsize = 17
    public convenience init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
        self.init(x: x, y: y, w: w, h: h, fontSize: 17)
    }
    
    /// Automatically sets these values: backgroundColor = clearColor, textColor = ThemeNicknameColor, clipsToBounds = true,
    /// textAlignment = Left, userInteractionEnabled = true, editable = false, scrollEnabled = false, font = ThemeFontName
    public convenience init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, fontSize: CGFloat) {
        self.init(frame: CGRect(x: x, y: y, width: w, height: h))
        font = UIFont(name: "HelveticaNeue", size: fontSize)
        
        backgroundColor = UIColor.clear
        clipsToBounds = true
        textAlignment = NSTextAlignment.left
        isUserInteractionEnabled = true
        #if os(iOS)
            isEditable = false
        #endif
        isScrollEnabled = false
    }
    
    
    /// 在键盘顶部添加工具栏，并添加个确定按钮 (Automatically adds a toolbar with a done button to the top of the keyboard. Tapping the button will dismiss the keyboard.)
    ///
    /// - Parameters:
    ///   - barStyle: barStyle
    ///   - title: 按钮Title, 默认“Done”
    public func addDoneButton(_ barStyle: UIBarStyle = .default, title: String? = nil) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: title ?? "Done", style: .done, target: self, action: #selector(resignFirstResponder))
        ]
        
        keyboardToolbar.barStyle = barStyle
        keyboardToolbar.sizeToFit()
        
        inputAccessoryView = keyboardToolbar
    }
    
    /// Clear text.
    public func clear() {
        text = ""
        attributedText = NSAttributedString(string: "")
    }
    
    /// Scroll to the bottom of text view
    public func scrollToBottom() {
        let range = NSMakeRange((text as NSString).length - 1, 1)
        scrollRangeToVisible(range)
        
    }
    
    /// Scroll to the top of text view
    public func scrollToTop() {
        let range = NSMakeRange(0, 1)
        scrollRangeToVisible(range)
    }
}


/// canPerformAction key
fileprivate var textViewCanPerformKey: Void?

extension UITextView {
    // MARK: - 不可复制粘贴选择的输入框
    
    /// 是否允许长按显示菜单  此处屏蔽 复制，选择全部，粘贴
    @IBInspectable open var canPerformAction: Bool {
        get { return (objc_getAssociatedObject(self, &textViewCanPerformKey) as? Bool) ?? true }
        set(newValue) { objc_setAssociatedObject(self, &textViewCanPerformKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
        
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
