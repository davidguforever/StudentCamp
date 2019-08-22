//
//  Created by Luochun
//  Copyright © 2016-2018年 Mantis Group. All rights reserved.
//

import UIKit

public extension MTPopOverMenu {
    
    /// show for sender
    public static func showForSender(sender : UIView, with menuArray: [String], done: @escaping (NSInteger)->(), cancel:@escaping ()->()) {
        self.sharedMenu.showForSender(sender: sender, or: nil, with: menuArray, menuImageArray: [], done: done, cancel: cancel)
    }
    /// show for sender
    public static func showForSender(sender : UIView, with menuArray: [String], menuImageArray: [String], done: @escaping (NSInteger)->(), cancel:@escaping ()->()) {
        self.sharedMenu.showForSender(sender: sender, or: nil, with: menuArray, menuImageArray: menuImageArray, done: done, cancel: cancel)
    }
    /// show for event
    public static func showForEvent(event : UIEvent, with menuArray: [String], done: @escaping (NSInteger)->(), cancel:@escaping ()->()) {
        self.sharedMenu.showForSender(sender: event.allTouches?.first?.view!, or: nil, with: menuArray, menuImageArray: [], done: done, cancel: cancel)
    }
    /// show for event
    public static func showForEvent(event : UIEvent, with menuArray: [String], menuImageArray: [String], done: @escaping (NSInteger)->(), cancel:@escaping ()->()) {
        self.sharedMenu.showForSender(sender: event.allTouches?.first?.view!, or: nil, with: menuArray, menuImageArray: menuImageArray, done: done, cancel: cancel)
    }
    /// show for senderFrame
    public static func showFromSenderFrame(senderFrame : CGRect, with menuArray: [String], done: @escaping (NSInteger)->(), cancel:@escaping ()->()) {
        self.sharedMenu.showForSender(sender: nil, or: senderFrame, with: menuArray, menuImageArray: [], done: done, cancel: cancel)
    }
    /// show for senderFrame
    public static func showFromSenderFrame(senderFrame : CGRect, with menuArray: [String], menuImageArray: [String], done: @escaping (NSInteger)->(), cancel:@escaping ()->()) {
        self.sharedMenu.showForSender(sender: nil, or: senderFrame, with: menuArray, menuImageArray: menuImageArray, done: done, cancel: cancel)
    }
    /// 隐藏 dismiss
    public static func dismiss() {
        self.sharedMenu.dismiss()
    }
}


/// 弹出POP菜单配置  see `MTPopOverMenu`
public class MTConfiguration : NSObject {
    
    public var menuRowHeight : CGFloat = MTDefaultMenuRowHeight
    public var menuWidth : CGFloat = MTDefaultMenuWidth
    public var textColor : UIColor = UIColor.white
    public var textFont : UIFont = UIFont.systemFont(ofSize: 14)
    public var borderColor : UIColor = MTDefaultTintColor
    public var borderWidth : CGFloat = MTDefaultBorderWidth
    public var backgoundTintColor : UIColor = MTDefaultTintColor
    public var cornerRadius : CGFloat = MTDefaultCornerRadius
    public var textAlignment : NSTextAlignment = NSTextAlignment.left
    public var ignoreImageOriginalColor : Bool = false
    public var menuSeparatorColor : UIColor = UIColor.lightGray
    public var menuSeparatorInset : UIEdgeInsets = UIEdgeInsets.init(top: 0, left: MTDefaultCellMargin, bottom: 0, right: MTDefaultCellMargin)
    
    /// shared
    public static var shared : MTConfiguration {
        struct StaticConfig {
            static let instance : MTConfiguration = MTConfiguration()
        }
        return StaticConfig.instance
    }
    
}

