//
//  GroupingViewController.swift
//  CampClub
//
//  Created by Luochun on 2019/5/3.
//  Copyright © 2019 Mantis group. All rights reserved.
//

import UIKit
import MTCobwebs

class GroupingViewController: MTBaseViewController {

    var dragger: TableViewDragger!
    @IBOutlet weak var tableView: UITableView!
    
    var students: [Int : [JSONMap]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title  = "分组情况"
        addNavigationBarLeftButton(self)
        
        if User.shared.role == .manager {
            dragger = TableViewDragger(tableView: tableView)
            dragger.availableHorizontalScroll = true
            dragger.dataSource = self
            dragger.delegate = self
            dragger.alphaForCell = 0.7
            
        } else {
            tableView.tableHeaderView?.height = 0
        }
        
        switch User.shared.role {
        case .manager:
            HttpApi.queryGroupManager { (res, err) in
                if let list = res?["list"] as? [JSONMap] {
                    self.students = Dictionary(grouping: list, by: {Int($0["groupId"] as! String)!})
                    self.tableView.reloadData()
                } else {
                    showMessage(err)
                }
            }
        case .teacher:
            HttpApi.queryGroupTeacher( User.shared.id) { (res, err) in
                if let list = res?["list"] as? [JSONMap] {
                    self.students = Dictionary(grouping: list, by: {Int($0["groupId"] as! String)!})
                    self.tableView.reloadData()
                } else {
                    showMessage(err)
                }
            }
        case .student:
            HttpApi.queryGroupStudent(User.shared.userName!) { (res, err) in
                if let list = res?["list"] as? [JSONMap] {
                    self.students = Dictionary(grouping: list, by: {Int($0["groupId"] as! String)!})
                    self.tableView.reloadData()
                } else {
                    showMessage(err)
                }
            }
        }

    }
    
    
    @IBAction func retoSet() {
        MTHUD.showLoading()
        HttpApi.resetDivide { (res, err) in
            MTHUD.hide()
            
            if let _ = res {
                showMessage("设置成功")
                delay(1, work: {
                    self.popVC()
                })
            } else {
                showMessage(err)
            }
        }
    }

    @IBAction func confirmGroup() {
        MTHUD.showLoading()
        HttpApi.confirmGroup { (res, err) in
            MTHUD.hide()
            
            if let _ = res {
                showMessage("确认成功")
                delay(1, work: {
                    self.popVC()
                })
            } else {
                showMessage(err)
            }
        }
    }
    
    var groups: [Int] {
        get {
            return Array(students.keys).sorted(by: <)
        }
    }
    
    
    var key: Int = 0
    var newKey: Int = 0
    var item: JSONMap = [:]
}

extension GroupingViewController: TableViewDraggerDataSource, TableViewDraggerDelegate {
    func dragger(_ dragger: TableViewDragger, moveDraggingAt indexPath: IndexPath, newIndexPath: IndexPath) -> Bool {
        key = groups[indexPath.section]
        newKey = groups[newIndexPath.section]
        item = students[key]![indexPath.row]
        
        self.students[key]!.remove(at: indexPath.row)
        self.students[newKey]!.insert(item, at: newIndexPath.row)
        self.tableView.moveRow(at: indexPath, to: newIndexPath)
        
        return true
    }
    
    func dragger(_ dragger: TableViewDragger, didEndDraggingAt indexPath: IndexPath) {
        guard item.count > 0 , newKey > 0 else {return}
        HttpApi.adjustGroup(item["userName"] as! String, groupId: String(newKey)) { (res, err) in
            if let _ = res {
                
            } else {
                showMessage(err)
            }
        }
    }
}

extension GroupingViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}


extension GroupingViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: tableView.width, height: 30.0))
        view.backgroundColor = .clear
        
        let groupLabel = UILabel(frame: CGRect(x: 20, y: 0, width: 300, height: 30))
        groupLabel.textColor = MTColor.main
        groupLabel.font = UIFont.systemFont(ofSize: 14)
        let key = groups[section]
        groupLabel.text = "\(key)组"
        view.addSubview(groupLabel)
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students[groups[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupStuCell") as! GroupStuCell
        
        let key = groups[indexPath.section]
        cell.setInfo(students[key]![indexPath.row])
        
        return cell
    }
}

class GroupStuCell: UITableViewCell {
    
    @IBOutlet weak var coverImgView: UIImageView!
    @IBOutlet weak var stuNameLabel: UILabel!
    
    
    func setInfo(_ info: JSONMap) {

        if let v = info["stuName"] as? String {
            coverImgView.image = UIImage(named: "学生")
            stuNameLabel.text = v
        }
    }
}
