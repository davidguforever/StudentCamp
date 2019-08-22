//
//  ScheduleViewController.swift
//  CampClub
//
//  Created by Luochun on 2019/5/3.
//  Copyright © 2019 Mantis group. All rights reserved.
//

import UIKit
/*
let scheduleFileName = "campSchedule"
let scheduleFileExtension = ".jpg"
let scheduleFilePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
*/

class ScheduleViewController: MTBaseViewController {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var upButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imgView.addTapGesture { (_) in
            MutilImageViewer.init([""], imageViews: [self.imgView]).show(at: 0)
        }
        
        if User.shared.role != .manager {
            upButton.isHidden = true
        }
        
        //getLocalFileName()
        
        imgView.kf.indicatorType = .activity
        imgView.kf.setImage(with: URL(string: BaseUrl + "downloadImage?imageName=DateImg.jpg"),placeholder: nil,options: [.forceRefresh],progressBlock:nil,completionHandler: nil)
    }

    @IBAction func upload(_ sender: UIButton) {
        self.selectPhoto { (img) in
            MTHUD.showLoading()
            HttpApi.uploadImage(img.jpegData(compressionQuality: 1)!, completion: { (res) in
                MTHUD.hide()
                if let result = res["result"] as? String, result == "SUCCESS" {
                    showMessage("上传成功")
                    //self.imgView.kf.setImage(with: URL(string: BaseUrl + "downloadImage?imageName=DateImg.jpg"))
                    self.imgView.setImage(img,animated: true);
                } else {
                    showMessage(res["error"] as! String)
                }
            })
        }
    }
    /*
    func getLocalFileName()->String?
    {
        print("\(scheduleFilePath!)")
        do{
            var localFileName:String?
            
            let array = try FileManager.default.contentsOfDirectory(atPath: scheduleFilePath!)
            
            for fileName in array{
                
                if(fileName.hasPrefix(scheduleFileName) && fileName.hasSuffix(scheduleFileExtension)){
                    
                    print("\(fileName)")
                    
                    var isDir: ObjCBool = true
                    
                    let fullPath = "\(scheduleFilePath!)/\(fileName)"
                    
                    if FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDir) {
                        if !isDir.boolValue {
                            localFileName = fileName;
                            break
                        }
                    }
                }
            }
            
        }catch let error as NSError{
            print("\(error)")
        }
        
        return nil
        
    }
    */
}
