
import UIKit

let MTNavigationBarBackgroundColor = UIColor.white
let titleTextColor = UIColor.white


/// MTNavigationController
class MTNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationBar.isTranslucent = false   // 不透明
        self.navigationBar.backgroundColor = nil
        navigationBar.shadowImage = UIImage()       // hide bottom border
        navigationBar.barStyle = .default
        
        navigationBar.setBackgroundImage(UIImage.imageWith(MTNavigationBarBackgroundColor), for: .default)
        navigationBar.tintColor = MTColor.title222
        let textAttributes = [
            NSAttributedString.Key.foregroundColor: MTColor.main,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: UIFont.Weight(rawValue: 5.0))
            ] as [NSAttributedString.Key : Any]
        
        navigationBar.titleTextAttributes = textAttributes
        
        if responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) {
            interactivePopGestureRecognizer?.delegate = self
            delegate = self
        }
        
    }
    
    var titleColor: UIColor = titleTextColor {
        didSet {
            let textAttributes = [ NSAttributedString.Key.foregroundColor: titleColor, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)] as [NSAttributedString.Key : Any]
            navigationBar.titleTextAttributes = textAttributes
        }
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.viewControllers.count > 0 {
            //UIApplication.shared.statusBarStyle = .default
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        if self.viewControllers.count == 2 {
            //UIApplication.shared.statusBarStyle = .lightContent
        }
        return super.popViewController(animated: animated)
    }
    
    /// disables swipe gestures
    public func disableSwipeBack() {
        interactivePopGestureRecognizer?.isEnabled = false
    }
    
    /// enables swipe gestures
    public func enableSwipeBack() {
        interactivePopGestureRecognizer?.isEnabled = true
    }
    
    /// toggles swipe gestures
    public func toggleSwipeBack() {
        guard let status = interactivePopGestureRecognizer?.isEnabled else {
            return
        }
        interactivePopGestureRecognizer?.isEnabled = !status
    }
}
extension MTNavigationController: UIGestureRecognizerDelegate {
    
    override func popToRootViewController(animated: Bool) -> [UIViewController]? {
        if responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) && animated {
            interactivePopGestureRecognizer?.isEnabled = false
        }
        
        return super.popToRootViewController(animated: animated)
    }
    
    override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) && animated {
            interactivePopGestureRecognizer?.isEnabled = false
        }
        
        return super.popToViewController(viewController, animated: false)
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == interactivePopGestureRecognizer {
            if self.viewControllers.count < 2 || self.visibleViewController == self.viewControllers[0] {
                return false
            }
        }
        
        return true
    }

}

extension MTNavigationController: UINavigationControllerDelegate {
    //MARK: - UINavigationControllerDelegate
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if responds(to: #selector(getter: UINavigationController.interactivePopGestureRecognizer)) {
            interactivePopGestureRecognizer?.isEnabled = true
        }
    }
}


extension UINavigationController {
    /// 状态栏颜色设置
    open override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    
    open override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }
}

fileprivate extension UIImage {

    /// 根据颜色生成图片
    static func imageWith(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

