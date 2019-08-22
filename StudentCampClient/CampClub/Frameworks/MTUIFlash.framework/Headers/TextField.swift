//
//  TextField.swift
//
//  Copyright © 2016-2018年 Mantis Group. All rights reserved.
//

import UIKit


/// 输入框编辑菜单动作
public enum ResponderStandardEditActions {
    case cut, copy, paste, select, selectAll, delete
    case makeTextWritingDirectionLeftToRight, makeTextWritingDirectionRightToLeft
    case toggleBoldface, toggleItalics, toggleUnderline
    case increaseSize, decreaseSize
    
    /// 编辑菜单方法 UIResponderStandardEditActions
    var selector: Selector {
        switch self {
        case .cut:
            return #selector(UIResponderStandardEditActions.cut)
        case .copy:
            return #selector(UIResponderStandardEditActions.copy)
        case .paste:
            return #selector(UIResponderStandardEditActions.paste)
        case .select:
            return #selector(UIResponderStandardEditActions.select)
        case .selectAll:
            return #selector(UIResponderStandardEditActions.selectAll)
        case .delete:
            return #selector(UIResponderStandardEditActions.delete)
        case .makeTextWritingDirectionLeftToRight:
            return #selector(UIResponderStandardEditActions.makeTextWritingDirectionLeftToRight)
        case .makeTextWritingDirectionRightToLeft:
            return #selector(UIResponderStandardEditActions.makeTextWritingDirectionRightToLeft)
        case .toggleBoldface:
            return #selector(UIResponderStandardEditActions.toggleBoldface)
        case .toggleItalics:
            return #selector(UIResponderStandardEditActions.toggleItalics)
        case .toggleUnderline:
            return #selector(UIResponderStandardEditActions.toggleUnderline)
        case .increaseSize:
            return #selector(UIResponderStandardEditActions.increaseSize)
        case .decreaseSize:
            return #selector(UIResponderStandardEditActions.decreaseSize)
        }
    }
    
}

/// 文本输入框
///
///        let textField = TextField(frame: CGRect(x: 50, y: 50, width: 200, height: 50))
///        textField.borderStyle = .roundedRect
///        view.addSubview(textField)
///        textField.allowedActions = [.copy, .cut]
///        //textField.notAllowedActions = [.copy, .cut]
public class TextField: UITextField {
    
    
    /// 允许显示的菜单
    public var allowedActions: [ResponderStandardEditActions] = [] {
        didSet {
            if !allowedActions.isEmpty && !notAllowedActions.isEmpty {
                notAllowedActions = []
            }
        }
    }
    /// 不允许显示的菜单
    public var notAllowedActions: [ResponderStandardEditActions] = [] {
        didSet {
            if !allowedActions.isEmpty && !notAllowedActions.isEmpty {
                allowedActions = []
            }
        }
    }
    
    /// override canPerformAction
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if !allowedActions.isEmpty {
            return allowedActions.map{ $0.selector }.contains(action)
        }
        
        if !notAllowedActions.isEmpty {
            return !notAllowedActions.map{ $0.selector }.contains(action)
        }
        return super.canPerformAction(action, withSender: sender)
    }
}

