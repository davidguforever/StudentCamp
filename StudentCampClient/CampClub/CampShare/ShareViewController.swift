//
//  ShareViewController.swift
//  CampShare
//
//  Created by Luochun on 2019/6/2.
//  Copyright © 2019 Mantis group. All rights reserved.
//
import MobileCoreServices
import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    let SIConfigurationItemViewID = "ConfigurationItemView"
    
    var attachment : NSItemProvider?
    
    var configItems : [SLComposeSheetConfigurationItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 46.0/255.0, green: 140.0/255.0, blue: 212.0/255.0, alpha: 1.0)
        
        
        self.prepareConfigurationItems()
    }
    
    override func isContentValid() -> Bool {
        // Content text is required
        if self.contentText.isEmpty {
            return false
        }
        
        // Link Name is required
        if (self.attachment != nil && self.attachment!.hasItemConformingToTypeIdentifier(kUTTypeURL as String)) {
            
            // return self.configItems != nil && !self.configItems[1].value.isEmpty (Geeting error)
            return !self.configItems[0].value.isEmpty
        }
        
        return true
    }
    
    /*!
     It prepares configuration items according to attachment type
     */
    func prepareConfigurationItems() {
        
        // Extract attachment
        if let inputItem = self.extensionContext!.inputItems[0] as? NSExtensionItem {
            if let attachments = inputItem.attachments {
                if !attachments.isEmpty {
                    self.attachment = attachments[0]
                }
            }
        }
        
        // Prepare configuration items according to attachment type
        if (self.attachment != nil) {
            
            if self.attachment!.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                // URL attachment needs two configuration items:
                // - URL
                // - Link Name
                let urlItem = SLComposeSheetConfigurationItem()
                urlItem!.title = "地址"
                self.attachment!.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil, completionHandler: {
                    (obj, error) in
                    if let url = obj as? NSURL {
                        urlItem!.value = url.absoluteString
                    }
                })
                self.configItems = [urlItem!]
            }
        }
    }
    

    override func didSelectPost() {
        if let item = self.extensionContext?.inputItems.first as? NSExtensionItem, let provider = item.attachments?.first {
            if provider.isURL {
                print("===============")
                print(self.contentText + "+++++" + self.configItems[0].value )
                HttpApi.contentAdd(self.userName, title: self.contentText, content: self.configItems[0].value) { (res, err) in
                    if let _ = res {
                        
                    } else {
                        
                    }
                }
            }
        }
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return configItems
    }

    
    var userName: String {
        if let user :JSONMap = UserDefaults(suiteName: "group.com.lc.camp")?.dictionary(forKey: "loginedUser") {
            if let userName = user["username"] as? String {
                return userName
            }
        }
        return ""
    }
}
extension NSItemProvider {
    var isURL: Bool {
        return hasItemConformingToTypeIdentifier(kUTTypeURL as String)
    }
    var isText: Bool {
        return hasItemConformingToTypeIdentifier(kUTTypeText as String)
    }
}

