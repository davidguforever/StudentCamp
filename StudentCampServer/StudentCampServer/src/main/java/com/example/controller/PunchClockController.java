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
import com.example.Dao.PunchClockDao;
import com.example.model.PunchClockManager;
import com.example.model.PunchClockStudent;

@RestController
public class PunchClockController {
	@Autowired
	
	private PunchClockDao punchClockDao;
		
	//查询某日报名信息
	@RequestMapping(value="/querySignInMsg")	
	public Map<String, Object> querySignInMsg(String date) {
		try {
			return punchClockDao.querySignInMsg(date);
		}catch (DataAccessException e){
			punchClockDao.SetError();
			//punchClockDao.responseBody.put("errorMessage", e);
			punchClockDao.responseBody.put("errorMessage", "查询失败");
            return punchClockDao.responseBody;
        }
	}
	//开始签到
	@RequestMapping(value="/beginSignIn")
	public Map<String, Object> beginSignIn(String date, String longitude,String latitude) {
		try {
			return punchClockDao.beginSignIn(date,longitude,latitude);
		}catch (DataAccessException e){
			punchClockDao.SetError();
			punchClockDao.responseBody.put("errorMessage", e);
			//punchClockDao.responseBody.put("errorMessage", "操作失败");
            return punchClockDao.responseBody;
        }
	}
	
	//结束签到
	@RequestMapping(value="/endSignIn")	
	public Map<String, Object> endSignIn(String date) {
		try {
			return punchClockDao.endSignIn(date);
		}catch (DataAccessException e){
			punchClockDao.SetError();
			punchClockDao.responseBody.put("errorMessage", "查询失败");
	        return punchClockDao.responseBody;
	    }
	}
	
	//拿到某日的签到情况
	@RequestMapping(value="/querySignInManager")
	public Map<String, Object> querySignInManager(String date) {
		try {
			return punchClockDao.querySignInManager(date);
		}catch (DataAccessException e){
			punchClockDao.SetError();
			punchClockDao.responseBody.put("errorMessage", e);
			//punchClockDao.responseBody.put("errorMessage", "操作失败");
            return punchClockDao.responseBody;
        }
	}
	
	//拿到详细的情况 学生姓名
	@RequestMapping(value="/querySignInTeacher")	
	public Map<String, Object> querySignInTeacher(String date,String teacherId) {
		try {
			return punchClockDao.querySignInTeacher(date,teacherId);
		}catch (DataAccessException e){
			punchClockDao.SetError();
			punchClockDao.responseBody.put("errorMessage", "查询失败");
	        return punchClockDao.responseBody;
	    }
	}
	
	//学生签到
	//http://127.0.0.1:8080/SetCampusStudent?stuName=瓜子&stuSex=男&stuGrade=大二&stuSchool=吉林大学&stuTel=18514312598&stuHobby=动作游戏&stuMail=834335219@qq.com&stuClub=吉林大学&userName=stu12
	@RequestMapping(value="/signIn")	
	public Map<String, Object> signIn(String date,String userName) {
		try {
			return punchClockDao.signIn(date,userName);
		}catch (DataAccessException e){
			punchClockDao.SetError();
			punchClockDao.responseBody.put("errorMessage", "操作失败");
	        return punchClockDao.responseBody;
	    }
	}
	
	//学生查询自己的出席列表
	@RequestMapping(value="/querySignInStudent")	
	public Map<String, Object> querySignInStudent(String userName) {
		try {
			return punchClockDao.querySignInStudent(userName);
		}catch (DataAccessException e){
			punchClockDao.SetError();
			punchClockDao.responseBody.put("errorMessage", "查询失败");
	        return punchClockDao.responseBody;
	    }
	}
	//学生查询自己某日的出席情况
	@RequestMapping(value="/querySignInStudentByDate")	
	public Map<String, Object> querySignInStudentByDate(String date,String userName) {
		try {
			return punchClockDao.querySignInStudentByDate(date,userName);
		}catch (DataAccessException e){
			punchClockDao.SetError();
			punchClockDao.responseBody.put("errorMessage", "查询失败");
		    return punchClockDao.responseBody;
		}
	}
}
