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
    //cache目录
    let scheduleFilePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
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
        //向与服务器请求
        HttpApi.getImageTime(completion: self.downloadPic)
        
    }
    
    
    
    @IBAction func upload(_ sender: UIButton) {
        self.selectPhoto { (img) in
            MTHUD.showLoading()
            HttpApi.uploadImage(img.jpegData(compressionQuality: 1)!, completion: { (res) in
                MTHUD.hide()
                if let result = res["result"] as? String, result == "SUCCESS" {
                    showMessage("上传成功")
                    //0.设置图片
                    self.imgView.setImage(img, animated: true)
                    //保存图片
                    do{
                        //1.先删除本地的图片
                        self.deleteLocalPic()
                        //2.保存图片
                        let filePath = self.scheduleFilePath?.toNSString.strings(byAppendingPaths: ["campxxxx.jpg"])
                        print(filePath![0])
                        try img.jpegData(compressionQuality: 1)?.write(to: URL(fileURLWithPath: filePath![0]))
                        
                    }catch{
                        
                    }
                    //3.向服务器请求，利用结果给本地图片命名
                    HttpApi.getImageTime(completion: self.setlocalpic)
                } else {
                    showMessage(res["error"] as! String)
                }
            })
        }
    }
    
    func setlocalpic(newName:String?){
        //1.重命名文件
        do{
           try  FileManager.default.moveItem(atPath: scheduleFilePath!+"campxxxx.jpg", toPath: scheduleFilePath!+newName!)
            print("正在重命名，工作目录："+scheduleFilePath!)
        }catch{
            
        }
        
    }



    func getLocalFileName()->String?
    {
        let scheduleFileName = "camp"
        let scheduleFileExtension = ".jpg"
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
    
    func deleteLocalPic(){
        //删除本地的（一张）图片
        if let oldname=getLocalFileName(){
            let oldpicPath=scheduleFilePath?.toNSString.strings(byAppendingPaths: [oldname])[0]
            do{
                print("begin delete")
                try FileManager.default.removeItem(atPath: oldpicPath!)
                
            }catch{
                print("delete error")
            }
        }
    }
    
    func downloadPic( result:String?){
        //服务器返回的结果：1.null 2.campxxx.jpg
        if result==nil {
            print("nil")
            return
        }
        if (result!.starts(with: "no") || result!.contains("错误")){
            print(result!)
            return
        }
        else {
            //获取本地图片名
            let localname=getLocalFileName() ?? "nofile"
            print("localname:\(localname)")
            if(localname==result){
                return;
            }
            //删除旧图片
            deleteLocalPic()
            //建立新图片
            let newName=result!
            print("newName:\(newName)")
            let url : URL = URL.init(string: BaseUrl + "downloadImage?imageName=DateImg.jpg")! // 初始化url图片
            showMessage("正在下载最新日程表")
            DispatchQueue.global().async {
                print("begin download")
                let data : NSData! = NSData(contentsOf: url)
                print("end download")
                if data != nil { //判断data不为空，这里是因为swift对类型要求很严，如果未空的话，会崩溃
                    DispatchQueue.main.sync {
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
    
}

