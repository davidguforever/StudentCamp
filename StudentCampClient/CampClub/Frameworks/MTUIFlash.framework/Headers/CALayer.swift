//
//  CALayer.swift
//  ImageViewer
//
//  Created by Luochun
//  Copyright © 2016 MailOnline. All rights reserved.
//

import UIKit

extension CALayer {

    /// 转为图片
    func toImage() -> UIImage {

        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        self.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image!
    }
}
