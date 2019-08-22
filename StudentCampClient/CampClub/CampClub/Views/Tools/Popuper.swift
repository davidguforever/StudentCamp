//
//  Popuper.swift
//  TaodaiAgents
//
//  Created by Luochun on 2018/4/25.
//  Copyright © 2018年 Mantis Group. All rights reserved.
//

import Foundation
import UIKit


/// 弹出框按钮样式
enum PupoperStyle {
    case oneCancel  //一个按钮
    case twoAction  //两个主按钮
    case leftCancelRightAction //一个取消按钮， 一个主按钮
}

class Pupoper {
    static let presenter: Presentr = {
        let width = ModalSize.sideMargin(value: 33)
        let height = ModalSize.custom(size:160 )
        
        let customType = PresentationType.custom(width: width, height: height, center: .center)
        
        let presenter = Presentr(presentationType: customType)
        presenter.transitionType = TransitionType.coverVertical
        presenter.backgroundOpacity = 0.5
        presenter.dismissOnSwipe = true
        presenter.dismissAnimated = false
        presenter.dismissTransitionType = nil
        presenter.roundCorners = true
        presenter.cornerRadius = 5
        
        return presenter
    }()

}

extension UIViewController {
    
    /// 弹出框
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - body: 内容
    ///   - actions: 按钮文本
    ///   - style: 按钮样式
    ///   - competion: handle
    func showPopuper(_ title: String, body: String, actions: String...,
        style: PupoperStyle, alertHeight: Float? = nil, textAlignment: NSTextAlignment = .center, competion: @escaping (_ index: Int) -> ()) {
        
        let font = UIFont.systemFont(ofSize: 14)
        let buttonFont = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        let alertController = AlertViewController(title: title, body: body, titleFont: UIFont.systemFont(ofSize: 16, weight: .bold), bodyFont: font, buttonFont: buttonFont)
        alertController.dismissAnimated = false
        //alertController.view.backgroundColor = .red
        alertController.textAlignment = textAlignment
        
        let presenter = Pupoper.presenter
        
        switch style {
        case .oneCancel:
            
            let cancelAction = AlertAction(title: actions[0], style:  .custom(textColor: MTColor.main), handler: {
                competion(0)
            })
            
            alertController.addAction(cancelAction)
        case .twoAction:
            presenter.dismissOnSwipe = false
            let leftAction = AlertAction(title: actions[0], style:  .custom(textColor: MTColor.main), handler: {
                competion(0)
            })
            alertController.addAction(leftAction)
            let rightAction = AlertAction(title: actions[1], style:  .custom(textColor: MTColor.main), handler: {
                competion(1)
            })
            alertController.addAction(rightAction)
        case .leftCancelRightAction:
            presenter.dismissOnSwipe = false
            let cancelAction = AlertAction(title: actions[0], style:  .custom(textColor: MTColor.des666), handler: {
                competion(0)
            })
            alertController.addAction(cancelAction)
            let rightAction = AlertAction(title: actions[1], style:  .custom(textColor: MTColor.main), handler: {
                competion(1)
            })
            alertController.addAction(rightAction)
        }
        
        
        let width = ModalSize.sideMargin(value: 33)
        let height = ModalSize.custom(size: alertHeight ?? 160 )
        let customType = PresentationType.custom(width: width, height: height, center: .center)
        presenter.presentationType = customType
        
        customPresentViewController(presenter, viewController: alertController, animated: true, completion: nil)
    }
}
