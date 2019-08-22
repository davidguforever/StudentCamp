//
//  ApplyNumbersViewController.swift
//  CampClub
//
//  Created by Luochun on 2019/5/3.
//  Copyright © 2019 Mantis group. All rights reserved.
//

import UIKit

class ApplyNumbersViewController: MTBaseViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var students: [JSONMap] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationBarLeftButton(self)
        
        
        switch User.shared.role {
        case .manager:
            title = "学校报名营员"
            HttpApi.queryInfoManager { (result, error) in
                if let r = result {
                    if let list = r["list"] as? [JSONMap] {
                        self.students = list
                        self.tableView.reloadData()
                    }
                }else {
                    showMessage(error)
                }
            }
        case .teacher:
            title = "报名学生"
            HttpApi.queryInfoTeacher(User.shared.id) { (result, error) in
                if let r = result {
                    if let list = r["list"] as? [JSONMap] {
                        self.students = list
                        self.tableView.reloadData()
                    }
                } else {
                    showMessage(error)
                }
            }
        default:
            break
        }
        
        
        
        

    }
    
}



extension ApplyNumbersViewController : UITableViewDelegate {
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 70
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if User.shared.role == .teacher {
            let vc = UIStoryboard.Scene.review
            vc.student = students[indexPath.row]
            pushVC(vc)
        }
    }
}


extension ApplyNumbersViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.width, height: 10.0))
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentInfoCell") as! StudentInfoCell
        
        cell.setInfo(students[indexPath.row])
        
        return cell
    }
    
}



class StudentInfoCell: UITableViewCell {
    
    @IBOutlet weak var coverImgView: UIImageView!
    @IBOutlet weak var stuNameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    
    
    func setInfo(_ info: JSONMap) {
        if let v = info["tecSchool"] as? String {
            coverImgView.image = UIImage(named: "学校")
            stuNameLabel.text = v
        }
        if let v = info["tecStuNum"] as? String {
            numberLabel.text = v + " 人"
        }
        
        if let v = info["stuName"] as? String {
            coverImgView.image = UIImage(named: "学生")
            stuNameLabel.text = v
            numberLabel.text = ""
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
