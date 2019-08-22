//
//  Created by Luochun
//  Copyright © 2016-2018年 Mantis Group. All rights reserved.
//

import UIKit



@objc open class MTNumberKeyboardViewController: UIInputViewController
{
    @IBOutlet weak var keyboardView: UIView!
    
    fileprivate var privateAllowDecimalPoint = false
    
    fileprivate var selectedTextButtonBackgroundImage:UIImage?
    fileprivate var selectedBackspaceButtonBackgroundImage:UIImage?
    fileprivate var selectedReturnButtonBackgroundImage:UIImage?
    
    open var backspaceAction:(() -> ())?
    open var newTextAction:((_ text:String) -> ())?
    open var returnAction:(() -> ())?
    
    @IBOutlet weak var backspaceButton: MTDecimalKeyboardBackspaceButton!
    @IBOutlet weak var returnButton: MTDecimalKeyboardReturnButtonButton!
    @IBOutlet weak var hideButton: MTDecimalKeyboardHideButtonButton!
    
    @IBOutlet weak var dotButton: MTDecimalKeyboardDotButton!//@IBOutlet weak fileprivate var dotButton: MTDecimalKeyboardDotButton!
    @IBOutlet weak fileprivate var zeroBigButton: MTDecimalKeyboardZeroButton!
    @IBOutlet weak fileprivate var zeroSmallButton: MTDecimalKeyboardZeroButton!
    
    static public func createDecimalKeyboard() -> MTNumberKeyboardViewController
    {
        // object_getClass(MTNumberKeyboardViewController)
        let nib = UINib(nibName: "MTNumberKeyboardViewController", bundle: Bundle(for: MTNumberKeyboardViewController.self))
        let objects = nib.instantiate(withOwner: self, options: nil)
        let vc = objects[0] as! MTNumberKeyboardViewController;
        return vc
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        configureKeyboard()
    }
    
    fileprivate func configureKeyboard() {
        configureSelectedButtonBackgroundImages()
        configureDecimalPointButton()
    }
    
    override open func updateViewConstraints() {
        super.updateViewConstraints()
        // Add custom view sizing constraints here
    }

    override open func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override open func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
    }
}

extension MTNumberKeyboardViewController {
    @IBAction func buttonPressedAction(_ button: MTDecimalKeyboardButton)
    {
        processActionType(button.theButtonActionType())
        processNewText(button.theButtonText())
    }
}

// MARK: - Configuration Setters
extension MTNumberKeyboardViewController {
    public var allowDecimalPoint:Bool {
        get {
            return privateAllowDecimalPoint
        }
        set(newValue) {
            privateAllowDecimalPoint = newValue
            configureDecimalPointButton()
        }
    }
    
    
    public var textButtons:[UIButton] {
        get {
            var buttons = Array<UIButton>()
            
            for theView in keyboardView.subviews {
                if theView.isKind(of: MTDecimalKeyboardTextButton.self) {
                    buttons.append(theView as! MTDecimalKeyboardTextButton)
                }
            }
            
            return buttons
        }
    }
    
    public var numberKeyboardReturnButton:UIButton {
        get {
            return returnButton
        }
    }
    
    public var numberKeyboardBackspaceButton:UIButton {
        get {
            return backspaceButton
        }
    }
    
    public var numberKeyboardView:UIView {
        get {
            return keyboardView
        }
    }
    
    public var allButtons:[UIButton] {
        get {
            var buttons = self.textButtons
            
            buttons.append(backspaceButton)
            buttons.append(returnButton)
            buttons.append(hideButton)
            return buttons
        }
    }

    public func setSelectedTextButtonBackgroundImage(_ image:UIImage) {
        selectedTextButtonBackgroundImage = image
        configureSelectedButtonBackgroundImages()
    }
    
    public func setSelectedBackspaceButtonBackgroundImage(_ image:UIImage) {
        selectedBackspaceButtonBackgroundImage = image
        configureSelectedButtonBackgroundImages()
    }
    
    public func setSelectedReturnButtonBackgroundImage(_ image:UIImage) {
        selectedReturnButtonBackgroundImage = image
        configureSelectedButtonBackgroundImages()
    }
    
