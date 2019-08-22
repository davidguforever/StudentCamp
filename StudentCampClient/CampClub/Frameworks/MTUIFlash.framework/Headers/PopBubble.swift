//  PopBubble.swift
//
//  Copyright © 2016-2018年 Mantis Group. All rights reserved.
//


import UIKit
/// `PopBubble` 的bubble view  配置
public enum PopBubbleOption {
    /// 箭头大小
    case arrowSize(CGSize)
    /// 显示动画时间
    case animationIn(TimeInterval)
    /// 隐藏动画时间
    case animationOut(TimeInterval)
    /// 圆角
    case cornerRadius(CGFloat)
    /// 边距
    case sideEdge(CGFloat)
    /// 背景色
    case blackOverlayColor(UIColor)
    /// 背景透明度
    case overlayBlur(UIBlurEffect.Style)
    /// 方向 see `PopBubbleType`
    case type(PopBubbleType)
    /// 颜色
    case color(UIColor)
}

/// 弹出方向
public enum PopBubbleType: Int {
    /// 上
    case up
    /// 下
    case down
}

/// Pop a bubble view like Facebook app style
///
///         @IBAction func tappedRightBarButton(sender: UIBarButtonItem) {
///             let startPoint = CGPoint(x: view.frame.width - 60, y: 55)
///             let aView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 180))
///             let pop = PopBubble(options: nil, showHandler: nil, dismissHandler: nil)
///             pop.show(aView, point: startPoint)
///         }
open class PopBubble: UIView {
    // custom property
    open var arrowSize: CGSize = CGSize(width: 16.0, height: 10.0)
    open var animationIn: TimeInterval = 0.6
    open var animationOut: TimeInterval = 0.3
    open var popCornerRadius: CGFloat = 6.0
    open var sideEdge: CGFloat = 20.0
    open var popBubbleType: PopBubbleType = .down
    open var blackOverlayColor: UIColor = UIColor(white: 0.0, alpha: 0.2)
    open var overlayBlur: UIBlurEffect?
    open var popColor: UIColor = UIColor.white
    
    // custom closure
    fileprivate var didShowHandler: (() -> ())?
    fileprivate var didDismissHandler: (() -> ())?
    
    fileprivate var blackOverlay: UIControl = UIControl()
    fileprivate var containerView: UIView!
    fileprivate var contentView: UIView!
    fileprivate var contentViewFrame: CGRect!
    fileprivate var arrowShowPoint: CGPoint!
    
    /// init
    public init() {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.clear
    }
    
    
    /// Init
    ///
    /// - Parameters:
    ///   - showHandler: 成功显示后回调
    ///   - dismissHandler: 消失后回调
    public init(showHandler: (() -> ())?, dismissHandler: (() -> ())?) {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.clear
        didShowHandler = showHandler
        didDismissHandler = dismissHandler
    }
    
    /// Init
    ///
    /// - Parameters:
    ///   - options: 弹出框配置参数 `PopBubbleOption`
    ///   - showHandler: 成功显示后回调
    ///   - dismissHandler: 消失后回调
    public init(options: [PopBubbleOption]?, showHandler: (() -> ())? = nil, dismissHandler: (() -> ())? = nil) {
        super.init(frame: CGRect.zero)
        backgroundColor = UIColor.clear
        setOptions(options)
        didShowHandler = showHandler
        didDismissHandler = dismissHandler
    }

    fileprivate func setOptions(_ options: [PopBubbleOption]?) {
        if let options = options {
            for option in options {
                switch option {
                case let .arrowSize(value):
                    self.arrowSize = value
                case let .animationIn(value):
                    self.animationIn = value
                case let .animationOut(value):
                    self.animationOut = value
                case let .cornerRadius(value):
                    self.popCornerRadius = value
                case let .sideEdge(value):
                    self.sideEdge = value
                case let .blackOverlayColor(value):
                    self.blackOverlayColor = value
                case let .overlayBlur(style):
                    self.overlayBlur = UIBlurEffect(style: style)
                case let .type(value):
                    self.popBubbleType = value
                case let .color(value):
                    self.popColor = value
                }
            }
        }
    }
    
