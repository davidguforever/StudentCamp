//
//  MTCircularCheckBox.swift
//
//  Copyright © 2016-2018年 Mantis Group. All rights reserved.
//

import UIKit

/// 选择框的配置明细
public struct MTCircularCheckBoxData {
    //选中状态
    var checked: Bool = false
    //外圈颜色
    var borderColor: UIColor = .black
    //内圈颜色
    var circleColor: UIColor = .black
    //外圈半径
    var borderRadius: CGFloat = 12
    //内圈半径
    var circleRadius: CGFloat = 6
    //显示文本
    var labelText: String = ""
    //文本字体
    var labelFont: UIFont = .systemFont(ofSize: 15)
    //文本颜色
    var labelColor: UIColor = .black
    
}


/// 圆角选择框
open class MTCircularCheckBox: UIControl {
    
    fileprivate var data: MTCircularCheckBoxData = MTCircularCheckBoxData()
    
    /// 是否选中  setter: 动画处理
    var checked: Bool = false {
        
        didSet {
            let value: CGFloat = checked ? 1.0 : 0
            let animation: CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
            animation.toValue = value
            animation.duration = 0.3
            circle.add(animation, forKey: "scale")
            
            circle.transform = CATransform3DMakeScale(value, value, 0)
        }
        
    }
    
    fileprivate var checkBox: UIView = UIView()
    
    fileprivate var border: CAShapeLayer = CAShapeLayer()
    fileprivate var circle: CAShapeLayer = CAShapeLayer()
    
    fileprivate var titleLabel: UILabel = UILabel()
    fileprivate var tapButton: UIButton = UIButton(type: .custom)
    
    /// init with frame
    required public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    /// init
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    /// 加载选择框
    ///
    /// - Parameters:
    ///   - frame: frame
    ///   - data: 数据明细
    /// - Returns: `MTCircularCheckBox`
    public static func loadWith(_ frame: CGRect, data:MTCircularCheckBoxData) -> MTCircularCheckBox {
        
        let checkBox = MTCircularCheckBox()
        checkBox.frame  = frame
        checkBox.data = data
        
        checkBox.setup()
        
        checkBox.checked = data.checked
        return checkBox
    }
    
    fileprivate func setup() {
        
        createCheckBox()
        
    }
    
    
    fileprivate func createCheckBox() {
        checkBox.frame = CGRect(x: 0, y: 0, width: data.borderRadius, height: data.borderRadius)
        checkBox.isUserInteractionEnabled = true
        
        let borderRect = CGRect(x: 0, y: 0, width: data.borderRadius, height: data.borderRadius)
        let borderPath: UIBezierPath = UIBezierPath(ovalIn: borderRect)
        
        border.path = borderPath.cgPath
        border.frame = borderRect
        border.lineWidth = 1
        border.strokeColor = data.borderColor.cgColor
        border.fillColor = UIColor.clear.cgColor
        checkBox.layer.addSublayer(border)
        
        
        let circleRect = CGRect(x: (border.frame.size.width - data.circleRadius) / 4, y: (border.frame.size.height - data.circleRadius) / 4, width: data.circleRadius, height: data.circleRadius)
        let circlePath: UIBezierPath = UIBezierPath(ovalIn: circleRect)
        
        circle.path = circlePath.cgPath
        circle.frame = circleRect
        circle.lineWidth = 0
        circle.fillColor = data.circleColor.cgColor
        checkBox.layer.addSublayer(circle)
        
        checkBox.center = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(toggle))
        checkBox.addGestureRecognizer(tapGestureRecognizer)
        
        addSubview(checkBox)
        
        
        if data.labelText.count > 0 {
            checkBox.center = CGPoint(x: checkBox.frame.size.width/2 + 5, y: frame.size.height/2)
            createLabel()
        }
    }
    
    /// 切换
    @objc func toggle() {
        self.checked = !self.checked
        sendActions(for: .valueChanged)
    }
    
    fileprivate func createLabel() {
        let labelRect = data.labelText.heightWithConstrainedWidth(self.frame.size.width - checkBox.frame.size.width - 10, font: data.labelFont)
        titleLabel.frame = CGRect(x: checkBox.frame.maxX + 5, y: (frame.size.height - labelRect.height )/2, width: labelRect.width + 10, height: labelRect.height)
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 1
        titleLabel.textColor = data.labelColor
        titleLabel.text = data.labelText
        addSubview(titleLabel)
    }
    
    /// end tracking
    open override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        toggle()
        super.endTracking(touch, with: event)
    }
    
}

extension String {
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGRect {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox
    }
}





