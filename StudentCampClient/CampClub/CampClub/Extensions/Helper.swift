//
//  Helper.swift
//  MovieBooking
//
//  Created by Xuhang Liu on 2019/2/26.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import Foundation
import UIKit
import MTCobwebs

//regex for email
let emailRegex = "^[A-Za-z\\d]+([-_.][A-Za-z\\d]+)*@([A-Za-z\\d]+[-.])+[A-Za-z\\d]{2,4}$"

extension UITextField {
    /// Add padding to the left of the textfield rect.
    ///
    /// - Parameter padding: amount of padding to apply to the left of the textfield rect.
    public func addPaddingLeft(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: frame.height))
        leftView = paddingView
        leftViewMode = .always
    }
}

extension UIViewController {

    // back
    @objc func popBack() {
        if let root = self.navigationController?.viewControllers[0] {
            if root == self {
                self.navigationController?.dismiss(animated: true, completion: nil)
            } else {
                let _ = self.navigationController?.popViewController(animated: true)
            }
        } else {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func showTips(_ message: String) {
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 240, height: 48))
        titleLabel.textAlignment = .center
        titleLabel.layer.cornerRadius = 3
        titleLabel.layer.masksToBounds = true
        titleLabel.text = message
        titleLabel.font = UIFont.systemFont(ofSize: 13)
        titleLabel.backgroundColor = UIColor(red:0.26, green:0.28, blue:0.33, alpha:1.00)
        titleLabel.textColor = UIColor.white
        titleLabel.numberOfLines = 0
        let layer = titleLabel.layer
        
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 3
        //titleLabel.sizeToFit()
        titleLabel.center = self.view.center
        self.view.addSubview(titleLabel)
        
        delay(1.5) {
            titleLabel.removeFromSuperview()
        }
        
    }
}


extension Date {
    
    func dateString(_ format: String = "MM-dd-YYYY") -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        return dateFormatter.string(from: self)
    }
    
    func dateByAddingYears(_ dYears: Int) -> Date {
        
        var dateComponents = DateComponents()
        dateComponents.year = dYears
        
        return Calendar.current.date(byAdding: dateComponents, to: self)!
    }
}

extension UIImage {
    
    func saveToDoc() -> String? {
        if let imageData = self.jpegData(compressionQuality: 1) as Data? {
            let dirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
            let fileURL = URL(string: Date().dateString("yyyyMMddhhmmssSSS"), relativeTo: dirURL)
            try! imageData.write(to: fileURL!)
            //imageData.write(to: fileURL!, options: true)
            print("fullPath=\(fileURL!.path)")
            return fileURL!.path
        }
        else {return nil}
    }
}


