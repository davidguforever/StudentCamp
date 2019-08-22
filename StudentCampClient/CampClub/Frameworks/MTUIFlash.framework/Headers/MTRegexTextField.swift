//  MTRegexTextField.swift
//
//  Copyright © 2016-2018年 Mantis Group. All rights reserved.
//


import UIKit
import Foundation


/// `MTRegexTextField` Delegate
public protocol MTRegexTextFieldDelegate {
    
    func regexTextField(_ textField: MTRegexTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
}

/// 固定正则表达式的文本输入框
public class MTRegexTextField: UITextField ,UITextFieldDelegate {
    
    public var regexDelegate: MTRegexTextFieldDelegate?
    
    fileprivate var keyboardVC = MTNumberKeyboardViewController.createDecimalKeyboard()
    
    
    /// 输入类型 默认小数。 see `InputType`
    public var inputType: InputType = .numberic {
        didSet {
            self.keyboardVC.allowDecimalPoint = (inputType == .numberic || inputType == .identNumber)
            if inputType == .identNumber {
                self.keyboardVC.dotButton.setTitle("X", for: .normal)
            } else {
                self.keyboardVC.dotButton.setTitle(".", for: .normal)
            }
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureKeyboard()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureKeyboard()
    }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        configureKeyboard()
    }

    fileprivate func configureKeyboard() {
        self.keyboardVC.allowDecimalPoint = true
        self.keyboardVC.setSelectedTextButtonBackgroundColor(UIColor.lightGray)
        self.keyboardVC.setSelectedReturnButtonBackgroundColor(UIColor.lightGray)
        self.keyboardVC.setSelectedBackspaceButtonBackgroundColor(UIColor.lightGray)
        
        self.keyboardVC.numberKeyboardReturnButton.setTitle("确定", for: .normal)
        

        //        for button in self.keyboardVC.allButtons
        //        {
        //            let layer = button.layer
        //            layer.masksToBounds = true
        //            layer.cornerRadius = 2
        //        }
        
        self.keyboardVC.returnAction = { () -> Void in
            // TODO: handle return button pressed
        }
        
        self.keyboardVC.backspaceAction = { () -> Void in
            // TODO: handle backspace button pressed
        }
        
        self.keyboardVC.newTextAction = { (text:String) -> Void in
            // TODO: handle insert new text
        }
        
        self.inputView = self.keyboardVC.numberKeyboardView
        //self.addLeftPadding(10)
        self.delegate = self
    }
    
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = textField.text! as NSString
        let text: String = newText.replacingCharacters(in: range, with: string)
        
        switch inputType {
        case .numberic:
            if text.count > 0 {
                
                if  text == "." || text == "0" || text == "0.0" {
                    return true
                }
                
                if text.count( of: ".") > 1 {
                    return false
                } else if text.last == "." && text.count( of: ".") == 1 {
                    return true
                }
                return text.checkRegex(.numberic)
            }
            return true
        case .telephone:
            if text.count > 0 {
                if text.count >= 11 {
                    return text.checkRegex(.telephone)
                }
                if text.onlyNumbers {
                    return true
                } else {
                    return false
                }
            }
            return true
        case .bankcard:
            if text.count > 0 {
                
                if text.count >= 25 {
                    return text.checkRegex(.bankcard)
                } else {
                    textField.text = text.insert(" ", interval: 4)
                    return false
                }
            }
            return true
            
        case .identNumber:
            if text.count > 0 {
                if text.count >= 18 {
                    return text.checkRegex(.identNumber)
                } else if text.onlyNumbers {
                    return true
                } else {
                    return false
                }
            }
            return true
            
        }
        
    }
    

}


extension UITextField {
    
    /// Set placeholder text color.
    ///
    /// - Parameter color: placeholder text color.
    public func setPlaceHolderTextColor(_ color: UIColor) {
        self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
    
    
    /// Add left padding to the text in textfield
    public func addLeftPadding(_ blankSize: CGFloat) {
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: blankSize, height: frame.height)
        self.leftView = leftView
        self.leftViewMode = UITextField.ViewMode.always
    }
    
}


 extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
    /// 指定字符串的数量 (Counts number of instances of the input inside String)
    func count(of substring: String) -> Int {
        return components(separatedBy: substring).count - 1
    }
    
    func replace(_ target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    var onlyNumbers: Bool {
        let characters = CharacterSet.decimalDigits.inverted
        return !self.isEmpty && rangeOfCharacter(from: characters) == nil
    }
    

    func insert(_ target: String, interval: Int) -> String {
        var oldStr = self.replace(" ", withString: "")
        var newStr = ""
        
        while oldStr.count > 0 {
            let length: Int = oldStr.count
            let subStr = oldStr[0 ..< min(length, interval)]
            newStr.append(subStr)
            if subStr.count == interval {
                newStr.append(target)
            }
            oldStr = oldStr[ min(length, interval) ..< oldStr.count]
        }
        return newStr
    }
}
