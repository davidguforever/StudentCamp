//
//  UIStoryboard+Gfin.swift
//  Gfintech
//
//  Created by Luochun on 2017/2/12.
//  Copyright © 2017年 Mantis. All rights reserved.
//

import UIKit


public extension UIStoryboard {
    
    static var main: UIStoryboard {
        return UIStoryboard(name: "Main", bundle: nil)
    }    

    static var login: UIStoryboard {
        return UIStoryboard(name: "Login", bundle: nil)
    }

    public struct Scene {
        static var home: HomeViewController {
            return UIStoryboard.main.instantiateVC(HomeViewController.self)!
        }
        
        static var index: IndexViewController {
            return UIStoryboard.main.instantiateVC(IndexViewController.self)!
        }
        
        // 日程
        static var schedule: ScheduleViewController {
            return UIStoryboard.main.instantiateVC(ScheduleViewController.self)!
        }
        
        static var share: ShareIndexViewController {
            return UIStoryboard.main.instantiateVC(ShareIndexViewController.self)!
        }

        
        static var mine: ProfileViewController {
            return UIStoryboard.main.instantiateVC(ProfileViewController.self)!
        }

        
        // MARK: - 分组
        static var grouping: GroupingViewController {
            return UIStoryboard(name: "Group", bundle: nil).instantiateVC(GroupingViewController.self)!
        }
        static var setGroup: SetGroupViewController {
            return UIStoryboard(name: "Group", bundle: nil).instantiateVC(SetGroupViewController.self)!
        }
        /// 我的分组信息
        static var myGroup: MyGroupInfoViewController {
            return UIStoryboard(name: "Group", bundle: nil).instantiateVC(MyGroupInfoViewController.self)!
        }
        
        // MARK: - 报名
        /// 设置报名信息
        static var setApply: SetApplyingViewController {
            return UIStoryboard(name: "Apply", bundle: nil).instantiateVC(SetApplyingViewController.self)!
        }
        static var teacherApply: TeacherApplyingViewController {
            return UIStoryboard(name: "Apply", bundle: nil).instantiateVC(TeacherApplyingViewController.self)!
        }
        /// 列表
        static var applyNumbers: ApplyNumbersViewController {
            return UIStoryboard(name: "Apply", bundle: nil).instantiateVC(ApplyNumbersViewController.self)!
        }
        /// 报名
        static var review: ReviewStuViewController {
            return UIStoryboard(name: "Apply", bundle: nil).instantiateVC(ReviewStuViewController.self)!
        }
        
        
        // MARK: - 签到
        /// 签到缺席人员
        static var signNumbers: Sign_InfoViewController {
            return UIStoryboard(name: "Sign", bundle: nil).instantiateVC(Sign_InfoViewController.self)!
        }

        
        // MARK: - 答辩
        /// 设置答辩信息
        static var setReply: SetReplyViewController {
            return UIStoryboard(name: "Reply", bundle: nil).instantiateVC(SetReplyViewController.self)!
        }
        /// 当前答辩顺序
        static var replyInfo: ReplyInfoViewController {
            return UIStoryboard(name: "Reply", bundle: nil).instantiateVC(ReplyInfoViewController.self)!
        }
        

        // MARK: - Setting

        static var login: LoginViewController {
            return UIStoryboard.login.instantiateVC(LoginViewController.self)!
        }

        
        /// 设置密码
        static var bindPwd: BindPwdViewController {
            return UIStoryboard.login.instantiateVC(BindPwdViewController.self)!
        }
        
        
        

        
    }
    
}

public extension UIStoryboard {
    
    /// Get view controller from storyboard by its class type
    ///
    ///         let profileVC = storyboard!.instantiateVC(ProfileViewController) /* profileVC is of type ProfileViewController */
    ///
    /// Warning: identifier should match storyboard ID in storyboard of identifier class
    func instantiateVC<T>(_ identifier: T.Type) -> T? {
        let storyboardID = String(describing: identifier)
        if let vc = instantiateViewController(withIdentifier: storyboardID) as? T {
            return vc
        } else {
            return nil
        }
    }
    
    /// Get view controller from storyboard by its class type
    ///
    ///         let profileVC = storyboard!.instantiateVC(ProfileViewController) /* profileVC is of type ProfileViewController */
    ///
    func instantiate<T: UIViewController>(controller: T.Type) -> T
        where T: Identifiable {
            return instantiateViewController(withIdentifier: T.identifier) as! T
    }
    
}


public protocol Identifiable {
    
    static var identifier: String { get }
}

public extension Identifiable {
    
    static var identifier: String {
        return String(describing: self)
    }
}
