//
//  ProfileViewController.swift
//  MovelRater
//
//  Created by Luochun on 2019/4/18.
//  Copyright © 2019 Mantis group. All rights reserved.
//

import UIKit

private let titles: [String] = [ "权限变更", "修改密码"]

class ProfileViewController: MTBaseViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        
//        nameLabel.text = "Name: "
//        ageLabel.text = "Age: "
        
        if let user = UserDefaults(suiteName: groupShare)?.dictionary(forKey: kUserInfo) {
            if let v =  user["username"] as? String {
                nameLabel.text =  v
            }
            
            ageLabel.text = User.shared.role.des

        }
    }
    
    @IBOutlet weak var topImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
        
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor  = .white
        
        //topImageView.kf.setImage(with: URL(string: aaa))
        
        //table.tableHeaderView?.height = 200
    }
    
    
    @IBAction func signout() {
        AppDelegate.shared.signout()
        
    }
    
}

extension ProfileViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            let vc = self.storyboard?.instantiateVC(ChangeViewController.self)
            vc?.hidesBottomBarWhenPushed  = true
            self.navigationController?.pushViewController(vc!, animated: true)
        case 1:
            let vc = self.storyboard?.instantiateVC(ChangePwdViewController.self)
            vc?.hidesBottomBarWhenPushed  = true
            self.navigationController?.pushViewController(vc!, animated: true)
        default:
            print("")
        }
    }
}


extension ProfileViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.textColor = MTColor.main
        
        cell.textLabel?.text = titles[indexPath.row]
        
        return cell
        
    }
    
}
