//
//  UIScrollView+Refresh.swift
//  Copyright © 2017年 Maintis Group. All rights reserved.
//

import Foundation
import UIKit

public extension UIScrollView {
    
    
    /// 添加刷新和加载更多
    ///   注意remove： `func es.removeRefreshHeader()`  `func es.removeRefreshFooter()`
    /// - Parameters:
    ///   - identifier: 唯一标识
    ///   - autoRefresh: 自动刷新
    ///   - headerRefresh: 下拉刷新事件
    ///   - footerLoader: 上拉加载更多事件
    func addRefresh(_ identifier: String, autoRefresh: Bool = true, headerRefresh:@escaping () ->(), footerLoader: (() -> ())? = nil) {
        //let header = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
        let header = MTHeaderAnimator.init(frame: CGRect.zero)
        self.es.addPullToRefresh(animator: header) {
            headerRefresh()
        }
        if let footerBlock = footerLoader {
            let footer = ESRefreshFooterAnimator.init(frame: CGRect.zero)
            self.es.addInfiniteScrolling(animator: footer) {
                footerBlock()
            }
        }
        
        self.refreshIdentifier = identifier
        self.expiredTimeInterval = 30.0
        if autoRefresh {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.es.autoPullToRefresh()
            }
        }
    }
}
