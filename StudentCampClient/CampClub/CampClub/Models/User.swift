//
//  User.swift
//  Gfintech
//
//  Created by Luochun on 2017/2/20.
//  Copyright © 2017年 Mantis. All rights reserved.
//

import Foundation


let kUserInfo = "loginedUser"

let groupShare = "group.com.lc.camp"



enum UserRole: String {
    case student = "1"
    case teacher = "2"
    case manager = "3"
    
    static func initWith(value: Int) -> UserRole {
        switch value {
        case 1:
            return .student
        case 2:
            return .teacher
        case 3:
            return .manager
        default:
            return .student
        }
    }
    
    var des: String {
        switch self {
        case .student:
            return "学生"
        case .manager:
            return "组织者"
        case .teacher:
            return "指导教师"
        }
    }
}

public class User {
    private static let _sharedInstance = User()
    
    public static var shared: User {
        return _sharedInstance
    }

    var id: String = ""

    /*用户信息*/
    var userName: String?  /// 用户名
    
    var role: UserRole = .student
    
    /// 登录成功
    func bind(_ source: JSONMap) {
        
        if let userName = source["username"] as? String {
            self.userName = userName
        }
        if let id = source["id"] as? String {
            self.id = id
        }
        if let v = source["typeid"] as? String , let va = Int(v) {
            self.role = UserRole.initWith(value: va)
        }
        
        
        UserDefaults(suiteName: groupShare)?.set(source, forKey: kUserInfo)
 
    }
    

    static func logout() {

        UserDefaults(suiteName: groupShare)?.removeObject(forKey: kUserInfo)
        
        User.shared.userName = nil
        
    }

    
    static var isLogined: Bool {
        if let user :JSONMap = UserDefaults(suiteName: groupShare)?.dictionary(forKey: kUserInfo) {
            if let userName = user["username"] as? String {
                User.shared.userName = userName
            }
            User.shared.bind(user)
            return true
        }
        return false
    }
}
