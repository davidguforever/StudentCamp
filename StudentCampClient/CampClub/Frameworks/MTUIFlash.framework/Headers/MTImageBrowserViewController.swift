//
//  Created by Luochun
//  Copyright © 2016-2018年 Mantis Group. All rights reserved.
//

import UIKit


/// 图片信息
public struct MTImageInfo {
    /// 图片显示方式
    public enum ImageMode : Int {
        /// fit
        case aspectFit  = 1
        /// fill
        case aspectFill = 2
    }
    
    /// image
    public let image     : UIImage
    /// image mode
    public let imageMode : ImageMode
    /// imageHD
    public var imageHD   : URL?
    
    /// content mode
    public var contentMode : UIView.ContentMode {
        return UIView.ContentMode(rawValue: imageMode.rawValue)!
    }
    /// init with image and image mode
    public init(image: UIImage, imageMode: ImageMode) {
        self.image     = image
        self.imageMode = imageMode
    }
    /// init with image and image mode  imageUrl
    public init(image: UIImage, imageMode: ImageMode, imageHD: URL?) {
        self.init(image: image, imageMode: imageMode)
        self.imageHD = imageHD
    }
    
    func calculateRect(_ size: CGSize) -> CGRect {
        
        let widthRatio  = size.width  / image.size.width
        let heightRatio = size.height / image.size.height
        
        switch imageMode {
            
        case .aspectFit:
            
            return CGRect(origin: CGPoint.zero, size: size)
            
        case .aspectFill:
            
            return CGRect(
                x      : 0,
                y      : 0,
                width  : image.size.width  * max(widthRatio, heightRatio),
                height : image.size.height * max(widthRatio, heightRatio)
            )
            
        }
    }
    
    func calculateMaximumZoomScale(_ size: CGSize) -> CGFloat {
        return max(2, max(
            image.size.width  / size.width,
            image.size.height / size.height
        ))
    }
    
}


/// 图片浏览器的动画信息 see `MTImageBrowserViewController`
open class MTTransitionInfo {
    
    /// 时间 0.35
    open var duration: TimeInterval = 0.35
    /// 支持手势
    open var canSwipe: Bool           = true

    /// init from view
    public init(fromView: UIView) {
        self.fromView = fromView
    }
    
    weak var fromView : UIView?
    
    fileprivate var convertedRect : CGRect?
    
}

/// 图片浏览器  //https://github.com/wxxsw/GSImageViewerController
open class MTImageBrowserViewController: UIViewController {
    
    public let imageInfo      : MTImageInfo
    open var transitionInfo : MTTransitionInfo?
    
    fileprivate let imageView  = UIImageView()
    fileprivate let scrollView = UIScrollView()
    
    fileprivate lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        return URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
    }()
    
    // MARK: Initialization
    
    /// init with `MTImageInfo`
    public init(imageInfo: MTImageInfo) {
        self.imageInfo = imageInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    
    /// 初始化图片浏览器
    ///
    /// - Parameters:
    ///   - imageInfo: 图片信息
    ///   - transitionInfo: 动画信息
    ///
    ///         let imageInfo   = MTImageInfo(image: UIImage(named: "1.jpg")!, imageMode: .aspectFit)
    ///         let transitionInfo = MTTransitionInfo(fromView: sender)
    ///         let imageViewer = MTImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
    ///         present(imageViewer, animated: true, completion: nil)
    ///
    public convenience init(imageInfo: MTImageInfo, transitionInfo: MTTransitionInfo) {
        self.init(imageInfo: imageInfo)
        self.transitionInfo = transitionInfo
        if let fromView = transitionInfo.fromView, let referenceView = fromView.superview {
            self.transitioningDelegate = self
            self.modalPresentationStyle = .custom
            transitionInfo.convertedRect = referenceView.convert(fromView.frame, to: nil)
        }
    }
    
    /// 初始化图片浏览器
    public convenience init(image: UIImage, imageMode: UIView.ContentMode, imageHD: URL?, fromView: UIView?) {
        let imageInfo = MTImageInfo(image: image, imageMode: MTImageInfo.ImageMode(rawValue: imageMode.rawValue)!, imageHD: imageHD)
        if let fromView = fromView {
            self.init(imageInfo: imageInfo, transitionInfo: MTTransitionInfo(fromView: fromView))
        } else {
            self.init(imageInfo: imageInfo)
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Override
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupScrollView()
        setupImageView()
        setupGesture()
        setupImageHD()
        
        edgesForExtendedLayout = UIRectEdge()
        automaticallyAdjustsScrollViewInsets = false
    }
    
    /// viewWillLayoutSubviews
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        imageView.frame = imageInfo.calculateRect(view.bounds.size)
        
        scrollView.frame = view.bounds
        scrollView.contentSize = imageView.bounds.size
        scrollView.maximumZoomScale = imageInfo.calculateMaximumZoomScale(scrollView.bounds.size)
    }
    
    // MARK: Setups
    
    fileprivate func setupView() {
        view.backgroundColor = UIColor.black
    }
    
    fileprivate func setupScrollView() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
    }
    
    fileprivate func setupImageView() {
        imageView.image = imageInfo.image
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
    }
    
    fileprivate func setupGesture() {
        let single = UITapGestureRecognizer(target: self, action: #selector(singleTap))
        let double = UITapGestureRecognizer(target: self, action: #selector(doubleTap(_:)))
        double.numberOfTapsRequired = 2
        single.require(toFail: double)
        scrollView.addGestureRecognizer(single)
        scrollView.addGestureRecognizer(double)
        
        if transitionInfo?.canSwipe == true {
            let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
            pan.delegate = self
            scrollView.addGestureRecognizer(pan)
        }
    }
    
    fileprivate func setupImageHD() {
        guard let imageHD = imageInfo.imageHD else { return }
        
        let request = URLRequest(url: imageHD, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15)
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            self.imageView.image = image
            self.view.layoutIfNeeded()
        })
        task.resume()
    }
    
    // MARK: Gesture
    
    @objc fileprivate func singleTap() {
        if navigationController == nil || (presentingViewController != nil && navigationController!.viewControllers.count <= 1) {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc fileprivate func doubleTap(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: scrollView)
        
        if scrollView.zoomScale == 1.0 {
            scrollView.zoom(to: CGRect(x: point.x-40, y: point.y-40, width: 80, height: 80), animated: true)
        } else {
            scrollView.setZoomScale(1.0, animated: true)
        }
    }
    
    fileprivate var panViewOrigin : CGPoint?
    fileprivate var panViewAlpha  : CGFloat = 1
    
    @objc fileprivate func pan(_ gesture: UIPanGestureRecognizer) {
        
        func getProgress() -> CGFloat {
            let origin = panViewOrigin!
            let changeX = abs(scrollView.center.x - origin.x)
            let changeY = abs(scrollView.center.y - origin.y)
            let progressX = changeX / view.bounds.width
            let progressY = changeY / view.bounds.height
            return max(progressX, progressY)
        }
        
        func getChanged() -> CGPoint {
            let origin = scrollView.center
            let change = gesture.translation(in: view)
            return CGPoint(x: origin.x + change.x, y: origin.y + change.y)
        }
        
        switch gesture.state {
            
        case .began:
            
            panViewOrigin = scrollView.center
            
        case .changed:
            
            scrollView.center = getChanged()
            panViewAlpha = 1 - getProgress()
            view.backgroundColor = UIColor(white: 0.0, alpha: panViewAlpha)
            gesture.setTranslation(CGPoint.zero, in: nil)
            
        case .ended:
            
            if getProgress() > 0.25 {
                dismiss(animated: true, completion: nil)
            } else {
                fallthrough
            }
            
        default:
            
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.scrollView.center = self.panViewOrigin!
                            self.view.backgroundColor = UIColor(white: 0.0, alpha: 1.0)
            },
                           completion: { _ in
                            self.panViewOrigin = nil
                            self.panViewAlpha  = 1.0
            }
            )
            
        }
    }
    
}

