//  MTSMSSendCodeButton.swift
//  
//  Copyright © 2016-2018年 Mantis Group. All rights reserved.
//

import UIKit


/// 短信发送按钮
@IBDesignable
public class MTSMSSendCodeButton: UIButton {
    
    /// 倒计时秒数
    @IBInspectable public var duration: Int = 60 {
        didSet {
            self.currentCount = duration
        }
    }
    /// 当前计时
    fileprivate var currentCount: Int = 0
    
    /// 不可点击状态背景颜色
    @IBInspectable public var disableColor: UIColor = .lightGray
    
    fileprivate weak var timer: Timer!
    
    fileprivate var enableColor :UIColor?       /// 记录下正常状态下的背景颜色
    deinit {
        if timer != nil {
            timer.invalidate()
        }
    }
    
    /// 恢复默认状态
    public func reset()  {
        currentCount = duration
        timer.invalidate()
        timer = nil
        setTitle("获取验证码", for: .normal)
        isEnabled = true
        self.backgroundColor = enableColor
    }
    
    /// 开始倒计时
    public func countdown() {
        enableColor = self.backgroundColor
        
        if (timer != nil) {
            timer.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(MTSMSSendCodeButton.countDown), userInfo: nil, repeats: true)
        timer.fire()
        
        self.isEnabled = false
        self.backgroundColor = disableColor
    }
    
    @objc fileprivate func countDown() {
        if currentCount <= 0  {
            reset()
        } else {
            setTitle("\(currentCount)s", for: .normal)
            //self.isEnabled = false
            currentCount = currentCount - 1
        }
    }

}
