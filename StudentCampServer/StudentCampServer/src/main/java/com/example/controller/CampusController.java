package com.example.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.Dao.CampusDao;
import com.example.Dao.UserDao;
import com.example.model.CampusSchool;
import com.example.model.CampusManager;
import com.example.model.CampusStudent;

@RestController
public class CampusController {
	@Autowired
	private CampusDao campusDao;
	
	//查询报名相关信息  管理者 学生 教师 用
	@RequestMapping(value="/queryCampusManager")	
	public Map<String, Object> queryCampusMsg() {
		try {
			return campusDao.queryCampusMsg();
		}catch (DataAccessException e){
			campusDao.SetError();
			campusDao.responseBody.put("errorMessage", "查询失败");
            return campusDao.responseBody;
        }
	}
	//开始报名
	@RequestMapping(value="/SetCampusManager")
	public Map<String, Object> BeginEnter(String totalNum, String schoolNum,String deadLine) {
		try {
			return campusDao.BeginEnter(totalNum,schoolNum,deadLine);
		}catch (DataAccessException e){
			campusDao.SetError();
			//campusDao.responseBody.put("errorMessage", e);
			campusDao.responseBody.put("errorMessage", "操作失败");
            return campusDao.responseBody;
        }
	}
	
	//查询教师设置相关信息  指定教师用
	@RequestMapping(value="/queryCampusSchool")	
	public Map<String, Object> queryCampusTecMsg(String teacherId) {
		try {
			return campusDao.queryCampusTecMsg(teacherId);
		}catch (DataAccessException e){
			campusDao.SetError();
			
			campusDao.responseBody.put("errorMessage", "查询失败");
	        return campusDao.responseBody;
	    }
	}
	
	//教师设置报名信息
	@RequestMapping(value="/SetCampusSchool")
	public Map<String, Object> SetCampusTeacher(String stuSchool,String stuNum, String teacherId) {
		try {
			return campusDao.SetCampusTeacher(stuSchool,stuNum,teacherId);
		}catch (DataAccessException e){
			campusDao.SetError();
			//campusDao.responseBody.put("errorMessage", e);
			campusDao.responseBody.put("errorMessage", "操作失败");
            return campusDao.responseBody;
        }
	}
	
	//学生报名查询  
	@RequestMapping(value="/queryCampusStudent")	
	public Map<String, Object> queryCampusStudent(String userName) {
		try {
			return campusDao.queryCampusStuMsg(userName);
		}catch (DataAccessException e){
			campusDao.SetError();
			campusDao.responseBody.put("errorMessage", "查询失败");
	        return campusDao.responseBody;
	    }
	}
	
	//学生设置   要维护tmpNum
	//http://127.0.0.1:8080/SetCampusStudent?stuName=瓜子&stuSex=男&stuGrade=大二&stuSchool=吉林大学&stuTel=18514312598&stuHobby=动作游戏&stuMail=834335219@qq.com&stuClub=吉林大学&userName=stu12
	@RequestMapping(value="/SetCampusStudent")	
	public Map<String, Object> SetCampusTeacher(String stuName, String stuSex,  String stuGrade, 
			String stuSchool,  String stuTel,  String stuHobby,  String stuMail
			,  String stuClub,  String userName) {
		try {
			return campusDao.SetCampusStudent(stuName,stuSex,stuGrade,stuSchool,stuTel,stuHobby,stuMail,stuClub,userName);
		}catch (DataAccessException e){
			campusDao.SetError();
			//campusDao.responseBody.put("errorMessage", e);
			campusDao.responseBody.put("errorMessage", "操作失败");
	        return campusDao.responseBody;
	    }
	}
	//管理者 查询 返回所有学校的报名情况
	@RequestMapping(value="/queryInfoManager")	
	public Map<String, Object> queryInfoManager() {
		try {
			return campusDao.queryInfoManger();
		}catch (DataAccessException e){
			campusDao.SetError();
			//campusDao.responseBody.put("errorMessage", e);
			campusDao.responseBody.put("errorMessage", "查询失败");
	        return campusDao.responseBody;
	    }
	}
	//教师   查询  返回对应学校的所有报名信息
	@RequestMapping(value="/queryInfoTeacher")	
	public Map<String, Object> queryInfoTeacher(String teacherId) {
		try {
			return campusDao.queryInfoTeacher(teacherId);
		}catch (DataAccessException e){
			campusDao.SetError();
			//campusDao.responseBody.put("errorMessage", e);
			campusDao.responseBody.put("errorMessage", "查询失败");
	        return campusDao.responseBody;
	    }
	}
	//学生   查询  返回对应学生的 isCheck
	@RequestMapping(value="/queryInfoStudent")	
	public Map<String, Object> queryInfoStudent(String userName) {
		try {
			return campusDao.queryInfoStudent(userName);
		}catch (DataAccessException e){
			campusDao.SetError();
			campusDao.responseBody.put("errorMessage", "查询失败");
	        return campusDao.responseBody;
	    }
	}
	//报名是否开始
	@RequestMapping(value="/queryIsBeginEnter")	
	public Map<String, Object> queryIsBeginEnter() {
		try {
			return campusDao.queryIsBeginEnter();
		}catch (DataAccessException e){
			campusDao.SetError();
			campusDao.responseBody.put("errorMessage", "查询失败");
	        return campusDao.responseBody;
	    }
	}
	//查询报名截止日期
	@RequestMapping(value="/queryCampusDeadLine")	
	public Map<String, Object> queryCampusDeadLine() {
		try {
			return campusDao.queryCampusDeadLine();
		}catch (DataAccessException e){
			campusDao.SetError();
			campusDao.responseBody.put("errorMessage", "查询失败");
	        return campusDao.responseBody;
	    }
	}
	//审核学生报名
	@RequestMapping(value="/confirmCampusStudent")	
	public Map<String, Object> confirmCampusStudent(String userName) {
		try {
			return campusDao.confirmCampusStudent(userName);
		}catch (DataAccessException e){
			campusDao.SetError();
			campusDao.responseBody.put("errorMessage", "审核失败");
	        return campusDao.responseBody;
	    }
	}
}


