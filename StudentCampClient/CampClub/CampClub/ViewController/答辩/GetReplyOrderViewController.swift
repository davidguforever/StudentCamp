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
