//
//  ScheduleViewController.swift
//  CampClub
//
//  Created by Luochun on 2019/5/3.
//  Copyright © 2019 Mantis group. All rights reserved.
//

import UIKit

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
        
        
        self.flashpic()
        
    }
    func flashpic(){
        //从本地读取
        if let oldname=getLocalFileName(){
            let oldpicPath=scheduleFilePath?.toNSString.strings(byAppendingPaths: [oldname])[0]
            let image=UIImage(contentsOfFile: oldpicPath!)
            imgView.setImage(image, animated: false)
        }
        //与服务器比较与请求
        let localname=getLocalFileName() ?? "nofile"
        print("localname:\(localname)")
        HttpApi.getImageTime(oldname: localname, completion: self.downloadPic)
        
    }
    
    
    
    @IBAction func upload(_ sender: UIButton) {
        self.selectPhoto { (img) in
            MTHUD.showLoading()
            HttpApi.uploadImage(img.jpegData(compressionQuality: 1)!, completion: { (res) in
                MTHUD.hide()
                if let result = res["result"] as? String, result == "SUCCESS" {
                    showMessage("上传成功")
                    self.imgView.setImage(img, animated: true)
                    self.flashpic()
                } else {
                    showMessage(res["error"] as! String)
                }
            })
        }
    }
    
    let scheduleFileName = "campSchedule"
    let scheduleFileExtension = ".jpg"
    let scheduleFilePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
    func getLocalFileName()->String?
    {
        //print("\(scheduleFilePath!)")
        do{
            var localFileName:String?
            
            let array = try FileManager.default.contentsOfDirectory(atPath: scheduleFilePath!)
            
            for fileName in array{
                
                print("\(fileName)")
                
                if(fileName.hasPrefix(scheduleFileName) && fileName.hasSuffix(scheduleFileExtension)){
                    
                    print("hasfinded:\(fileName)")
                    
                    var isDir: ObjCBool = true
                    
                    let fullPath = "\(scheduleFilePath!)/\(fileName)"
                    
                    if FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDir) {
                        if !isDir.boolValue {
                            localFileName = fileName;
                            return localFileName
                        }
                    }
                }
            }
            
        }catch let error as NSError{
            print("\(error)")
        }
        
        return nil
        
    }
    func downloadPic( result:String?){
        //服务器返回的结果：1.nil 2. 0（与服务器相同）3. 新文件名-需要下载
        if result==nil {
            print("nil")
            return
        }
        if (result!.starts(with: "0") || result!.contains("错误")){
            print(result!)
            return
        }
        else {
            //删除旧图片
            if let oldname=getLocalFileName(){
                let oldpicPath=scheduleFilePath?.toNSString.strings(byAppendingPaths: [oldname])[0]
                do{
                    print("begin delete")
                    try FileManager.default.removeItem(atPath: oldpicPath!)
                    
                }catch{
                    print("delete error")
                }
            }
            //建立新图片
            let newName=result!
            print("newName:\(newName)")
            let url : URL = URL.init(string: BaseUrl + "downloadImage?imageName=DateImg.jpg")! // 初始化url图片
            showMessage("正在下载最新日程表")
            DispatchQueue.global().async {
                print("begin download")
                let data : NSData! = NSData(contentsOf: url) //转为data类型
                print("end download")
                if data != nil { //判断data不为空，这里是因为swift对类型要求很严，如果未空的话，会崩溃
                    self.imgView.setImage(UIImage.init(data: data as Data, scale: 1), animated: true)
                    let filePath = self.scheduleFilePath?.toNSString.strings(byAppendingPaths: [newName])
                    do {
                        print(filePath![0])
                        data.write(toFile: filePath![0], atomically: true)
                        showMessage("日程表下载成功")
                        
                        
                    }
                }
            }
            
        }
    }
    
}