fileprivate let MTDefaultMargin : CGFloat = 4
fileprivate let MTDefaultCellMargin : CGFloat = 6
fileprivate let MTDefaultMenuIconSize : CGFloat = 24
fileprivate let MTDefaultMenuCornerRadius : CGFloat = 4
fileprivate let MTDefaultMenuArrowWidth : CGFloat = 8
fileprivate let MTDefaultMenuArrowHeight : CGFloat = 10
fileprivate let MTDefaultAnimationDuration : TimeInterval = 0.2
fileprivate let MTDefaultBorderWidth : CGFloat = 0.5
fileprivate let MTDefaultCornerRadius : CGFloat = 6
fileprivate let MTDefaultMenuRowHeight : CGFloat = 40
fileprivate let MTDefaultMenuWidth : CGFloat = 120
fileprivate let MTDefaultTintColor : UIColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 1)

fileprivate let MTPopOverMenuTableViewCellIndentifier : String = "MTPopOverMenuTableViewCellIndentifier"

fileprivate enum MTPopOverMenuArrowDirection {
    case Up
    case Down
}


 
/// 弹出POP菜单
///
///      MTPopOverMenu.showFromSenderFrame(senderFrame: sender.frame,
///         with: ["Share"],
///         menuImageArray: ["iconImageName"],
///         done: { (selectedIndex) -> () in
///
///         }) {
///     }
///
///      @IBAction func handleAddBarButtonItem(_ sender: UIBarButtonItem, event: UIEvent) {
///          MTPopOverMenu.showForEvent(event: event,  with: ["Share"],
///                                       menuImageArray: ["iconImageName"],
///                                       done: { (selectedIndex) -> () in
///           }) {
///             }
///     }
///
public class MTPopOverMenu : NSObject {
      
    var   sender : UIView?
    var senderFrame : CGRect?
    var menuNameArray : [String]!
    var   menuImageArray : [String]!
    var   done : ((_ selectedIndex : NSInteger)->())!
    var   cancel : (()->())!
      
    fileprivate static var sharedMenu : MTPopOverMenu {
          struct Static {
              static let instance : MTPopOverMenu = MTPopOverMenu()
        }
        return Static.instance
    }
    
    fileprivate lazy var configuration : MTConfiguration = {
        return MTConfiguration.shared
    }()
    