    /// init
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func create() {
        var frame = self.contentView.frame
        frame.origin.x = self.arrowShowPoint.x - frame.size.width * 0.5
        
        var sideEdge: CGFloat = 0.0
        if frame.size.width < self.containerView.frame.size.width {
            sideEdge = self.sideEdge
        }
        
        let outerSideEdge = frame.maxX - self.containerView.bounds.size.width
        if outerSideEdge > 0 {
            frame.origin.x -= (outerSideEdge + sideEdge)
        } else {
            if frame.minX < 0 {
                frame.origin.x += abs(frame.minX) + sideEdge
            }
        }
        self.frame = frame
        
        let arrowPoint = self.containerView.convert(self.arrowShowPoint, to: self)
        let anchorPoint: CGPoint
        switch self.popBubbleType {
        case .up:
            frame.origin.y = self.arrowShowPoint.y - frame.height - self.arrowSize.height
            anchorPoint = CGPoint(x: arrowPoint.x / frame.size.width, y: 1)
        case .down:
            frame.origin.y = self.arrowShowPoint.y
            anchorPoint = CGPoint(x: arrowPoint.x / frame.size.width, y: 0)
        }
        
        let lastAnchor = self.layer.anchorPoint
        self.layer.anchorPoint = anchorPoint
        let x = self.layer.position.x + (anchorPoint.x - lastAnchor.x) * self.layer.bounds.size.width
        let y = self.layer.position.y + (anchorPoint.y - lastAnchor.y) * self.layer.bounds.size.height
        self.layer.position = CGPoint(x: x, y: y)
        
        frame.size.height += self.arrowSize.height
        self.frame = frame
    }
    
    /// 显示
    ///
    /// - Parameters:
    ///   - contentView: 弹出内容
    ///   - fromView: from view
    open func show(_ contentView: UIView, fromView: UIView) {
        show(contentView, fromView: fromView, inView: UIApplication.shared.keyWindow!)
    }
    
    
    /// 显示
    ///
    /// - Parameters:
    ///   - contentView: 弹出内容
    ///   - fromView: from view
    ///   - inView: in view
    open func show(_ contentView: UIView, fromView: UIView, inView: UIView) {
        let point: CGPoint
        switch self.popBubbleType {
        case .up:
            point = inView.convert(CGPoint(x: fromView.frame.origin.x + (fromView.frame.size.width / 2), y: fromView.frame.origin.y), from: fromView.superview)
        case .down:
            point = inView.convert(CGPoint(x: fromView.frame.origin.x + (fromView.frame.size.width / 2), y: fromView.frame.origin.y + fromView.frame.size.height), from: fromView.superview)
        }
        show(contentView, point: point, inView: inView)
    }
    
    
    /// 显示
    ///
    /// - Parameters:
    ///   - contentView: 弹出内容界面
    ///   - point: 开始点
    open func show(_ contentView: UIView, point: CGPoint) {
        show(contentView, point: point, inView: UIApplication.shared.keyWindow!)
    }
    
    /// 显示
    ///
    /// - Parameters:
    ///   - contentView: 弹出内容界面
    ///   - point: 开始点
    ///   - inView: in view
    open func show(_ contentView: UIView, point: CGPoint, inView: UIView) {
        self.blackOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.blackOverlay.frame = inView.bounds
        
        if let overlayBlur = overlayBlur {
            let effectView = UIVisualEffectView(effect: overlayBlur)
            effectView.frame = blackOverlay.bounds
            effectView.isUserInteractionEnabled = false
            blackOverlay.addSubview(effectView)
        } else {
            blackOverlay.backgroundColor = self.blackOverlayColor
            blackOverlay.alpha = 0
        }
        
        inView.addSubview(blackOverlay)
        blackOverlay.addTarget(self, action: #selector(PopBubble.dismiss), for: .touchUpInside)
        
        containerView = inView
        self.contentView = contentView
        self.contentView.backgroundColor = UIColor.clear
        self.contentView.layer.cornerRadius = popCornerRadius
        self.contentView.layer.masksToBounds = true
        arrowShowPoint = point
        show()
    }
    
    fileprivate func show() {
        self.setNeedsDisplay()
        switch self.popBubbleType {
        case .up:
            contentView.frame.origin.y = 0.0
        case .down:
            contentView.frame.origin.y = self.arrowSize.height
        }
        addSubview(contentView)
        containerView.addSubview(self)
        
        create()
        self.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIView.animate(withDuration: self.animationIn, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 3, options: UIView.AnimationOptions(), animations: {
            self.transform = CGAffineTransform.identity
        }){ _ in
            self.didShowHandler?()
        }
        UIView.animate(withDuration: self.animationIn / 3, delay: 0, options: .curveLinear, animations: {
            self.blackOverlay.alpha = 1
        }, completion: { _ in
        })
    }
    
    
    /// 关闭 pop
    @objc open func dismiss() {
        if self.superview != nil {
            UIView.animate(withDuration: self.animationOut, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
                self.blackOverlay.alpha = 0
            }){ _ in
                self.contentView.removeFromSuperview()
                self.blackOverlay.removeFromSuperview()
                self.removeFromSuperview()
                self.didDismissHandler?()
            }
        }
    }
    
