//
//  HttpApi.swift
//  CampClub
//
//  Created by Luochun on 2019/4/25.
//  Copyright © 2019 Mantis group. All rights reserved.
//

import Foundation
import Alamofire

struct HttpApi {
    static func login(_ username: String, pwd: String, handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "login", method: .post ,parameters:["userName": username, "password": pwd]).responseJSON { (dataRequest) in
            if let JSON = dataRequest.result.value  as? JSONMap {
                print(JSON)
                if let result = JSON["result"] as? String, result == "SUCCESS" {
                    handle(JSON["list"] as? JSONMap, nil)
                } else {
                    handle(nil , JSON["errorMessage"] as? String)
                }
            } else {
                handle(nil , dataRequest.description)
            }
        }
    }
    
    static func register(_ username: String, pwd: String, type: Int, handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "register", method: .post ,parameters:["userName": username, "password": pwd, "typeId": type]).responseJSON { (dataRequest) in
            if let JSON = dataRequest.result.value as? JSONMap {
                
                print(JSON)
                if let result = JSON["result"] as? String, result == "SUCCESS" {
                    handle(JSON["list"] as? JSONMap, nil)
                } else {
                    handle(nil , JSON["errorMessage"] as? String)
                }
            } else {
                handle(nil , dataRequest.description)
            }

        }
    }

    
    /// //拿到当前剩余人数
    static func getEnterNow(_  handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "getEnterNow", method: .post ,parameters:nil).responseJSON { (dataRequest) in
            if let JSON = dataRequest.result.value as? JSONMap {
                
                print(JSON)
                if let result = JSON["result"] as? String, result == "SUCCESS" {
                    handle(JSON, nil)
                } else {
                    handle(nil , JSON["errorMessage"] as? String)
                }
                
            }
        }
    }
    
    /// //返回各个大学 的对应审核通过报名人数
    static func queryStuAll(_ username: String, pwd: String, handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "queryStuAll", method: .post ,parameters:["user": username, "password": pwd]).responseJSON { (dataRequest) in
            if let JSON = dataRequest.result.value as? JSONMap {
                
                print(JSON)
                if let result = JSON["result"] as? String, result == "SUCCESS" {
                    handle(JSON, nil)
                } else {
                    handle(nil , JSON["errorMessage"] as? String)
                }
            } else {
                handle(nil , dataRequest.description)
            }

        }
    }
    
    /// 返回 对应大学 的所有报名同学 名单
    static func queryStuBySchool(_ university: String, handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "queryStuBySchool", method: .post ,parameters:["university": university]).responseJSON { (dataRequest) in
            if let JSON = dataRequest.result.value as? JSONMap {
                
                print(JSON)
                if let result = JSON["result"] as? String, result == "SUCCESS" {
                    handle(JSON, nil)
                } else {
                    handle(nil , JSON["errorMessage"] as? String)
                }
            } else {
                handle(nil , dataRequest.description)
            }

        }
    }
    
    /// //传入 学生大学 学生姓名
    //// //返回学生报名相关信息
    static func queryStuBystuName(_ university: String, StuName: String, handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "queryStuBystuName", method: .post ,parameters:["university": university, "StuName": StuName]).responseJSON { (dataRequest) in
            if let JSON = dataRequest.result.value as? JSONMap {
                
                print(JSON)
                if let result = JSON["result"] as? String, result == "SUCCESS" {
                    handle(JSON, nil)
                } else {
                    handle(nil , JSON["errorMessage"] as? String)
                }
            } else {
                handle(nil , dataRequest.description)
            }

        }
    }
    
    /////审核学生报名 传入学生大学 学生姓名
    //返回成功或者失败
    static func confirmStuEnter(_ university: String, Name: String, handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "confirmStuEnter", method: .post ,parameters:["university": university, "Name": Name]).responseJSON { (dataRequest) in
            if let JSON = dataRequest.result.value as? JSONMap {
                
                print(JSON)
                if let result = JSON["result"] as? String, result == "SUCCESS" {
                    handle(JSON, nil)
                } else {
                    handle(nil , JSON["errorMessage"] as? String)
                }
            } else {
                handle(nil , dataRequest.description)
            }

        }
    }
    
    /// 管理员 查询 报名信息
    static func queryCampusManager(_ handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "queryCampusManager", method: .post ,parameters:nil).responseJSON { (dataRequest) in
            if let JSON = dataRequest.result.value as? JSONMap {
                
                print(JSON)
                if let result = JSON["result"] as? String, result == "SUCCESS" {
                    handle(JSON, nil)
                } else {
                    handle(nil , JSON["errorMessage"] as? String)
                }
            } else {
                handle(nil , dataRequest.description)
            }

        }
    }
    
    /// 管理员 - 报名
    static func SetCampusManager(_ totalNum: String, schoolNum: String, dataTime: String, handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "SetCampusManager", method: .post ,
                          parameters:["totalNum": totalNum, "schoolNum": schoolNum, "deadLine": dataTime])
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }

        }
    }
    
    /// 教师 查询 报名信息
    static func queryCampusSchool(_ teacherId: String, handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "queryCampusSchool", method: .post ,
                          parameters:["teacherId": teacherId])
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }

        }
    }
    
    /// 教师 - 报名
    static func SetCampusSchool(_ stuNum: String, stuSchool: String, teacherId: String, handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "SetCampusSchool", method: .post ,
                          parameters:["stuNum": stuNum, "stuSchool": stuSchool, "teacherId": teacherId])
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }

        }
    }
    
    ///学生报名
    /// string stuName,String stuSex,String stuGrade,String univerSity,String Tel,String hobby,String mail,String Club
    static func SetCampusStudent(_ param: JSONMap, handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "SetCampusStudent", method: .post ,parameters: param).responseJSON { (dataRequest) in
            if let JSON = dataRequest.result.value as? JSONMap {
                
                print(JSON)
                if let result = JSON["result"] as? String, result == "SUCCESS" {
                    handle(JSON, nil)
                } else {
                    handle(nil , JSON["errorMessage"] as? String)
                }
            } else {
                handle(nil , dataRequest.description)
            }

        }
    }
    
    
    /// //学生 查询 报名信息
    static func queryCampusStudent(_ userName: String, handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "queryCampusStudent", method: .post ,  parameters:["userName": userName])
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }
        }
    }
    
    /// 管理者 查询 报名情况
    /// 返回 学校 - 人数 list
    static func queryInfoManager(_ handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "queryInfoManager", method: .post ,
                          parameters: nil)
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }

        }
    }
    
    
    /// //教师 查询 报名情况
    /// //返回 对应学校的 Campus_student list
    static func queryInfoTeacher(_ teacherId: String, handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "queryInfoTeacher", method: .post ,
                          parameters: ["teacherId": teacherId])
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }

        }
    }
    
    
    /// 学生 查询 报名情况 [返回 list 0 为未审核  1为审核]
    static func queryInfoStudent(_ userName: String, handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "queryInfoStudent", method: .post ,
                          parameters: ["userName": userName])
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }

        }
    }
    
    
    /// //查询报名 是否开始 [返回 isBegin 0为 未开始  1为开始]
    static func queryIsBeginEnter(_ handle: @escaping ((_ isBegin: String?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "queryIsBeginEnter", method: .post ,
                          parameters: nil)
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON["list"] as? String, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }

        }
    }
    
    
    /// ////查询报名截止日期 [返回 data DeadLine]
    static func queryCampusDeadLine(_ handle: @escaping ((_ date: String?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "queryCampusDeadLine", method: .post ,
                          parameters: nil)
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON["list"] as? String, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }

        }
    }
    
    /// 审核学生报名
    static func confirmCampusStudent(_ userName: String, handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "confirmCampusStudent", method: .post ,
                          parameters: ["userName": userName])
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }

        }
    }
    
    /// //管理员 开始签到
    static func beginSignIn(_ date: String, longitude: Float, latitude: Float, handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "beginSignIn", method: .post ,
                          parameters: ["date": date, "longitude": String(longitude), "latitude": String(latitude)])
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }
                
        }
    }
    /// //管理员  结束签到
    static func endSignIn(_ date: String, handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "endSignIn", method: .post ,
                          parameters: ["date": date])
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }
                
        }
    }
    
    /// 管理员 查询对应日期学生出席情况        //未出席的学生list 格式为 学校 - 人数
    static func querySignInManager(_ date: String, handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "querySignInManager", method: .post ,
                          parameters: ["date": date])
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }
                
        }
    }
    
    //教师 开始签到
    //弹出提示 没有权限
    
    
    /// //教师 查询对应日期学生出席情况   //未出席的学生list 格式为 学生姓名 list
    static func querySignInTeacher(_ date: String, teacher: String, handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "querySignInTeacher", method: .post ,
                          parameters: ["date": date, "teacherId": teacher])
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }
                
        }
    }
    
    /////学生 签到
    static func signIn(_ date: String , userName: String,  handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "signIn", method: .post ,
                          parameters: ["date": date, "userName": userName])
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }
                
        }
    }
    
    
    /// 学生 查询对应日期出席情况 //返回提示信息  出席 或 缺席
    static func querySignInStudent(_ date: String, handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "querySignInStudent", method: .post ,
                          parameters: ["date": date])
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }
                
        }
    }
    
    
    /// 学生 - 查询对应日期出席情况
    static func querySignInStudentByDate(_ date: String, userName: String, handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "querySignInStudentByDate", method: .post ,
                          parameters: ["date": date, "userName": userName])
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }
                
        }
    }
    
    /// //学生 查询当日签到信息  //返回提示信息  当日为开始签到或 list {data isBegin longitude latitude}提示信息
    static func querySignInMsg(_ date: String, handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "querySignInMsg", method: .post , parameters: ["date": date])
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }
                
        }
    }
    
}



