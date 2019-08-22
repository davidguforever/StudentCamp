//  Created by Luochun on 2017/2/12.
//  Copyright © 2017年 Mantis. All rights reserved.
//
import UIKit

class STPopupContainerViewController: UIViewController {

    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let presentingViewController = presentingViewController, !children.isEmpty else {
            return super.preferredStatusBarStyle
        }
        return presentingViewController.preferredStatusBarStyle
    }

    override var childForStatusBarHidden: UIViewController? {
        return children.last
    }

    override var childForStatusBarStyle: UIViewController? {
        return children.last
    }

    override func show(_ vc: UIViewController, sender: Any?) {
        method(vc: vc)
    }

    override func showDetailViewController(_ vc: UIViewController, sender: Any?) {
        method(vc: vc)
    }

    private func method(vc: UIViewController) {
        let size = vc.landscapeContentSizeInPopup
        let contentSize = vc.contentSizeInPopup
        if contentSize != .zero || size != .zero {
            let childViewController = children.last
            childViewController?.popupController?.push(vc, animated: true)
        } else {
            present(vc, animated: true, completion: nil)
        }
    }
}