    public func setSelectedTextButtonBackgroundColor(_ color:UIColor) {
        selectedTextButtonBackgroundImage = MTNumberKeyboardViewController.createWithColor(color)
        configureSelectedButtonBackgroundImages()
    }
    
    public func setSelectedBackspaceButtonBackgroundColor(_ color:UIColor) {
        selectedBackspaceButtonBackgroundImage = MTNumberKeyboardViewController.createWithColor(color)
        configureSelectedButtonBackgroundImages()
    }
    
    public func setSelectedReturnButtonBackgroundColor(_ color:UIColor) {
        selectedReturnButtonBackgroundImage = MTNumberKeyboardViewController.createWithColor(color)
        configureSelectedButtonBackgroundImages()
    }
}

// MARK: - Private
extension MTNumberKeyboardViewController {
    
    fileprivate func configureDecimalPointButton() {
        dotButton.isHidden = !privateAllowDecimalPoint
        zeroSmallButton.isHidden = !privateAllowDecimalPoint
        zeroBigButton.isHidden = privateAllowDecimalPoint
    }
    
    fileprivate func processActionType(_ actionType:ButtonActionType?) {
        guard let theActionType = actionType else {
            return
        }
        
        switch theActionType {
        case .backspace:
            processBackspace()
        case .returnButton:
            processReturn()
        case .hideKeyboard:
            processHideKeyboard()
        }
    }
    
    fileprivate func processHideKeyboard() {
        dismissKeyboard()
    }
    
    fileprivate func processBackspace() {
        self.textDocumentProxy.deleteBackward()
        if let theBackspaceAction = backspaceAction {
            theBackspaceAction()
        }
    }
    
    fileprivate func processReturn() {
        dismissKeyboard()
        if let theReturnAction = returnAction {
            theReturnAction()
        }
    }
    
    fileprivate func processNewText(_ text:String?) {
        guard let theText = text else {
            return
        }
        
        self.textDocumentProxy.insertText(theText)
        
        if let theNewTextAction = newTextAction {
            theNewTextAction(theText)
        }
    }
    
    fileprivate func defaultSelectedButtonImage() -> UIImage {
        struct imageInstance {
            static let image = MTNumberKeyboardViewController.createWithColor(UIColor.black)
        }
        
        return imageInstance.image
    }
    
    fileprivate func configureSelectedButtonBackgroundImages() {
        if let theImage = selectedTextButtonBackgroundImage {
            setTextButtonsSelectedButtonBackgroundImage(theImage)
        } else {
            selectedTextButtonBackgroundImage = defaultSelectedButtonImage()
            setTextButtonsSelectedButtonBackgroundImage(selectedTextButtonBackgroundImage!)
        }
        
        if let theImage = selectedReturnButtonBackgroundImage {
            setSelectedButtonImage(returnButton, image:theImage)
        } else {
            selectedReturnButtonBackgroundImage = defaultSelectedButtonImage()
            setSelectedButtonImage(returnButton, image:selectedReturnButtonBackgroundImage!)
        }
        
        if let theImage = selectedBackspaceButtonBackgroundImage {
            setSelectedButtonImage(backspaceButton, image:theImage)
        } else {
            selectedBackspaceButtonBackgroundImage = defaultSelectedButtonImage()
            setSelectedButtonImage(backspaceButton, image:selectedBackspaceButtonBackgroundImage!)
        }
    }
    
    fileprivate func setTextButtonsSelectedButtonBackgroundImage(_ image:UIImage) {
        for theView in keyboardView.subviews {
            if theView.isKind(of: MTDecimalKeyboardTextButton.self) {
                let button = theView as! MTDecimalKeyboardTextButton
                setSelectedButtonImage(button, image:image)
            }
        }
    }
    
    fileprivate func setSelectedButtonImage(_ button:UIButton, image:UIImage) {
        button.setBackgroundImage(image, for: .selected)
        button.setBackgroundImage(image, for: .highlighted)
    }
    

}

// MARK: - Tools
extension MTNumberKeyboardViewController {
    
    fileprivate static func createWithColor(_ color:UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor);
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