extension HttpApi {
    
    // MARK: - 答辩
    
    /// 组织者-设置答辩
    static func setDrawlots(_ turnnum: String, singlenum: String, drawlist: String,
                            handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "setDrawlots", method: .post ,
                          parameters: ["turnnum": turnnum, "singlenum": singlenum, "drawlist": drawlist])
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }
        }
    }
    
    /// 组织者-查询当前答辩信息
    static func queryDrawlots(_ handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "queryDrawlots", method: .post ,
                          parameters: nil)
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }
        }
    }
    
    
    
    /// 组织者，教师，学生 - 拿到当前答辩顺序
    static func getTempTurn(_ handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "getTempTurn", method: .post ,
                          parameters: nil)
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }
        }
    }
    
    
    /// 组织者-下一轮(更新tmpTurn)
    static func nextTurn(_ handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "nextTurn", method: .post ,
                          parameters: nil)
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }
        }
    }
}


extension HttpApi {
    
    // MARK: - 心得
    
    /// 发布心得
    static func contentAdd(_ username: String, title: String, content: String,
                            handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "contentAdd", method: .post ,
                          parameters: ["username": username, "title": title, "content": content])
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }
        }
    }
    
    /// 查询心得详细内容
    static func contentDetail(_ contentId: String, handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "contentDetail", method: .post ,
                          parameters: ["contentId": contentId])
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }
        }
    }
    
    
    
    /// 查询所有心得
    static func queryAll(_ handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "queryAll", method: .post ,
                          parameters: nil)
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }
        }
    }
    
    
    /// 删除心得
    static func contentDelete(_  contentId: String, handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "contentDelete", method: .post ,
                          parameters: ["contentId": contentId])
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }
        }
    }
}


