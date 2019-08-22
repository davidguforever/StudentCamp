
import UIKit


private let NavBarTitleFont = UIFont.systemFont(ofSize: 18, weight: .regular)

enum navigationBarStyle {
    case white
    case main
}

class MTBaseViewController: UIViewController {
    
    var animatedOnNavigationBar = true
    
    deinit {
        print("👻👻👻------------\(String(describing: self)) deinit")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = MTColor.pageback
        
        if #available(iOS 11.0, *) {
            if let view = self.view.subviews.first {
                if view.isKind(of: UIScrollView.self) {
                    (view as! UIScrollView).contentInsetAdjustmentBehavior = .never
                }
            }
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    
    /// 导航背景
    var style: navigationBarStyle = .white
    
    /// 状态栏颜色设置
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if style == .white {
            return .default
        } else {
            return .lightContent
        }
    }
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if style == .white {
            navigationController?.navigationBar.setBackgroundImage(UIImage.image(withColor: MTNavigationBarBackgroundColor), for: .default)
            (navigationController as? MTNavigationController)?.titleColor = MTColor.title111
        } else {
            navigationController?.navigationBar.setBackgroundImage(UIImage.image(withColor: MTNavigationBarBackgroundColor), for: .default)
            (navigationController as? MTNavigationController)?.titleColor = MTColor.title111
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(MTNavigationBarBackgroundColor), for: .default)
        //(navigationController as! MTNavigationController).titleColor = .white
        
    }
    
}
extension MTBaseViewController {
    // 添加导航左侧按钮
    @discardableResult
    func addNavigationBarLeftButton(_ taget: Any, action: Selector = #selector(popBack), image: UIImage? = AppConfig.backImage) -> UIBarButtonItem {

        var leftItems = [UIBarButtonItem]()
        let backItem = UIBarButtonItem(image: image , style: .plain, target: self, action: action)
        //backItem.tintColor = .white
        leftItems.append(backItem)
        
        navigationItem.leftBarButtonItems = leftItems
        return backItem
    }
    
    // 添加导航左侧按钮
    @discardableResult
    func addNavigationBarLeftButton2(_ taget: Any, action: Selector = #selector(popBack), image: UIImage? = AppConfig.backImage) -> UIButton {
        let leftButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        if style == .white {
            leftButton.setImage(image, for: .normal)
        } else {
            leftButton.setImage(image, for: .normal)
        }
        leftButton.backgroundColor  = .gray
        //leftButton.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10)
        //leftButton.contentHorizontalAlignment = .left
        leftButton.addTarget(taget, action: action, for: .touchUpInside)
        
        // here where the magic happens, you can shift it where you like
        leftButton.transform = CGAffineTransform(translationX: -15, y: 0)   //15 刚好
        // add the button to a container, otherwise the transform will be ignored
        let suggestButtonContainer = UIView(frame: leftButton.frame)
        suggestButtonContainer.addSubview(leftButton)
        let suggestButtonItem = UIBarButtonItem(customView: suggestButtonContainer)
        
        self.navigationItem.leftBarButtonItem = suggestButtonItem
        return leftButton
    }
    
    // 添加导航右侧按钮
    @discardableResult
    func addNavigationBarRightButton(_ taget: Any, action: Selector, image: UIImage)  -> UIButton {
        let rightButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        rightButton.setImage(image, for: .normal)
        rightButton.addTarget(taget, action: action, for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        self.navigationItem.rightBarButtonItem?.tintColor = MTColor.title222
        return rightButton
    }
    
    // 添加导航右侧按钮
    @discardableResult
    func addNavigationBarRightButton(_ taget: Any, action: Selector, text: String, color: UIColor? = MTColor.main) -> UIButton {
        let rightButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 68, height: 36))
        rightButton.contentHorizontalAlignment = .right
        rightButton.setTitle(text, for: .normal)
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        rightButton.setTitleColor(color, for: .normal)
        rightButton.setTitleColor(color?.alpha(0.5), for: .highlighted)
        rightButton.addTarget(taget, action: action, for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        return rightButton
    }
    
    // 添加导航标题
    @discardableResult
    func addNavigationBarTitle(_ title: String, color: UIColor = .white) -> UILabel {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 31))
        titleLabel.text = title
        titleLabel.font = NavBarTitleFont
        titleLabel.textColor = color
        //titleLabel.sizeToFit()
        titleLabel.textAlignment = .center
        self.navigationItem.titleView = titleLabel
        return titleLabel
    }
    // 添加导航标题
    @discardableResult
    func addNavigationBarTitle(_ image: UIImage) -> UIImageView {
        let titleImage = UIImageView(image: image)
        self.navigationItem.titleView = titleImage
        return titleImage
    }
    

}

func showSuccess(_ message: String) {
    
//    let style = ToastManager.shared.style
//    let activityView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: style.activitySize.width, height: style.activitySize.height))
//    activityView.backgroundColor = style.activityBackgroundColor
//    activityView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
//    activityView.layer.cornerRadius = style.cornerRadius
//
//    if style.displayShadow {
//        activityView.layer.shadowColor = style.shadowColor.cgColor
//        activityView.layer.shadowOpacity = style.shadowOpacity
//        activityView.layer.shadowRadius = style.shadowRadius
//        activityView.layer.shadowOffset = style.shadowOffset
//    }
//    let imgView = UIImageView(image: #imageLiteral(resourceName: "tips_success"))
//    activityView.addSubview(imgView)
    
    AppDelegate.shared.window?.hideAllToasts()
    AppDelegate.shared.window?.makeToast(message, duration: 2.0, position: .center, image: #imageLiteral(resourceName: "tips_success")) { (didTap) in
        
    }
}


/// 显示信息，比如请求api 返回错误
///
/// - Parameters:
///   - message: 信息
///   - during: 时间  默认2秒
func showMessage(_ message: String?, during: Double = 2.0)  {
    guard let mess = message else {return}
    AppDelegate.shared.window?.hideAllToasts()
    ToastManager.shared.isTapToDismissEnabled = true
    var style = ToastStyle()
    style.messageFont = UIFont.systemFont(ofSize: 15, weight: .medium)
    style.messageColor = UIColor.white
    style.messageAlignment = .center
    style.backgroundColor = UIColor.black
    style.cornerRadius = 4
    AppDelegate.shared.window?.makeToast(mess, duration: during, position: .center, style: style)

}


