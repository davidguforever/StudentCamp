//
//  GetReplyOrderViewController.swift
//  CampClub
//
//  Created by HP on 2019/9/5.
//  Copyright © 2019 Mantis group. All rights reserved.
//

import UIKit

class GetReplyOrderViewController: MTBaseViewController {

    

    @IBOutlet weak var awardDiskView: AwardDisk!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var clearAllButton: UIButton!
    @IBOutlet weak var listTable: UITableView!
    
    //var groupTextList = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"]
    var groupTextList = ["1","2"]
    var groupOrder:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //添加主题监控
        addThemeObserver()
        //设置导航栏标题
        title = "答辩顺序"
        addNavigationBarLeftButton(self)
        //初始化转盘
        //awardDiskView.setup(text:groupTextList)
        //设置开始抽签按钮颜色
        startButton.backgroundColor = MTTheme.getButtonColor()
        //tableViewx初始化
        listTable.delegate = self
        listTable.dataSource = self
        
        //从网络上获取groupTextList和groupOrder
        initGroupOrder()
        initGroupTextList()

        //设置按钮
        startButton.setTitle("抽签完成", for: UIControl.State.disabled)
        if(groupTextList.count<2){
            startButton.isEnabled = false
        }

    }

    func initGroupOrder(){
        MTHUD.showLoading()
        HttpApi.queryDrawlots( { (res, err) in
            MTHUD.hide()
            if let r = res, let list = r["list"]  as? JSONMap {
                let drawlist=list["drawlist"] as! String
                if(drawlist != ""){
                    self.groupOrder = drawlist.components(separatedBy: ",")
                    self.listTable.reloadData()
                    self.startButton.isEnabled = false
                }else{
                    self.groupOrder.removeAll()
                }
                print(self.groupOrder)
                
            } else {
                showMessage(err)
            }
        })
    }
    func initGroupTextList(){
        MTHUD.showLoading()
        HttpApi.queryGroupMsg( { (res, err) in
            MTHUD.hide()
            if let r = res, let list = r["list"] as? JSONMap {
                    if let groupNum  = list["groupNum"] as? String{
                        self.groupTextList.removeAll()
                        let num=Int(groupNum)!
                        for num in 1...num{
                            self.groupTextList.append(String(num))
                        }
                        self.awardDiskView.setup(text: self.groupTextList)
                    }else{
                        print("??")
                    }
            }else {
                showMessage(err)
                
            }
        })
    
    }
    //清除所有
    @IBAction func clearAll(_ sender: UIButton) {
        
        let alertController=UIAlertController.init(title:"清除所有", message: "这也将清除数据库里的抽签顺序", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "好的", style: UIAlertAction.Style.default,
                                     handler: {
                                        action in
                                        self.initGroupTextList()
                                        self.groupOrder.removeAll()
                                        self.listTable.reloadData()
                                        if(self.groupTextList.count>1){
                                            self.startButton.isEnabled = true
                                        }
                                        //清空数据库
                                        self.saveToServer()
                                        
        })
        let cencelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.default,
                                     handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cencelAction)
        self.present(alertController, animated: false, completion: nil)
        

    }
    //全局变量，控制抽中的是第几个
    var groupNum:Int = 0
    //开始抽签
    @IBAction func startDrawingStraws(_ sender: Any) {

        
        groupNum = Int(arc4random())%groupTextList.count
        
        print("随机数："+String(groupNum))
        awardDiskView?.startRotate(finishnum:groupNum,completefunc:DrawingStrawsStop)
        
    }
    
    
    
    func DrawingStrawsStop(){

        
        
        let alertController=UIAlertController.init(title:"抽签结果", message: "抽中组:第"+groupTextList[groupNum]+"组", preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "好的", style: UIAlertAction.Style.default,
                                     handler: {
                                        action in
                                        self.groupOrder.append(self.groupTextList[self.groupNum])
                                        self.groupTextList.remove(at: self.groupNum)
                                        print("完成")
                                        

                                        if(self.groupTextList.count>1){
                                            //初始化转盘
                                            self.awardDiskView.setup(text:self.groupTextList)
                                        }
                                        else{
                                            //抽签完成
                                            self.startButton.isEnabled = false
                                            self.groupOrder.append(self.groupTextList[0])
                                            self.groupTextList.remove(at: 0)
                                            self.saveToServer()

                                        }
                                        //刷新列表
                                        self.listTable.reloadData()

        })
        alertController.addAction(okAction)
        self.present(alertController, animated: false, completion: nil)
        

    }
    
    func saveToServer(){
        HttpApi.setDrawlots(drawlist: String(groupOrder.joined(separator: ",")), handle: {(res,err) in
            MTHUD.hide()
            if let _ = res {
                showMessage("保存到服务器成功")
                //self.navigationController?.popViewController(animated: true)
            } else {
                showMessage(err)
            }
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GetReplyOrderViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=listTable.dequeueReusableCell(withIdentifier: "listCell")! as! ListableViewCell
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.textColor = UIColor.black
        //cell左边的文字：自带的
        cell.textLabel?.text = String(indexPath.row+1)+":"
        //cell中间的文字
        cell.listLabel.text = "第"+groupOrder[indexPath.row]+"组"
        
        return cell
        
    }
}