extension HttpApi {
    // MARK: - 分组
    
    /// 设置分组信息-管理者
    static func setGroupMsg(_ groupNum: String, groupStuNum: String, stuSex: Int, stuGrade: Int, stuSchool: Int, stuHobby: Int,
                            handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "setGroupMsg", method: .post ,
                          parameters: ["groupNum": groupNum, "groupStuNum": groupStuNum, "stuSex": stuSex, "stuGrade": stuGrade,
                                       "stuSchool": stuSchool, "stuHobby": stuHobby])
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }
        }
    }

    
    /// 查看分组信息-管理者
    static func queryGroupMsg(_  handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "queryGroupMsg", method: .post ,
                          parameters: nil)
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }
        }
    }
    
    /// 查询当前学生总人数-管理者
    static func queryTotalNum(_  handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "queryTotalNum", method: .post ,
                          parameters: nil)
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }
        }
    }
    
    
    
    /// 确认分组-管理者
    static func confirmGroup(_  handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "confirmGroup", method: .post ,
                          parameters: nil)
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }
        }
    }
    
    
    /// 分组-管理者
    static func divide(_  handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "divide", method: .post ,
                          parameters: nil)
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }
        }
    }
    
    
    /// 查看分组信息-管理员
    static func queryGroupManager(_  handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "queryGroupManager", method: .post ,
                          parameters: nil)
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }
        }
    }
    
    /// 查看分组信息-教师
    static func queryGroupTeacher(_ teacherId: String,  handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "queryGroupTeacher", method: .post ,
                          parameters: ["teacherId": teacherId])
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }
        }
    }
    
    
    /// 查看分组信息-学生
    static func queryGroupStudent(_ userName: String,  handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "queryGroupStudent", method: .post ,
                          parameters: ["userName": userName])
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }
        }
    }
    
    /// 重新分组-管理员
    static func resetDivide(_  handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "resetDivide", method: .post ,
                          parameters: nil)
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }
        }
    }
    
    /// 调整分组-管理员
    static func adjustGroup(_ userName: String, groupId: String, handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "adjustGroup", method: .post ,
                          parameters: ["userName": userName, "groupId": groupId])
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }
        }
    }
    
    // MARK: - 权限转移
    static func enchangeType(_ user1Name: String, user2Name: String, handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "enchangeType", method: .post ,
                          parameters: ["user1Name": user1Name, "user2Name": user2Name])
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }
        }
    }
    
    // MARK: - 修改密码
    static func changePwd(_ name: String, pwd: String, handle: @escaping ((_ info: JSONMap?, _ error: String?)->())) {
        Alamofire.request(BaseUrl + "changePassword", method: .post ,
                          parameters: ["userName": name, "newPassword": pwd])
            .responseJSON { (dataRequest) in
                if let JSON = dataRequest.result.value as? JSONMap {
                    
                    print(JSON)
                    if let result = JSON["result"] as? String, result == "SUCCESS" {
                        handle(JSON, nil)
                    } else {
                        handle(nil , JSON["errorMessage"] as? String)
                    }
                } else {
                    handle(nil , dataRequest.description)
                }
        }
    }
    
}


extension HttpApi {
    
    
    // MARK: - 上传图片
    
    /// 上传图片
    ///
    /// - Parameters:
    ///   - imageData: 图片
    ///   - completion: callback
    static func uploadImage(_ imageData: Data, completion :@escaping (_ result: JSONMap) -> ()) {
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "file",fileName: "DateImg.jpg", mimeType: "image/jpg")
        },
                         to:BaseUrl + "uploadImage/")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    print(response.result.value)
                    
                    if let res = response.result.value as? JSONMap {
                        completion(res)
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
                completion(["error": encodingError.localizedDescription])
            }
        }
    }
}

