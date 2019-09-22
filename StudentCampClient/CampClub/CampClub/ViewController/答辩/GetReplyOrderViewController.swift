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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //添加主题监控
        addThemeObserver()
        //设置导航栏标题
        title = "答辩顺序"
        addNavigationBarLeftButton(self)
        //初始化转盘
        awardDiskView.setup(text: ["1","2","1","2","1","2","1","2","1","2","1","2","1","8","9"])
        //设置开始抽签按钮颜色
        startButton.backgroundColor = MTTheme.getButtonColor()
        //tableViewx初始化
        listTable.delegate = self
        listTable.dataSource = self
    }
    //开始抽签
    @IBAction func startDrawingStraws(_ sender: Any) {
            awardDiskView.startRotate(rotateAngle: CGFloat(Double.pi*6+angle*3))
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=listTable.dequeueReusableCell(withIdentifier: "listCell")! as! ListableViewCell
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.textColor = UIColor.black
        //cell左边的文字：自带的
        cell.textLabel?.text = String(indexPath.row+1)+":"
        //cell中间的文字
        cell.listLabel.text = "第"+String(indexPath.row+1)+"组"
        
        return cell
        
    }
}
