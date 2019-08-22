//
//  UIViewController+Camera.swift
//  TaodaiAgents
//
//  Created by Luochun on 2018/5/7.
//  Copyright © 2018年 Mantis Group. All rights reserved.
//

import Foundation
import UIKit

/// 图片质量
let imageQualityMinFileSize: Int = 500 * 1024
/// 图片尺寸
let imageSizeMaxLength: CGFloat = 1080

extension UIViewController {
    
    /// 打开相机·
    ///
    /// - Parameters:
    ///   - allowResizing: 允许编辑尺寸
    ///   - completion: callback
    func openCamera(_ allowResizing: Bool = true, completion: @escaping (_ image: UIImage) -> ())  {
        let minimumSize: CGSize = CGSize(width: 200, height: 120)
        
        let croppingParameters = CroppingParameters(isEnabled: false, allowResizing: allowResizing, allowMoving: allowResizing, minimumSize: minimumSize)
        
        let cameraViewController = CameraViewController(croppingParameters: croppingParameters, allowsLibraryAccess: true) { [weak self] image, asset in
            if let img = image {
                let selectedImage = img.scaled(toWidth: imageSizeMaxLength)!.scaled(toHeight: imageSizeMaxLength)!
                completion(selectedImage)
            }
            self?.dismiss(animated: true, completion: nil)
        }
        present(cameraViewController, animated: true, completion: nil)
    }
    
    /// 打开相册 选择一张照片
    ///
    /// - Parameters:
    ///   - allowResizing: 允许编辑尺寸
    ///   - completion: callback
    func selectPhoto(_ allowResizing: Bool = true, size: CGSize = CGSize(width: 200, height: 120), completion: @escaping (_ image: UIImage) -> ())  {
        let minimumSize: CGSize = size
        
        let croppingParameters = CroppingParameters(isEnabled: false, allowResizing: allowResizing, allowMoving: allowResizing, minimumSize: minimumSize)
        
        let libraryViewController = CameraViewController.imagePickerViewController(croppingParameters: croppingParameters) { [weak self] image, asset in
            if image != nil {
                let selectedImage = image!.scaled(toWidth: imageSizeMaxLength)!.scaled(toHeight: imageSizeMaxLength)!
                
                completion(selectedImage)
            }
            self?.dismiss(animated: true, completion: nil)
        }
        present(libraryViewController, animated: true, completion: nil)
    }
    
    
//    /// 打开相册 选择多张照片
//    ///
//    /// - Parameters:
//    ///   - allowResizing: 允许编辑尺寸
//    ///   - completion: callback
//    func selectPhotos(_ completion: @escaping (_ images: [UIImage]) -> ())  {
//
//        let libraryViewController = CameraViewController.imagePickerViewController(croppingParameters: <#CroppingParameters#>, completion: { [weak self] assets in
//            if let assets = assets {
//                let images = ImageFetcher.resolveAssets(assets, size: largestPhotoSize())
//
//                completion(images)
//            }
//            self?.dismiss(animated: true, completion: nil)
//        })
//        present(libraryViewController, animated: true, completion: nil)
//
//    }
}
