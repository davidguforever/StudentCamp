//
//  EfficientCorner.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.

import Foundation
import UIKit

private func roundByUnit(_ num: Double, _ unit: inout Double) -> Double {
	let remain = modf(num, &unit)
	if (remain > unit / 2.0) {
		return ceilByUnit(num, &unit)
	} else {
		return floorByUnit(num, &unit)
	}
}

private func ceilByUnit(_ num: Double, _ unit: inout Double) -> Double {
	return num - modf(num, &unit) + unit
}

private func floorByUnit(_ num: Double, _ unit: inout Double) -> Double {
	return num - modf(num, &unit)
}

private func pixel(_ num: Double) -> Double {
	var unit: Double
	switch Int(UIScreen.main.scale) {
	case 1: unit = 1.0 / 1.0
	case 2: unit = 1.0 / 2.0
	case 3: unit = 1.0 / 3.0
	default: unit = 0.0
	}
	return roundByUnit(num, &unit)
}


public extension UIView {
    // MARK: - 高效率添加圆角
    

    ///  给View 重绘圆角
    ///
    /// - Parameter radius: 圆角
	public func mt_addCorner(_ radius: CGFloat) {
		self.mt_addCorner( radius, borderWidth: 1, backgroundColor: UIColor.clear, borderColor: UIColor.black)
	}

    /// 给View 重绘圆角 已经添加到View
    ///    self.insertSubview(imageView)
    ///
    /// - Parameters:
    ///   - radius: 圆角
    ///   - borderWidth: 边线宽
    ///   - backgroundColor: 背景颜色
    ///   - borderColor: 边线颜色
	public func mt_addCorner(_ radius: CGFloat, borderWidth: CGFloat, backgroundColor: UIColor, borderColor: UIColor) {
			let imageView = UIImageView(image: mt_drawRectWithRoundedCorner(radius,
				borderWidth: borderWidth,
				backgroundColor: backgroundColor,
				borderColor: borderColor))
			self.insertSubview(imageView, at: 0)
	}
    
    
    /// 重绘圆角 但没有添加到View上
    ///
    /// - Parameters:
    ///   - radius: 圆角
    ///   - borderWidth: 边线宽
    ///   - backgroundColor: 背景颜色
    ///   - borderColor: 边线颜色
    /// - Returns: 结果图片
	public func mt_drawRectWithRoundedCorner(_ radius: CGFloat, borderWidth: CGFloat, backgroundColor: UIColor, borderColor: UIColor) -> UIImage {
        let sizeToFit = CGSize(width: pixel(Double(self.bounds.size.width)), height: Double(self.bounds.size.height))
        let halfBorderWidth = CGFloat(borderWidth / 2.0)

        
        UIGraphicsBeginImageContextWithOptions(sizeToFit, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()

        context?.setLineWidth(borderWidth)
        context?.setStrokeColor(borderColor.cgColor)
        context?.setFillColor(backgroundColor.cgColor)

        let width = sizeToFit.width, height = sizeToFit.height
        context?.move(to: CGPoint(x: width - halfBorderWidth, y: radius + halfBorderWidth)) // 开始坐标右边开始
    
        context?.addArc(tangent1End: CGPoint(x: width - halfBorderWidth, y: height - halfBorderWidth), tangent2End: CGPoint(x: width - radius - halfBorderWidth, y: height - halfBorderWidth), radius: radius)// 右下角角度
        context?.addArc(tangent1End: CGPoint(x: halfBorderWidth, y:  height - halfBorderWidth), tangent2End: CGPoint(x:halfBorderWidth,  y: height - radius - halfBorderWidth), radius: radius)// 左下角角度
        context?.addArc(tangent1End: CGPoint(x:  halfBorderWidth, y:  halfBorderWidth),  tangent2End: CGPoint(x:width - halfBorderWidth, y:  halfBorderWidth),  radius: radius) // 左上角
        context?.addArc(tangent1End: CGPoint(x: width - halfBorderWidth, y:  halfBorderWidth), tangent2End: CGPoint(x:width - halfBorderWidth, y:  radius + halfBorderWidth),  radius: radius) // 右上角

        UIGraphicsGetCurrentContext()?.drawPath(using: .fillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return output!
	}
}


public extension UIImage {

    /// 绘制圆角图片
	public func mt_drawRectWithRoundedCorner(_ radius: CGFloat, _ sizetoFit: CGSize) -> UIImage {
		let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: sizetoFit)

		UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
		UIGraphicsGetCurrentContext()?.addPath(UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.allCorners,
				cornerRadii: CGSize(width: radius, height: radius)).cgPath)
		UIGraphicsGetCurrentContext()?.clip()

		self.draw(in: rect)
		UIGraphicsGetCurrentContext()?.drawPath(using: .fillStroke)
		let output = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext();

		return output!
	}
}
