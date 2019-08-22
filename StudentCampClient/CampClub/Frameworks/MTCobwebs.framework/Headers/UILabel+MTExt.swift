//
//  UILabel+MTExt.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.

#if os(iOS) || os(tvOS)
    import UIKit
    
    // MARK: - Methods
    public extension UILabel {
        
        /// Initialize a UILabel with text
        public convenience init(text: String?) {
            self.init()
            self.text = text
        }
        
        /// 获取Label所需的高度 Required height for a label
        public var requiredHeight: CGFloat {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width, height: CGFloat.greatestFiniteMagnitude))
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            label.font = font
            label.text = text
            label.attributedText = attributedText
            label.sizeToFit()
            return label.frame.height
        }
        
    }
    
    
    public extension UILabel {
        
        ///初始化 默认字体： 17
        public convenience init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat) {
            self.init(x: x, y: y, w: w, h: h, fontSize: 17)
        }
        
        ///初始化 左对齐 可互动
        public convenience init(x: CGFloat, y: CGFloat, w: CGFloat, h: CGFloat, fontSize: CGFloat) {
            self.init(frame: CGRect(x: x, y: y, width: w, height: h))
            //font = UIFont.HelveticaNeue(type: FontType.None, size: fontSize)
            backgroundColor = UIColor.clear
            clipsToBounds = true
            textAlignment = NSTextAlignment.left
            isUserInteractionEnabled = true
            numberOfLines = 1
        }
        
        /// 获取预估大小
        ///
        /// - Parameters:
        ///   - width: 宽
        ///   - height: 高
        /// - Returns: CGSize
        public func getEstimatedSize(_ width: CGFloat = CGFloat.greatestFiniteMagnitude, height: CGFloat = CGFloat.greatestFiniteMagnitude) -> CGSize {
            return sizeThatFits(CGSize(width: width, height: height))
        }

        
        /// 获取预估高度
        ///
        /// - Returns: 高度
        public func getEstimatedHeight() -> CGFloat {
            return sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)).height
        }

        
        /// 获取预估宽度
        ///
        /// - Returns: 宽度
        public func getEstimatedWidth() -> CGFloat {
            return sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: height)).width
        }

        
        /// 适应高度
        public func fitHeight() {
            self.height = getEstimatedHeight()
        }

        
        /// 适应宽度
        public func fitWidth() {
            self.width = getEstimatedWidth()
        }
        
        /// 适应宽度
        ///
        /// - Parameter margin: margin
        public func fitWidth(_ margin: CGFloat = 0) {
            self.width = getEstimatedWidth() + margin
        }
        
        /// 适应大小
        public func fitSize() {
            self.fitWidth()
            self.fitHeight()
            sizeToFit()
        }
        

        /// 设置文本
        ///
        /// - Parameters:
        ///   - text: 文本
        ///   - animated: 是否动画显示
        ///   - duration: 动画时间
        public func setText(_ text: String?, animated: Bool, duration: TimeInterval?) {
            if animated {
                UIView.transition(with: self, duration: duration ?? 0.3, options: .transitionCrossDissolve, animations: { () -> Void in
                    self.text = text
                }, completion: nil)
            } else {
                self.text = text
            }
            
        }
        
        
    }
    extension UILabel {
        
        /// 设置行间距
        ///
        /// - Parameters:
        ///   - lineSpacing: 行间距 default： 0.0
        ///   - lineHeightMultiple: 行高倍因子 default： 0.0
        func setLineSpacing(_ lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {
            
            guard let labelText = self.text else { return }
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineSpacing
            paragraphStyle.lineHeightMultiple = lineHeightMultiple
            
            let attributedString:NSMutableAttributedString
            if let labelattributedText = self.attributedText {
                attributedString = NSMutableAttributedString(attributedString: labelattributedText)
            } else {
                attributedString = NSMutableAttributedString(string: labelText)
            }
            
            // Line spacing attribute
            attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            
            self.attributedText = attributedString
        }
    }

#endif