    fileprivate lazy var backgroundView : UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.clear
        view.addGestureRecognizer(self.tapGesture)
        return view
    }()
    
    fileprivate lazy var popOverMenu : MTPopOverMenuView = {
        let menu = MTPopOverMenuView(frame: CGRect.zero)
        menu.alpha = 0
        self.backgroundView.addSubview(menu)
        return menu
    }()
    
    /// 是否显示中
    static public var isShowing: Bool {
        return MTPopOverMenu.sharedMenu.isOnScreen
    }
    
    fileprivate var isOnScreen : Bool = false {
        didSet {
            if isOnScreen {
                self.addOrientationChangeNotification()
            }else{
                self.removeOrientationChangeNotification()
            }
        }
    }
    
    fileprivate lazy var tapGesture : UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onBackgroudViewTapped(gesture:)))
        gesture.delegate = self
        return gesture
    }()
    
    fileprivate func showForSender(sender: UIView?, or senderFrame: CGRect?, with menuNameArray: [String]!, menuImageArray: [String]?, done: @escaping (NSInteger)->(), cancel:@escaping ()->()){
        
        if sender == nil && senderFrame == nil {
            return
        }
        if menuNameArray.count == 0 {
            return
        }
        
        self.sender = sender
        self.senderFrame = senderFrame
        self.menuNameArray = menuNameArray
        self.menuImageArray = menuImageArray
        self.done = done
        self.cancel = cancel
        
        UIApplication.shared.keyWindow?.addSubview(self.backgroundView)
        
        self.adjustPostionForPopOverMenu()
    }
    
    fileprivate func adjustPostionForPopOverMenu() {
        self.backgroundView.frame = CGRect(x: 0, y: 0, width: UIScreen.ft_width(), height: UIScreen.ft_height())
        
        self.setupPopOverMenu()
        
        self.showIfNeeded()
    }
    
    fileprivate func setupPopOverMenu() {
        popOverMenu.transform = CGAffineTransform(scaleX: 1, y: 1)
        
        self.configurePopMenuFrame()
        
        popOverMenu.showWithAnglePoint(point: menuArrowPoint, frame: popMenuFrame, menuNameArray: menuNameArray, menuImageArray: menuImageArray, arrowDirection: arrowDirection, done: { (selectedIndex: NSInteger) in
            self.isOnScreen = false
            self.doneActionWithSelectedIndex(selectedIndex: selectedIndex)
        })
        
        popOverMenu.setAnchorPoint(anchorPoint: self.getAnchorPointForPopMenu())
    }
    
    fileprivate func getAnchorPointForPopMenu() -> CGPoint {
        var anchorPoint = CGPoint(x: menuArrowPoint.x/popMenuFrame.size.width, y: 0)
        if arrowDirection == .Down {
            anchorPoint = CGPoint(x: menuArrowPoint.x/popMenuFrame.size.width, y: 1)
        }
        return anchorPoint
    }
    
    fileprivate var senderRect : CGRect = CGRect.zero
    fileprivate var popMenuOriginX : CGFloat = 0
    fileprivate var popMenuFrame : CGRect = CGRect.zero
    fileprivate var menuArrowPoint : CGPoint = CGPoint.zero
    fileprivate var arrowDirection : MTPopOverMenuArrowDirection = .Up
    fileprivate var popMenuHeight : CGFloat {
        return configuration.menuRowHeight * CGFloat(self.menuNameArray.count) + MTDefaultMenuArrowHeight
    }
    
    fileprivate func configureSenderRect() {
        if self.sender != nil {
            if sender?.superview != nil {
                senderRect = (sender?.superview?.convert((sender?.frame)!, to: backgroundView))!
            }else{
                senderRect = (sender?.frame)!
            }
        }else if senderFrame != nil {
            senderRect = senderFrame!
        }
        senderRect.origin.y = min(UIScreen.ft_height(), senderRect.origin.y)
        
        if senderRect.origin.y + senderRect.size.height/2 < UIScreen.ft_height()/2 {
            arrowDirection = .Up
        }else{
            arrowDirection = .Down
        }
    }
    
    fileprivate func configurePopMenuOriginX() {
        var senderXCenter : CGPoint = CGPoint(x: senderRect.origin.x + (senderRect.size.width)/2, y: 0)
        let menuCenterX : CGFloat = configuration.menuWidth/2 + MTDefaultMargin
        var menuX : CGFloat = 0
        if (senderXCenter.x + menuCenterX > UIScreen.ft_width()) {
            senderXCenter.x = min(senderXCenter.x - (UIScreen.ft_width() - configuration.menuWidth - MTDefaultMargin), configuration.menuWidth - MTDefaultMenuArrowWidth - MTDefaultMargin)
            menuX = UIScreen.ft_width() - configuration.menuWidth - MTDefaultMargin
        }else if (senderXCenter.x - menuCenterX < 0){
            senderXCenter.x = max(MTDefaultMenuCornerRadius + MTDefaultMenuArrowWidth, senderXCenter.x - MTDefaultMargin)
            menuX = MTDefaultMargin
        }else{
            senderXCenter.x = configuration.menuWidth/2
            menuX = senderRect.origin.x + (senderRect.size.width)/2 - configuration.menuWidth/2
        }
        popMenuOriginX = menuX
    }
    
    fileprivate func configurePopMenuFrame() {
        self.configureSenderRect()
        self.configureMenuArrowPoint()
        self.configurePopMenuOriginX()
        
        if (arrowDirection == .Up) {
            popMenuFrame = CGRect(x: popMenuOriginX, y: (senderRect.origin.y + senderRect.size.height), width: configuration.menuWidth, height: popMenuHeight)
            if (popMenuFrame.origin.y + popMenuFrame.size.height > UIScreen.ft_height()) {
                popMenuFrame = CGRect(x: popMenuOriginX, y: (senderRect.origin.y + senderRect.size.height), width: configuration.menuWidth, height: UIScreen.ft_height() - popMenuFrame.origin.y - MTDefaultMargin)
            }
        }else{
            popMenuFrame = CGRect(x: popMenuOriginX, y: (senderRect.origin.y - popMenuHeight), width: configuration.menuWidth, height: popMenuHeight)
            if (popMenuFrame.origin.y  < 0) {
                popMenuFrame = CGRect(x: popMenuOriginX, y: MTDefaultMargin, width: configuration.menuWidth, height: senderRect.origin.y - MTDefaultMargin)
            }
        }
    }
    
    fileprivate func configureMenuArrowPoint() {
        var point : CGPoint = CGPoint(x: senderRect.origin.x + (senderRect.size.width)/2, y: 0)
        let menuCenterX : CGFloat = configuration.menuWidth/2 + MTDefaultMargin
        if senderRect.origin.y + senderRect.size.height/2 < UIScreen.ft_height()/2 {
            point.y = 0
        }else{
            point.y = popMenuHeight
        }
        if (point.x + menuCenterX > UIScreen.ft_width()) {
            point.x = min(point.x - (UIScreen.ft_width() - configuration.menuWidth - MTDefaultMargin), configuration.menuWidth - MTDefaultMenuArrowWidth - MTDefaultMargin)
        }else if (point.x - menuCenterX < 0){
            point.x = max(MTDefaultMenuCornerRadius + MTDefaultMenuArrowWidth, point.x - MTDefaultMargin)
        }else{
            point.x = configuration.menuWidth/2
        }
        menuArrowPoint = point
    }
    
    @objc fileprivate func onBackgroudViewTapped(gesture : UIGestureRecognizer) {
        self.dismiss()
    }
    
    fileprivate func showIfNeeded() {
        if self.isOnScreen == false {
            self.isOnScreen = true
            popOverMenu.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: MTDefaultAnimationDuration, animations: {
                self.popOverMenu.alpha = 1
                self.popOverMenu.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
    
    fileprivate func dismiss() {
        self.isOnScreen = false
        self.doneActionWithSelectedIndex(selectedIndex: -1)
    }
    
    fileprivate func doneActionWithSelectedIndex(selectedIndex: NSInteger) {
        UIView.animate(withDuration: MTDefaultAnimationDuration,
                       animations: {
                        self.popOverMenu.alpha = 0
                        self.popOverMenu.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }) { (isFinished) in
            if isFinished {
                self.backgroundView.removeFromSuperview()
                if selectedIndex < 0 {
                    if (self.cancel != nil) {
                        self.cancel()
                    }
                }else{
                    if (self.done != nil) {
                        self.done(selectedIndex)
                    }
                }
                
            }
        }
    }
    
}
extension UIControl {
    
    // solution found at: http://stackoverflow.com/a/5666430/6310268
    
    fileprivate func setAnchorPoint(anchorPoint: CGPoint) {
        var newPoint = CGPoint(x: self.bounds.size.width * anchorPoint.x, y: self.bounds.size.height * anchorPoint.y)
        var oldPoint = CGPoint(x: self.bounds.size.width * self.layer.anchorPoint.x, y: self.bounds.size.height * self.layer.anchorPoint.y)
        
        newPoint = newPoint.applying(self.transform)
        oldPoint = oldPoint.applying(self.transform)
        
        var position = self.layer.position
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        self.layer.position = position
        self.layer.anchorPoint = anchorPoint
    }
    
}

extension MTPopOverMenu {
    
    fileprivate func addOrientationChangeNotification() {
        NotificationCenter.default.addObserver(self,selector: #selector(onChangeStatusBarOrientationNotification(notification:)),
                                               name: UIApplication.didChangeStatusBarOrientationNotification,
                                               object: nil)
        
    }
    
    fileprivate func removeOrientationChangeNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc fileprivate func onChangeStatusBarOrientationNotification(notification : Notification) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(0.2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: {
            self.adjustPostionForPopOverMenu()
        })
    }
    
}

extension MTPopOverMenu: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: backgroundView)
        let touchClass : String = NSStringFromClass((touch.view?.classForCoder)!) as String
        if touchClass == "UITableViewCellContentView" {
            return false
        }else if CGRect(x: 0, y: 0, width: configuration.menuWidth, height: configuration.menuRowHeight).contains(touchPoint){
            // when showed at the navgation-bar-button-item, there is a chance of not respond around the top arrow, so :
            self.doneActionWithSelectedIndex(selectedIndex: 0)
            return false
        }
        return true
    }
    
}

