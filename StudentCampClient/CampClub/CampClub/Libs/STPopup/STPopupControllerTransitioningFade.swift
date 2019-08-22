//  Created by Luochun on 2017/2/12.
//  Copyright © 2017年 Mantis. All rights reserved.
//

import UIKit

class STPopupControllerTransitioningFade: STPopupControllerTransitioning {

    func popupControllerAnimateTransition(_ context: STPopupControllerTransitioningContext, completion: (() -> Void)?) {
        let containerView = context.containerView
        let duration = popupControllerTransitionDuration(context)

        if context.action == .present {
            containerView?.alpha = 0
            containerView?.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)

            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
                containerView?.alpha = 1
                containerView?.transform = CGAffineTransform.identity
            }, completion: { (_) in
                completion?()
            })
        } else {
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
                containerView?.alpha = 0
            }, completion: { (_) in
                containerView?.alpha = 1
                completion?()
            })
        }
    }
}
