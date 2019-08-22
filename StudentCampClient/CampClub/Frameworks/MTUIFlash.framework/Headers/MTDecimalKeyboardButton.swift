//
//  Created by Luochun
//  Copyright © 2016-2018年 Mantis Group. All rights reserved.
//


import UIKit

enum ButtonActionType:Int {
    case backspace
    case returnButton
    case hideKeyboard
}

protocol MTDecimalKeyboardButtonProtocol {
    func theButtonText() -> String?
    func theButtonActionType() -> ButtonActionType?
}

public class MTDecimalKeyboardButton: UIButton, MTDecimalKeyboardButtonProtocol {
    func theButtonText() -> String? {
        return nil
    }
    
    func theButtonActionType() -> ButtonActionType? {
        return nil
    }
}

public class MTDecimalKeyboardTextButton: MTDecimalKeyboardButton {
}

public class MTDecimalKeyboardZeroButton: MTDecimalKeyboardTextButton {
    override func theButtonText() -> String? {
        return "0"
    }
}

public class MTDecimalKeyboardOneButton: MTDecimalKeyboardTextButton {
    override func theButtonText() -> String? {
        return "1"
    }
}

public class MTDecimalKeyboardTwoButton: MTDecimalKeyboardTextButton {
    override func theButtonText() -> String? {
        return "2"
    }
}

public class MTDecimalKeyboardThreeButton: MTDecimalKeyboardTextButton {
    override func theButtonText() -> String? {
        return "3"
    }
}

public class MTDecimalKeyboardFourButton: MTDecimalKeyboardTextButton {
    override func theButtonText() -> String? {
        return "4"
    }
}

public class MTDecimalKeyboardFiveButton: MTDecimalKeyboardTextButton {
    override func theButtonText() -> String? {
        return "5"
    }
}

public class MTDecimalKeyboardSixButton: MTDecimalKeyboardTextButton {
    override func theButtonText() -> String? {
        return "6"
    }
}

public class MTDecimalKeyboardSevenButton: MTDecimalKeyboardTextButton {
    override func theButtonText() -> String? {
        return "7"
    }
}

public class MTDecimalKeyboardEightButton: MTDecimalKeyboardTextButton {
    override func theButtonText() -> String? {
        return "8"
    }
}

public class MTDecimalKeyboardNineButton: MTDecimalKeyboardTextButton {
    override func theButtonText() -> String? {
        return "9"
    }
}

public class MTDecimalKeyboardDotButton: MTDecimalKeyboardTextButton {
    
    fileprivate var privateDotText = "."

    
    fileprivate func configureButtonTitle(_ title:String)
    {
        self.setTitle(title, for: .selected)
        self.setTitle(title, for: .highlighted)
        self.setTitle(title, for: UIControl.State())
    }
    
    override public func theButtonText() -> String? {
        return self.title(for: .normal)
    }
    
    public var title: String = "." {
        didSet {
            configureButtonTitle(title)
        }
    }
}

public class MTDecimalKeyboardHideButtonButton: MTDecimalKeyboardButton {
    override func theButtonActionType() -> ButtonActionType? {
        return ButtonActionType.hideKeyboard
    }
}


public class MTDecimalKeyboardBackspaceButton: MTDecimalKeyboardButton {
    override func theButtonActionType() -> ButtonActionType? {
        return ButtonActionType.backspace
    }
}

public class MTDecimalKeyboardReturnButtonButton: MTDecimalKeyboardButton {
    override func theButtonActionType() -> ButtonActionType? {
        return ButtonActionType.returnButton
    }
}
