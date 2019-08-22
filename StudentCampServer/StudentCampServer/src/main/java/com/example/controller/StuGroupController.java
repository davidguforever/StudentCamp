package com.example.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.Dao.GroupDao;
import com.example.Dao.PunchClockDao;
import com.example.model.CampusStudent;
import com.example.model.GroupMsg;
import com.example.model.GroupStudent;

@RestController

public class StuGroupController {
@Autowired
	
	private GroupDao groupDao;
		
	//查询分组信息
	@RequestMapping(value="/queryGroupMsg")	
	public Map<String, Object> queryGroupMsg() {
		try {
			return groupDao.queryGroupMsg();
		}catch (DataAccessException e){
			groupDao.SetError();
			//punchClockDao.responseBody.put("errorMessage", e);
			groupDao.responseBody.put("errorMessage", "查询失败");
            return groupDao.responseBody;
        }
	}
	//查询分组信息
	@RequestMapping(value="/queryTotalNum")	
	public Map<String, Object> queryTotalNum() {
		try {
			return groupDao.queryTotalNum();
		}catch (DataAccessException e){
			groupDao.SetError();
			//punchClockDao.responseBody.put("errorMessage", e);
			groupDao.responseBody.put("errorMessage", "查询失败");
	        return groupDao.responseBody;
	    }
	}
	//设置分组信息
	@RequestMapping(value="/setGroupMsg")
	public Map<String, Object> setGroupMsg(String groupNum, String groupStuNum,String stuSex,String stuGrade,String stuSchool,String stuHobby) {
		try {
		return groupDao.setGroupMsg(groupNum, groupStuNum,stuSex,stuGrade,stuSchool,stuHobby);
		}catch (DataAccessException e){
			groupDao.responseBody.put("result", "ERROR");
			//groupDao.responseBody.put("errorMessage", e);
			groupDao.responseBody.put("errorMessage", "更新失败");
            return groupDao.responseBody;
        }
	}
	//确认分组
	@RequestMapping(value="/confirmGroup")
	public Map<String, Object> confirmGroup() {
		try {
		return groupDao.confirmGroup();
		}catch (DataAccessException e){
			groupDao.responseBody.put("result", "ERROR");
			groupDao.responseBody.put("errorMessage", "更新失败");
            return groupDao.responseBody;
        }
	}
	//调整分组
	@RequestMapping(value="/adjustGroup")
	public Map<String, Object> adjustGroup(String userName,String groupId) {
		try {
		return groupDao.adjustGroup(userName,groupId);
		}catch (DataAccessException e){
			groupDao.responseBody.put("result", "ERROR");
			groupDao.responseBody.put("errorMessage", "更新失败");
	        return groupDao.responseBody;
	    }
	}
	//分组
	@RequestMapping(value="/divide")
	public Map<String, Object> divide() {
		try {
		return groupDao.divide();
		}catch (DataAccessException e){
			groupDao.responseBody.put("result", "ERROR");
			groupDao.responseBody.put("errorMessage", e);
			//groupDao.responseBody.put("errorMessage", "更新失败");
	        return groupDao.responseBody;
	    }
	}
	//分组
	@RequestMapping(value="/resetDivide")
	public Map<String, Object> resetDivide() {
		try {
		return groupDao.resetDivide();
		}catch (DataAccessException e){
			groupDao.responseBody.put("result", "ERROR");
			groupDao.responseBody.put("errorMessage", e);
			//groupDao.responseBody.put("errorMessage", "更新失败");
		    return groupDao.responseBody;
		   }
	}
	//查询所有学生分组信息
	@RequestMapping(value="/queryGroupManager")	
	public Map<String, Object> queryGroupManager() {
		try {
			return groupDao.queryGroupManager();
		}catch (DataAccessException e){
			groupDao.SetError();
			//punchClockDao.responseBody.put("errorMessage", e);
			groupDao.responseBody.put("errorMessage", "查询失败");
	        return groupDao.responseBody;
	    }
	}
	//教师查询学生分组信息
	@RequestMapping(value="/queryGroupTeacher")	
	public Map<String, Object> queryGroupTeacher(String teacherId) {
		try {
			return groupDao.queryGroupTeacher(teacherId);
		}catch (DataAccessException e){
			groupDao.SetError();
			//punchClockDao.responseBody.put("errorMessage", e);
			groupDao.responseBody.put("errorMessage", "查询失败");
	        return groupDao.responseBody;
	    }
	}
	//学生查询分组信息
	@RequestMapping(value="/queryGroupStudent")	
	public Map<String, Object> queryGroupStudent(String userName) {
		try {
			return groupDao.queryGroupStudent(userName);
		}catch (DataAccessException e){
			groupDao.SetError();
			//punchClockDao.responseBody.put("errorMessage", e);
			groupDao.responseBody.put("errorMessage", "查询失败");
	        return groupDao.responseBody;
	    }
	}
}
