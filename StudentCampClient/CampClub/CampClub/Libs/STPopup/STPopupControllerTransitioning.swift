//  Created by Luochun on 2017/2/12.
//  Copyright © 2017年 Mantis. All rights reserved.
//

import UIKit

protocol STPopupControllerTransitioning {
    /** 
     Return duration of transitioning, it will be used to animate transitioning of background view.
     */
    func popupControllerTransitionDuration(_ context: STPopupControllerTransitioningContext) -> TimeInterval
    /** 
     Animate transitioning the container view of popup controller. "completion" need to be called after transitioning is finished.
     Initially "containerView" will be placed at the final position with transform = CGAffineTransformIdentity if it's presenting.
     */
    func popupControllerAnimateTransition(_ context: STPopupControllerTransitioningContext, completion: (() -> Void)?)
}

extension STPopupControllerTransitioning {
    func popupControllerTransitionDuration(_ context: STPopupControllerTransitioningContext) -> TimeInterval {
        if self is STPopupControllerTransitioningFade {
            return context.action == .present ? 0.25 : 0.2
        } else {
            return context.action == .present ? 0.5 : 0.35
        }
    }
}
