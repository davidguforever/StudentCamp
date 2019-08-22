//
//  TDHeaderAnimator.swift
//  TaodaiAgents
//
//  Created by Luochun on 2018/5/13.
//  Copyright © 2018年 Mantis Group. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit


open class MTHeaderAnimator: UIView, ESRefreshProtocol, ESRefreshAnimatorProtocol, ESRefreshImpactProtocol {
    open var pullToRefreshDescription = NSLocalizedString("Pull to refresh", comment: "") {
        didSet {
            if pullToRefreshDescription != oldValue {
                titleLabel.text = pullToRefreshDescription;
            }
        }
    }
    open var releaseToRefreshDescription = NSLocalizedString("Release to refresh", comment: "")
    open var loadingDescription = NSLocalizedString("Loading...", comment: "")
    
    open var view: UIView { return self }
    open var insets: UIEdgeInsets = UIEdgeInsets.zero
    open var trigger: CGFloat = 60.0
    open var executeIncremental: CGFloat = 60.0
    open var state: ESRefreshViewState = .pullToRefresh

    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor(red:0.40, green:0.40, blue:0.40, alpha:1.00) //UIColor.init(white: 0.625, alpha: 1.0)
        label.textAlignment = .left
        return label
    }()
    
    fileprivate let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView.init(style: .gray)
        indicatorView.isHidden = true
        return indicatorView
    }()
    open var color: UIColor = UIColor(red:0.40, green:0.40, blue:0.40, alpha:1.00) {
        didSet {
            arrowLayer.strokeColor = color.cgColor
            circleFrontLayer.strokeColor = color.cgColor
            indicatorView.color = color
        }
    }
    private let circleWidth: CGFloat = 22
    fileprivate var arrowLayer = CAShapeLayer()
    fileprivate var circleFrontLayer = CAShapeLayer()
    fileprivate var circleBackLayer = CAShapeLayer()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.text = pullToRefreshDescription
        
        self.addSubview(titleLabel)
        self.addSubview(indicatorView)
        
        initLayer(frame: frame)
    }
    
    public func initLayer(frame: CGRect) {
        
        circleBackLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: circleWidth, height: circleWidth)).cgPath
        circleBackLayer.fillColor = nil
        circleBackLayer.strokeColor = UIColor.clear.cgColor
        circleBackLayer.lineWidth = 1.5
        
        circleFrontLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: circleWidth, height: circleWidth)).cgPath
        circleFrontLayer.fillColor = nil
        circleFrontLayer.strokeColor = color.cgColor
        circleFrontLayer.lineWidth = 1.5
        circleFrontLayer.lineCap = CAShapeLayerLineCap.round
        circleFrontLayer.strokeStart = 0.02
        circleFrontLayer.strokeEnd = 0
        circleFrontLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: -CGFloat.pi/2))
        
        
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x: circleWidth / 2 - 4, y: circleWidth / 2 ))
        arrowPath.addLine(to: CGPoint(x: circleWidth / 2, y: circleWidth / 2 + 5))
        arrowPath.addLine(to: CGPoint(x: circleWidth / 2 + 4, y: circleWidth / 2))
        
        arrowPath.move(to: CGPoint(x: circleWidth / 2, y: circleWidth / 2 + 5))
        arrowPath.addLine(to: CGPoint(x: circleWidth / 2, y: circleWidth / 2 - 5))
        
        arrowLayer.path = arrowPath.cgPath
        arrowLayer.fillColor = nil
        arrowLayer.strokeColor = color.cgColor
        arrowLayer.lineWidth = 1.5
        arrowLayer.lineJoin = CAShapeLayerLineJoin.round
        arrowLayer.lineCap = CAShapeLayerLineCap.butt
        
        circleBackLayer.frame = self.bounds
        circleFrontLayer.frame = self.bounds
        arrowLayer.frame = CGRect(x: 0, y: 0, width: circleWidth, height: circleWidth)
        
        self.layer.addSublayer(circleBackLayer)
        self.layer.addSublayer(circleFrontLayer)
        self.layer.addSublayer(arrowLayer)
        
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func refreshAnimationBegin(view: ESRefreshComponent) {
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        
        titleLabel.text = loadingDescription
        
       circleFrontLayer.strokeEnd = 0
       arrowLayer.transform = CATransform3DIdentity
       arrowLayer.isHidden = true
    }
    
    open func refreshAnimationEnd(view: ESRefreshComponent) {
        indicatorView.stopAnimating()
        indicatorView.isHidden = true
        
        titleLabel.text = pullToRefreshDescription
        
        circleFrontLayer.isHidden = false
        arrowLayer.isHidden = false
    }
    
    open func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {
        // Do nothing
        updateForProgress(progress)
    }
    
    open func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
        guard self.state != state else {
            return
        }
        self.state = state
        
        switch state {
        case .refreshing, .autoRefreshing:
            titleLabel.text = loadingDescription
            self.setNeedsLayout()
            break
        case .releaseToRefresh:
            titleLabel.text = releaseToRefreshDescription
            self.setNeedsLayout()
            self.impact()
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions(), animations: {
                [weak self] in
                //self?.imageView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat.pi)
                self?.arrowLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: 0.000001 - CGFloat.pi))
            }) { (animated) in }
            break
        case .pullToRefresh:
            titleLabel.text = pullToRefreshDescription
            self.setNeedsLayout()
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions(), animations: {
                [weak self] in
                //self?.imageView.transform = CGAffineTransform.identity
                self?.arrowLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform.identity)

            }) { (animated) in }
            break
        default:
            break
        }
    }
    func updateForProgress(_ progress: CGFloat) {
        print(progress)
        var cur = progress - 0.66
        cur = cur / 0.34
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        circleFrontLayer.strokeEnd = min(cur, 0.98)
        //arrowLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: CGFloat.pi * 2 * progress * progress))
        CATransaction.commit()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        let s = self.bounds.size
        let w = s.width
        let h = s.height
        
        UIView.performWithoutAnimation {
            titleLabel.sizeToFit()
            titleLabel.center = CGPoint.init(x: w / 2.0, y: h / 2.0)
            indicatorView.center = CGPoint.init(x: titleLabel.frame.origin.x - 16.0, y: h / 2.0)
            //imageView.frame = CGRect.init(x: titleLabel.frame.origin.x - 28.0, y: (h - 18.0) / 2.0, width: 18.0, height: 18.0)
            
            let circleFrame = CGRect(x: titleLabel.frame.origin.x - 25.0, y: h / 2.0 - 12, width: circleWidth, height: circleWidth)
            circleBackLayer.frame = circleFrame
            circleFrontLayer.frame = circleFrame
            arrowLayer.frame = circleFrame
            
            indicatorView.center = CGPoint.init(x: circleFrame.size.width / 2, y: h / 2.0)
        }
    }
    
}