private class MTPopOverMenuView: UIControl {
    
    fileprivate var menuNameArray : [String]!
    fileprivate var menuImageArray : [String]?
    fileprivate var arrowDirection : MTPopOverMenuArrowDirection = .Up
    fileprivate var done : ((NSInteger)->())!
    
    fileprivate lazy var configuration : MTConfiguration = {
        return MTConfiguration.shared
    }()
    
    lazy var menuTableView : UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = MTConfiguration.shared.menuSeparatorColor
        tableView.layer.cornerRadius = MTConfiguration.shared.cornerRadius
        tableView.clipsToBounds = true
        return tableView
    }()
    
    fileprivate func showWithAnglePoint(point: CGPoint, frame: CGRect, menuNameArray: [String]!, menuImageArray: [String]!, arrowDirection: MTPopOverMenuArrowDirection, done: @escaping ((NSInteger)->())) {
        
        self.frame = frame
        
        
        
        self.menuNameArray = menuNameArray
        self.menuImageArray = menuImageArray
        self.arrowDirection = arrowDirection
        self.done = done
        
        self.repositionMenuTableView()
        
        self.drawBackgroundLayerWithArrowPoint(arrowPoint: point)
    }
    
    fileprivate func repositionMenuTableView() {
        var menuRect : CGRect = CGRect(x: 0, y: MTDefaultMenuArrowHeight, width: self.frame.size.width, height: self.frame.size.height - MTDefaultMenuArrowHeight)
        if (arrowDirection == .Down) {
            menuRect = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height - MTDefaultMenuArrowHeight)
        }
        self.menuTableView.frame = menuRect
        self.menuTableView.reloadData()
        if menuTableView.frame.height < configuration.menuRowHeight * CGFloat(menuNameArray.count) {
            self.menuTableView.isScrollEnabled = true
        }else{
            self.menuTableView.isScrollEnabled = false
        }
        self.addSubview(self.menuTableView)
    }
    
    fileprivate lazy var backgroundLayer : CAShapeLayer = {
        let layer : CAShapeLayer = CAShapeLayer()
        return layer
    }()
    
    
    fileprivate func drawBackgroundLayerWithArrowPoint(arrowPoint : CGPoint) {
        if self.backgroundLayer.superlayer != nil {
            self.backgroundLayer.removeFromSuperlayer()
        }
        
        backgroundLayer.path = self.getBackgroundPath(arrowPoint: arrowPoint).cgPath
        backgroundLayer.fillColor = configuration.backgoundTintColor.cgColor
        backgroundLayer.strokeColor = configuration.borderColor.cgColor
        backgroundLayer.lineWidth = configuration.borderWidth
        self.layer.insertSublayer(backgroundLayer, at: 0)
        //        backgroundLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransform(rotationAngle: CGFloat(Double.pi))) //CATransform3DMakeRotation(CGFloat(Double.pi), 1, 1, 0)
    }
    
    func getBackgroundPath(arrowPoint : CGPoint) -> UIBezierPath {
        let radius : CGFloat = configuration.cornerRadius/2
        
        let path : UIBezierPath = UIBezierPath()
        path.lineJoinStyle = .round
        path.lineCapStyle = .round
        if (arrowDirection == .Up){
            path.move(to: CGPoint(x: arrowPoint.x - MTDefaultMenuArrowWidth, y: MTDefaultMenuArrowHeight))
            path.addLine(to: CGPoint(x: arrowPoint.x, y: 0))
            path.addLine(to: CGPoint(x: arrowPoint.x + MTDefaultMenuArrowWidth, y: MTDefaultMenuArrowHeight))
            path.addLine(to: CGPoint(x: self.bounds.size.width - radius, y: MTDefaultMenuArrowHeight))
            path.addArc(withCenter: CGPoint(x: self.bounds.size.width - radius, y: MTDefaultMenuArrowHeight + radius),
                        radius: radius,
                        startAngle: CGFloat(Double.pi / 2*3),
                        endAngle: 0,
                        clockwise: true)
            path.addLine(to: CGPoint(x: self.bounds.size.width, y: self.bounds.size.height - radius))
            path.addArc(withCenter: CGPoint(x: self.bounds.size.width - radius, y: self.bounds.size.height - radius),
                        radius: radius,
                        startAngle: 0,
                        endAngle: CGFloat(Double.pi / 2),
                        clockwise: true)
            path.addLine(to: CGPoint(x: radius, y: self.bounds.size.height))
            path.addArc(withCenter: CGPoint(x: radius, y: self.bounds.size.height - radius),
                        radius: radius,
                        startAngle: CGFloat(Double.pi / 2),
                        endAngle: CGFloat(Double.pi),
                        clockwise: true)
            path.addLine(to: CGPoint(x: 0, y: MTDefaultMenuArrowHeight + radius))
            path.addArc(withCenter: CGPoint(x: radius, y: MTDefaultMenuArrowHeight + radius),
                        radius: radius,
                        startAngle: CGFloat(Double.pi),
                        endAngle: CGFloat(Double.pi / 2 * 3),
                        clockwise: true)
            path.close()
            //            path = UIBezierPath(roundedRect: CGRect.init(x: 0, y: MTDefaultMenuArrowHeight, width: self.bounds.size.width, height: self.bounds.height - MTDefaultMenuArrowHeight), cornerRadius: configuration.cornerRadius)
            //            path.move(to: CGPoint(x: arrowPoint.x - MTDefaultMenuArrowWidth, y: MTDefaultMenuArrowHeight))
            //            path.addLine(to: CGPoint(x: arrowPoint.x, y: 0))
            //            path.addLine(to: CGPoint(x: arrowPoint.x + MTDefaultMenuArrowWidth, y: MTDefaultMenuArrowHeight))
            //            path.close()
        }else{
            path.move(to: CGPoint(x: arrowPoint.x - MTDefaultMenuArrowWidth, y: self.bounds.size.height - MTDefaultMenuArrowHeight))
            path.addLine(to: CGPoint(x: arrowPoint.x, y: self.bounds.size.height))
            path.addLine(to: CGPoint(x: arrowPoint.x + MTDefaultMenuArrowWidth, y: self.bounds.size.height - MTDefaultMenuArrowHeight))
            path.addLine(to: CGPoint(x: self.bounds.size.width - radius, y: self.bounds.size.height - MTDefaultMenuArrowHeight))
            path.addArc(withCenter: CGPoint(x: self.bounds.size.width - radius, y: self.bounds.size.height - MTDefaultMenuArrowHeight - radius),
                        radius: radius,
                        startAngle: CGFloat(Double.pi / 2),
                        endAngle: 0,
                        clockwise: false)
            path.addLine(to: CGPoint(x: self.bounds.size.width, y: radius))
            path.addArc(withCenter: CGPoint(x: self.bounds.size.width - radius, y: radius),
                        radius: radius,
                        startAngle: 0,
                        endAngle: CGFloat(Double.pi / 2*3),
                        clockwise: false)
            path.addLine(to: CGPoint(x: radius, y: 0))
            path.addArc(withCenter: CGPoint(x: radius, y: radius),
                        radius: radius,
                        startAngle: CGFloat(Double.pi / 2*3),
                        endAngle: CGFloat(Double.pi),
                        clockwise: false)
            path.addLine(to: CGPoint(x: 0, y: self.bounds.size.height - MTDefaultMenuArrowHeight - radius))
            path.addArc(withCenter: CGPoint(x: radius, y: self.bounds.size.height - MTDefaultMenuArrowHeight - radius),
                        radius: radius,
                        startAngle: CGFloat(Double.pi),
                        endAngle: CGFloat(Double.pi / 2),
                        clockwise: false)
            path.close()
            //            path = UIBezierPath(roundedRect: CGRect.init(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.height - MTDefaultMenuArrowHeight), cornerRadius: configuration.cornerRadius)
            //            path.move(to: CGPoint(x: arrowPoint.x - MTDefaultMenuArrowWidth, y: self.bounds.size.height - MTDefaultMenuArrowHeight))
            //            path.addLine(to: CGPoint(x: arrowPoint.x, y: self.bounds.size.height))
            //            path.addLine(to: CGPoint(x: arrowPoint.x + MTDefaultMenuArrowWidth, y: self.bounds.size.height - MTDefaultMenuArrowHeight))
            //            path.close()
        }
        return path
    }
    
    
    
}

