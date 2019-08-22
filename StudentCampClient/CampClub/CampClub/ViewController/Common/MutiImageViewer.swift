
//
//  UIViewController+ImageViewer.swift
//  HouseShop
//
//  Created by Luochun on 2018/8/23.
//  Copyright © 2018 Mantis Group. All rights reserved.
//

import Foundation
import ImageViewer
import Kingfisher
import UIKit

class MutilImageViewer {


    var imageItems :[DataItem] = []

    init(_ paths: [String] , imageViews: [UIImageView]) {
        for (index, imgView) in imageViews.enumerated() {
            let galleryItem = GalleryItem.image { imageCompletion in
                if let img = imgView.image {
                    imageCompletion(img)
                } else {

                    if paths.count > index {
                        if let url = URL(string: paths[index])  {

                            imgView.kf.setImage(with: url, placeholder: imgView.image, options: nil,
                                                progressBlock: nil, completionHandler: { (img, _, _, _) in
                                                    imageCompletion(img)
                            })
                        }
                    }
                }
            }
            imageItems.append( DataItem(imageView: imgView, galleryItem: galleryItem))
        }
    }
    
    init(_ paths: [String] ) {
        paths.forEach({path in
            let imageView = UIImageView()
            let galleryItem = GalleryItem.image { imageCompletion in
                if let url = URL(string: path)  {
                    
                        imageView.kf.setImage(with: url, placeholder: nil, options: nil,
                                        progressBlock: nil, completionHandler: { (img, _, _, _) in
                                            imageCompletion(img)
                    })
                   
                }
                
            }
            imageItems.append( DataItem(imageView: imageView, galleryItem: galleryItem))
        })
    }
    

    func show(at index: Int) {

        let galleryViewController = GalleryViewController(startIndex: index, itemsDataSource: self, itemsDelegate: nil, displacedViewsDataSource: self, configuration: ImageViewerConfig.config)

        galleryViewController.launchedCompletion = { print("LAUNCHED") }
        galleryViewController.closedCompletion = { print("CLOSED") }
        galleryViewController.swipedToDismissCompletion = { print("SWIPE-DISMISSED") }

        galleryViewController.landedPageAtIndexCompletion = { index in
            print("LANDED AT INDEX: \(index)")
        }

        AppDelegate.root.presentImageGallery(galleryViewController)

        //self.presentImageGallery(galleryViewController)

    }
}



extension MutilImageViewer: GalleryDisplacedViewsDataSource {

    func provideDisplacementItem(atIndex index: Int) -> DisplaceableView? {
        return index < imageItems.count ? imageItems[index].imageView  : nil
    }
}

extension MutilImageViewer: GalleryItemsDataSource {

    func itemCount() -> Int {

        return imageItems.count
    }

    func provideGalleryItem(_ index: Int) -> GalleryItem {

        return imageItems[index].galleryItem
    }
}


