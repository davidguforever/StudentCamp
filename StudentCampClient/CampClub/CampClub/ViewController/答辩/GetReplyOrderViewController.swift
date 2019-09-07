//
//  GetReplyOrderViewController.swift
//  CampClub
//
//  Created by HP on 2019/9/5.
//  Copyright © 2019 Mantis group. All rights reserved.
//

import UIKit

class GetReplyOrderViewController: MTBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //添加主题监控
        addThemeObserver()
        //设置导航栏标题
        title = "答辩顺序"
        addNavigationBarLeftButton(self)
        //测试扇形
        radius=150
        let adisk=AwardDisk(frame:CGRect(x: view.centerX-radius, y: 20, width: radius*2, height: radius*2))
        view.addSubview(adisk)
        adisk.setup(text: ["1","2","1","2","1","2","1","2","1","2","1","2","1","8","9"])
        adisk.startRotate(rotateAngle: CGFloat(Double.pi*6+angle*3))
        //adisk.setup(text: ["1","2"])
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
