//
//  UISegmentedControl+MTExt.swift
//
//  Copyright © 2016-2018年 Mantis Group. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
    
    // MARK: - Properties
    public extension UISegmentedControl {
        
        /// Segments titles.
        public var segmentTitles: [String] {
            get {
                let range = 0..<numberOfSegments
                return range.compactMap { titleForSegment(at: $0) }
            }
            set {
                removeAllSegments()
                for (index, title) in newValue.enumerated() {
                    insertSegment(withTitle: title, at: index, animated: false)
                }
            }
        }
        
        /// Segments images.
        public var segmentImages: [UIImage] {
            get {
                let range = 0..<numberOfSegments
                return range.compactMap { imageForSegment(at: $0) }
            }
            set {
                removeAllSegments()
                for (index, image) in newValue.enumerated() {
                    insertSegment(with: image, at: index, animated: false)
                }
            }
        }
        
    }
#endif

