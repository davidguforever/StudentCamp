//
//  BlockPanGestureRecognizer.swift
//
// Copyright (c) 2016-2018年 Mantis Group. All rights reserved.

import UIKit

/// 手势绑定事件
open class BlockPan: UIPanGestureRecognizer {
    
    fileprivate var panAction: ((UIPanGestureRecognizer) -> Void)?
    
    /// Init
    public override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
    
    /// Init
    public convenience init (action: ((UIPanGestureRecognizer) -> Void)?) {
        self.init()
        self.panAction = action
        self.addTarget(self, action: #selector(BlockPan.didPan(_:)))
    }
    
    /// didPan
    @objc open func didPan (_ pan: UIPanGestureRecognizer) {
        panAction? (pan)
    }
}

/// 点击绑定事件
open class BlockTap: UITapGestureRecognizer {
    
    fileprivate var tapAction: ((UITapGestureRecognizer) -> Void)?
    
    /// Init
    public override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
    
    /// Init
    public convenience init ( tapCount: Int, fingerCount: Int, action: ((UITapGestureRecognizer) -> Void)?) {
            self.init()
            self.numberOfTapsRequired = tapCount
            self.numberOfTouchesRequired = fingerCount
            self.tapAction = action
            self.addTarget(self, action: #selector(BlockTap.didTap(_:)))
    }
    
    /// didTap
    @objc open func didTap (_ tap: UITapGestureRecognizer) {
        tapAction? (tap)
    }
    
}

/// 捏合手势事件
open class BlockPinch: UIPinchGestureRecognizer {
    
    fileprivate var pinchAction: ((UIPinchGestureRecognizer) -> Void)?
    
    /// Init
    public override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
    
    /// Init
    public convenience init (action: ((UIPinchGestureRecognizer) -> Void)?) {
        self.init()
        self.pinchAction = action
        self.addTarget(self, action: #selector(BlockPinch.didPinch(_:)))
    }
    
    /// didPinch
    @objc open func didPinch (_ pinch: UIPinchGestureRecognizer) {
        pinchAction? (pinch)
    }
    
}

/// 长按手势事件
open class BlockLongPress: UILongPressGestureRecognizer {
    
    fileprivate var longPressAction: ((UILongPressGestureRecognizer) -> Void)?
    
    /// Init
    public override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
    
    /// Init
    public convenience init (action: ((UILongPressGestureRecognizer) -> Void)?) {
        self.init()
        longPressAction = action
        addTarget(self, action: #selector(BlockLongPress.didLongPressed(_:)))
    }
    
    /// didLongPressed
    @objc open func didLongPressed (_ longPress: UILongPressGestureRecognizer) {
        longPressAction? (longPress)
    }
}

/// 轻扫手势事件
open class BlockSwipe: UISwipeGestureRecognizer {
    
    fileprivate var swipeAction: ((UISwipeGestureRecognizer) -> Void)?
    /// Init
    public override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
    }
    /// Init
    public convenience init (direction: UISwipeGestureRecognizer.Direction,
        fingerCount: Int,
        action: ((UISwipeGestureRecognizer) -> Void)?) {
            self.init()
            self.direction = direction
            numberOfTouchesRequired = fingerCount
            swipeAction = action
            addTarget(self, action: #selector(BlockSwipe.didSwipe(_:)))
    }
    /// didSwipe
    @objc open func didSwipe (_ swipe: UISwipeGestureRecognizer) {
        swipeAction? (swipe)
    }
}

