package com.example.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.Dao.UserDao;
import com.example.model.User;

@RestController
public class UserController {

	@Autowired
	private UserDao userDao;
	
	@RequestMapping(value="/queryUserInfoByUserName")
	public Map<String, Object> queryUserInfo(String userName) {
		System.out.println(userName);
		return userDao.queryUserInfo(userName);
	}
	
	@RequestMapping(value="/login")
	public Map<String, Object> login(String userName, String password) {
		return userDao.login(userName, password);
	}
	
	
	//127.0.0.1:8080/register?userName=Sabistian2&password=123123&typeId=2
	@RequestMapping(value="/register")
	public Map<String, Object> register(String userName, String password,String typeId) {
		try {
			return userDao.register(userName, password,typeId);
		}catch (DataAccessException e){
			userDao.responseBody.put("result", "ERROR");
			userDao.responseBody.put("errorMessage", "注册失败，用户名已存在");
            return userDao.responseBody;
        }
		
	}
	//127.0.0.1:8080/queryUserTypeByUserName?userName=XinQ
	@RequestMapping(value="/queryUserTypeByUserName")
	public Map<String, Object> queryUserType(String userName) {
		return userDao.queryUserType(userName);
	}
	
	//127.0.0.1:8080/exchangeType
	@RequestMapping(value="/exchangeType")
	public Map<String, Object> enchangeType(String user1Name,String user2Name) {
		return userDao.enchangeType(user1Name,user2Name);
	}
	
	//127.0.0.1:8080/changePassWord?userName=XinQ&newPassWord
	@RequestMapping(value="/changePassword")
	public Map<String, Object> changePassWord(String userName,String newPassWord) {
		return userDao.changePassWord(userName,newPassWord);
	}
	
}