    /// override draw
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        let arrow = UIBezierPath()
        let color = popColor
        let arrowPoint = containerView.convert(arrowShowPoint, to: self)
        switch popBubbleType {
        case .up:
            arrow.move(to: CGPoint(x: arrowPoint.x, y: bounds.height))
            arrow.addLine(to: CGPoint(x: arrowPoint.x - self.arrowSize.width * 0.5, y: isCornerLeftArrow() ? self.arrowSize.height : bounds.height - self.arrowSize.height))
            
            arrow.addLine(to: CGPoint(x: self.popCornerRadius, y: bounds.height - self.arrowSize.height))
            arrow.addArc(
                withCenter: CGPoint(x: self.popCornerRadius, y: bounds.height - self.arrowSize.height - self.popCornerRadius),
                radius: self.popCornerRadius,
                startAngle: self.radians(90),
                endAngle: self.radians(180),
                clockwise: true)
            
            arrow.addLine(to: CGPoint(x: 0, y: self.popCornerRadius))
            arrow.addArc( withCenter: CGPoint( x: self.popCornerRadius, y: self.popCornerRadius), radius: self.popCornerRadius, startAngle: radians(180), endAngle: radians(270), clockwise: true)
            
            arrow.addLine(to: CGPoint(x: bounds.width - self.popCornerRadius, y: 0))
            arrow.addArc( withCenter: CGPoint( x: bounds.width - self.popCornerRadius, y: self.popCornerRadius ), radius: self.popCornerRadius, startAngle: radians(270), endAngle: radians(0), clockwise: true)
            
            arrow.addLine(to: CGPoint(x: bounds.width, y: bounds.height - self.arrowSize.height - self.popCornerRadius))
            arrow.addArc(
                withCenter: CGPoint( x: bounds.width - self.popCornerRadius, y: bounds.height - self.arrowSize.height - self.popCornerRadius ),
                radius: self.popCornerRadius,
                startAngle: radians(0),
                endAngle: radians(90),
                clockwise: true)
            
            arrow.addLine(to: CGPoint(x: arrowPoint.x + self.arrowSize.width * 0.5, y: isCornerRightArrow() ? self.arrowSize.height : bounds.height - self.arrowSize.height))
            
        case .down:
            arrow.move(to: CGPoint(x: arrowPoint.x, y: 0))
            arrow.addLine(
                to: CGPoint(x: arrowPoint.x + self.arrowSize.width * 0.5, y: isCornerRightArrow() ? self.arrowSize.height + bounds.height : self.arrowSize.height)
            )
            
            arrow.addLine(to: CGPoint(x: bounds.width - self.popCornerRadius, y: self.arrowSize.height))
            arrow.addArc(
                withCenter: CGPoint( x: bounds.width - self.popCornerRadius, y: self.arrowSize.height + self.popCornerRadius),
                radius: self.popCornerRadius,
                startAngle: radians(270.0),
                endAngle: radians(0),
                clockwise: true)
            
            arrow.addLine(to: CGPoint(x: bounds.width, y: bounds.height - self.popCornerRadius))
            arrow.addArc(
                withCenter: CGPoint( x: bounds.width - self.popCornerRadius, y: bounds.height - self.popCornerRadius),
                radius: self.popCornerRadius,
                startAngle: radians(0),
                endAngle: radians(90),
                clockwise: true)
            
            arrow.addLine(to: CGPoint(x: 0, y: bounds.height))
            arrow.addArc(
                withCenter: CGPoint( x: self.popCornerRadius, y: bounds.height - self.popCornerRadius ),
                radius: self.popCornerRadius,
                startAngle: radians(90),
                endAngle: radians(180),
                clockwise: true)
            
            arrow.addLine(to: CGPoint(x: 0, y: self.arrowSize.height + self.popCornerRadius))
            arrow.addArc(
                withCenter: CGPoint(x: self.popCornerRadius, y: self.arrowSize.height + self.popCornerRadius),
                radius: self.popCornerRadius,
                startAngle: radians(180),
                endAngle: radians(270),
                clockwise: true)
            
            arrow.addLine(to: CGPoint(x: arrowPoint.x - self.arrowSize.width * 0.5, y: isCornerLeftArrow() ? self.arrowSize.height + bounds.height : self.arrowSize.height))
        }
        
        color.setFill()
        arrow.fill()
    }
    
    fileprivate func isCornerLeftArrow() -> Bool {
        return self.arrowShowPoint.x == frame.origin.x
    }
    
    fileprivate func isCornerRightArrow() -> Bool {
        return self.arrowShowPoint.x == frame.origin.x + bounds.width
    }
    
    fileprivate func radians(_ degrees: CGFloat) -> CGFloat {
        return (CGFloat(Double.pi) * degrees / 180)
    }
}