extension MTImageBrowserViewController: UIScrollViewDelegate {
    
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        imageView.frame = imageInfo.calculateRect(scrollView.contentSize)
    }
    
}

extension MTImageBrowserViewController: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MTImageBrowserTransition(imageInfo: imageInfo, transitionInfo: transitionInfo!, transitionMode: .present)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MTImageBrowserTransition(imageInfo: imageInfo, transitionInfo: transitionInfo!, transitionMode: .dismiss)
    }
    
}

class MTImageBrowserTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    let imageInfo      : MTImageInfo
    let transitionInfo : MTTransitionInfo
    var transitionMode : TransitionMode
    
    enum TransitionMode {
        case present
        case dismiss
    }
    
    init(imageInfo: MTImageInfo, transitionInfo: MTTransitionInfo, transitionMode: TransitionMode) {
        self.imageInfo = imageInfo
        self.transitionInfo = transitionInfo
        self.transitionMode = transitionMode
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionInfo.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        let tempMask = UIView()
        tempMask.backgroundColor = UIColor.black
        
        let tempImage = UIImageView(image: imageInfo.image)
        tempImage.layer.cornerRadius = transitionInfo.fromView!.layer.cornerRadius
        tempImage.layer.masksToBounds = true
        tempImage.contentMode = imageInfo.contentMode
        
        containerView.addSubview(tempMask)
        containerView.addSubview(tempImage)
        
        if transitionMode == .present {
            
            let imageViewer = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! MTImageBrowserViewController
            imageViewer.view.layoutIfNeeded()
            
            tempMask.alpha = 0
            tempMask.frame = imageViewer.view.bounds
            tempImage.frame = transitionInfo.convertedRect!
            
            UIView.animate(withDuration: transitionInfo.duration,
                           animations: {
                            tempMask.alpha  = 1
                            tempImage.frame = imageViewer.imageView.frame
            },
                           completion: { _ in
                            tempMask.removeFromSuperview()
                            tempImage.removeFromSuperview()
                            containerView.addSubview(imageViewer.view)
                            transitionContext.completeTransition(true)
            }
            )
            
        }
        
        if transitionMode == .dismiss {
            
            let imageViewer = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! MTImageBrowserViewController
            imageViewer.view.removeFromSuperview()
            
            tempMask.alpha = imageViewer.panViewAlpha
            tempMask.frame = imageViewer.view.bounds
            tempImage.frame = imageViewer.scrollView.frame
            
            UIView.animate(withDuration: transitionInfo.duration,
                           animations: {
                            tempMask.alpha  = 0
                            tempImage.frame = self.transitionInfo.convertedRect!
            },
                           completion: { _ in
                            tempMask.removeFromSuperview()
                            imageViewer.view.removeFromSuperview()
                            transitionContext.completeTransition(true)
            }
            )
            
        }
        
    }
    
}

extension MTImageBrowserViewController: UIGestureRecognizerDelegate {
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let pan = gestureRecognizer as? UIPanGestureRecognizer {
            if scrollView.zoomScale != 1.0 {
                return false
            }
            if imageInfo.imageMode == .aspectFill && (scrollView.contentOffset.x > 0 || pan.translation(in: view).x <= 0) {
                return false
            }
        }
        return true
    }
        
}
