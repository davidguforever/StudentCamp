//  Created by Luochun on 2017/2/12.
//  Copyright © 2017年 Mantis. All rights reserved.
//

import UIKit
import MTCobwebs

let STPopupFirstResponderDidChange = Notification.Name(rawValue: "STPopupFirstResponderDidChange")

extension UIResponder {

    @objc func st_becomeFirstResponder() -> Bool {
        let accepted = st_becomeFirstResponder()
        if accepted {
            NotificationCenter.default.post(name: STPopupFirstResponderDidChange, object: self)
        }
        return accepted
    }
}

extension UIViewController: SelfAware {
    private struct AssociatedKeys {
        static var landscapeContentSizeInPopupKey: String? = "landscapeContentSizeInPopup"
        static var contentSizeInPopupKey: String? = "contentSizeInPopup"
        static var popupControllerKey: String? = "popupController"
    }

    static let controllerOnceToken = UUID().uuidString

    public static func awake() {
        DispatchQueue.once(token: controllerOnceToken) {
            let selectors: [(Selector, Selector)] = [
                (#selector(viewDidLoad), #selector(st_viewDidLoad)),
                (#selector(present(_:animated:completion:)), #selector(st_present(_:animated:completion:))),
                (#selector(dismiss(animated:completion:)), #selector(st_dismiss(animated:completion:))),
                (#selector(getter: presentedViewController), #selector(getter: st_presentedViewController)),
                (#selector(getter: presentingViewController), #selector(getter: st_presentingViewController))
            ]
            selectors.forEach {
                swizzle($0.0, to: $0.1)
            }
            
            swizzle(#selector(becomeFirstResponder), to: #selector(st_becomeFirstResponder))
        }
    }


    class func swizzle(_ originalSelector: Selector, to swizzledSelector: Selector) {
        let originalMethod = class_getInstanceMethod(self, originalSelector)
        let swizzledMethod = class_getInstanceMethod(self, swizzledSelector)
        method_exchangeImplementations(originalMethod!, swizzledMethod!)
    }

    @objc func st_viewDidLoad() {
        var contentSize = CGSize.zero
        switch UIApplication.shared.statusBarOrientation {
        case .landscapeLeft, .landscapeRight:
            contentSize = landscapeContentSizeInPopup
            if contentSize == .zero {
                contentSize = contentSizeInPopup
            }
        default:
            contentSize = contentSizeInPopup
        }

        if contentSize != .zero {
            view.frame = CGRect(origin: .zero, size: contentSize)
        }
        st_viewDidLoad()
    }

    @objc func st_present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?) {
        guard let popupController = popupController else {
            st_present(viewControllerToPresent, animated: animated, completion: completion)
            return
        }

        //let controller = popupController.value(forKey: "containerViewController") as? UIViewController
        let controller = popupController.containerViewController
        controller?.present(viewControllerToPresent, animated: animated, completion: completion)
    }

    @objc func st_dismiss(animated: Bool, completion: (() -> Void)?) {
        guard let popupController = popupController else {
            st_dismiss(animated: animated, completion: completion)
            return
        }

        popupController.dismiss(with: completion)
    }

    @objc var st_presentedViewController: UIViewController? {
        guard let popupController = popupController else { return self.st_presentedViewController }

        let controller = popupController.containerViewController
        return controller?.presentedViewController
    }

    @objc var st_presentingViewController: UIViewController? {
        guard let popupController = popupController else { return self.st_presentingViewController }
        //let controller = popupController.value(forKey: "containerViewController") as? UIViewController
        let controller = popupController.containerViewController
        return controller?.presentingViewController
    }

    static let screenW = UIScreen.main.bounds.width
    static let screenH = UIScreen.main.bounds.height

    var contentSizeInPopup: CGSize {
        set {
            var value = newValue
            if value != .zero && value.width == 0 {
                switch UIApplication.shared.statusBarOrientation {
                case .landscapeLeft, .landscapeRight:
                    value.width = UIViewController.screenH
                default:
                    value.width = UIViewController.screenW
                }
            }

            objc_setAssociatedObject(self, &AssociatedKeys.contentSizeInPopupKey, NSValue(cgSize: value), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }

        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.contentSizeInPopupKey) as? CGSize) ?? .zero
        }
    }

    var landscapeContentSizeInPopup: CGSize {
        set {
            var value = newValue
            if value != .zero && value.width == 0 {
                switch UIApplication.shared.statusBarOrientation {
                case .landscapeLeft, .landscapeRight:
                    value.width = UIViewController.screenW
                default:
                    value.width = UIViewController.screenH
                }
            }
            objc_setAssociatedObject(self, &AssociatedKeys.landscapeContentSizeInPopupKey, NSValue(cgSize: value), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }

        get {
            return (objc_getAssociatedObject(self, &AssociatedKeys.landscapeContentSizeInPopupKey) as? CGSize) ?? .zero
        }
    }

    var popupController: STPopupController? {
        set {
            guard let newValue = newValue else { return }
            objc_setAssociatedObject(self, &AssociatedKeys.popupControllerKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }

        get {
            let popupController = objc_getAssociatedObject(self, &AssociatedKeys.popupControllerKey) as? STPopupController
            guard let controller = popupController else {
                return parent?.popupController
            }
            return controller
        }
    }
}