extension MTPopOverMenuView : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return configuration.menuRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if (self.done != nil) {
            self.done(indexPath.row)
        }
    }
    
}

extension MTPopOverMenuView : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : MTPopOverMenuCell = MTPopOverMenuCell(style: .default, reuseIdentifier: MTPopOverMenuTableViewCellIndentifier)
        var imageName = ""
        if menuImageArray != nil {
            if (menuImageArray?.count)! >= indexPath.row + 1 {
                imageName = (menuImageArray?[indexPath.row])!
            }
        }
        cell.setupCellWith(menuName: menuNameArray[indexPath.row], menuImage: imageName)
        if (indexPath.row == menuNameArray.count-1) {
            cell.separatorInset = UIEdgeInsets.init(top: 0, left: self.bounds.size.width, bottom: 0, right: 0)
        }else{
            cell.separatorInset = configuration.menuSeparatorInset
        }
        return cell
    }
    
}

class MTPopOverMenuCell: UITableViewCell {
    
    fileprivate lazy var configuration : MTConfiguration = {
        return MTConfiguration.shared
    }()
    
    fileprivate lazy var iconImageView : UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        self.contentView.addSubview(imageView)
        return imageView
    }()
    
    fileprivate lazy var nameLabel : UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.backgroundColor = UIColor.clear
        self.contentView.addSubview(label)
        return label
    }()
    
    fileprivate func setupCellWith(menuName: String, menuImage: String?) {
        self.backgroundColor = UIColor.clear
        if menuImage != nil {
            if var iconImage : UIImage = UIImage(named: menuImage!) {
                if  configuration.ignoreImageOriginalColor {
                    iconImage = iconImage.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                }
                iconImageView.tintColor = configuration.textColor
                iconImageView.frame =  CGRect(x: MTDefaultCellMargin, y: (configuration.menuRowHeight - MTDefaultMenuIconSize)/2, width: MTDefaultMenuIconSize, height: MTDefaultMenuIconSize)
                iconImageView.image = iconImage
                nameLabel.frame = CGRect(x: MTDefaultCellMargin*2 + MTDefaultMenuIconSize, y: (configuration.menuRowHeight - MTDefaultMenuIconSize)/2, width: (configuration.menuWidth - MTDefaultMenuIconSize - MTDefaultCellMargin*3), height: MTDefaultMenuIconSize)
            }else{
                nameLabel.frame = CGRect(x: MTDefaultCellMargin, y: 0, width: configuration.menuWidth - MTDefaultCellMargin*2, height: configuration.menuRowHeight)
            }
        }
        nameLabel.font = configuration.textFont
        nameLabel.textColor = configuration.textColor
        nameLabel.textAlignment = configuration.textAlignment
        nameLabel.text = menuName
    }
    
}

extension UIScreen {
    
    public static func ft_width() -> CGFloat {
        return self.main.bounds.size.width
    }
    public static func ft_height() -> CGFloat {
        return self.main.bounds.size.height
    }
    
}
