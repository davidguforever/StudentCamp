//
//  ShareIndexViewController.swift
//  CampClub
//
//  Created by Luochun on 2019/4/25.
//  Copyright © 2019 Mantis group. All rights reserved.
//

import UIKit

class ShareIndexViewController: MTBaseViewController {
    var shareInfos: [JSONMap] = []
    
    
    
    @IBOutlet weak var table: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "心得分享"
        //addNavigationBarRightButton(self, action: #selector(add), image: UIImage(named: "add")!)
        
        table.addRefresh(self.className, autoRefresh: false, headerRefresh: {
            self.getAll()
        }, footerLoader: nil)

        getAll()
    }
    
    func getAll() {
        //MTHUD.showLoading()
        HttpApi.queryAll { (res, err) in
            self.table.es.stopPullToRefresh()
            
            if let r = res, let list = r["list"] as? [JSONMap] {
                self.shareInfos = list
                self.table.reloadData()
            } else {
                showMessage(err)
            }
        }
    }

    @objc func add() {
        let vc = self.storyboard?.instantiateVC(AddShareViewController.self)
        vc?.hidesBottomBarWhenPushed = true
        pushVC(vc!)
    }
}


extension ShareIndexViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let path  = shareInfos[indexPath.row]["content"] as? String {
            let vc = WebViewController(URL(string: path)!)
            vc.hidesBottomBarWhenPushed = true
            pushVC(vc)
        }
    }
}


extension ShareIndexViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.width, height: 10.0))
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shareInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShareCell") as! ShareCell
        cell.info = shareInfos[indexPath.row]
        
        return cell
        
    }
    
}


class ShareCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textDesLabel: UILabel!
    
    @IBOutlet weak var coverImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var info: JSONMap? {
        didSet {
            if let m = info {
                nameLabel.text = m["username"] as? String
                timeLabel.text = m["createTime"] as? String
                titleLabel.text = m["title"] as? String
                textDesLabel.text = m["content"] as? String
                if let role = m["type_id"] as? String {
                    if role == "3" {
                        coverImageView.image = UIImage(named: "manager_")
                    }else  if role == "2" {
                        coverImageView.image = UIImage(named: "teacher_")
                    }else  if role == "1" {
                        coverImageView.image = UIImage(named: "学生")
                    }
                }
            }
        }
    }
    
    
}
