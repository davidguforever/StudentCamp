//用户登录
package com.example.Dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;

import com.example.model.User;
import com.example.modelInterface.UserMapper;

@Service
@MapperScan("com.example.modelInterface.UserMapper")
public class UserDao extends SuperDao{
	@Autowired
	private UserMapper userMapper;
	
	public UserDao() {
		super();
	}
	
	public Map<String, Object> queryUserInfo(String userName) {
		this.responseBody.remove("list");
		ArrayList<User> users = userMapper.queryUserInfo(userName);
		if(!users.isEmpty()) {
			this.responseBody.put("result", "SUCCESS");
			this.responseBody.put("errorMessage", "");
			this.responseBody.put("list", users.get(0));
		}
		else {
			this.responseBody.put("result", "ERROR");
			this.responseBody.put("errorMessage", "用户不存在");
			
		}
		return this.responseBody;
	}
	
	public Map<String, Object> login(String userName, String password) {
		this.responseBody.remove("list");
		List<User> users = userMapper.queryUserInfoWithPwd(userName, password);
		if(!users.isEmpty()) {
			this.responseBody.put("result", "SUCCESS");
			this.responseBody.put("errorMessage", "");
			this.responseBody.put("list", users.get(0));
		}
		else {
			this.responseBody.put("result", "ERROR");
			this.responseBody.put("errorMessage", "密码错误");
			
		}
		return this.responseBody;
	}
	
	public Map<String, Object> enchangeType(String user1Name, String user2Name) {
		this.responseBody.remove("list");
		List<User> user1 = userMapper.queryUserInfo(user1Name);
		List<User> user2 = userMapper.queryUserInfo(user2Name);
		if(!user2.isEmpty()) {
			this.responseBody.put("result", "SUCCESS");
			this.responseBody.put("errorMessage", "");
			userMapper.updateMsg(user1.get(0).getTypeid(), user2.get(0).getUsername());
			userMapper.updateMsg(user2.get(0).getTypeid(), user1.get(0).getUsername());
		}
		else {
			this.responseBody.put("result", "ERROR");
			this.responseBody.put("errorMessage", "转移错误");
			
		}
		return this.responseBody;
	}
	
	public Map<String, Object> changePassWord(String userName,String newPassWord) {
		this.responseBody.remove("list");
		List<User> users = userMapper.queryUserInfo(userName);
		if(!users.isEmpty()) {
			this.responseBody.put("result", "SUCCESS");
			this.responseBody.put("errorMessage", "");
			userMapper.updatePassWord(userName, newPassWord);
		}
		else {
			this.responseBody.put("result", "ERROR");
			this.responseBody.put("errorMessage", "用户不存在");
			
		}
		return this.responseBody;
	}
	
	public Map<String, Object> register(String userName, String password,String typeID) throws DataAccessException{
		this.responseBody.remove("list");
		if(userMapper.insert(userName, password, typeID) == 1)
		{
			this.responseBody.put("result", "SUCCESS");
			this.responseBody.put("errorMessage", "");
			return this.login(userName, password);
		}
		else {
			this.responseBody.put("result", "ERROR");
			this.responseBody.put("errorMessage", "插入失败");
			
		}
		return this.responseBody;
		
	}
	
	public Map<String, Object> queryUserType(String userName) {
		this.responseBody.remove("list");
		List<User> users = userMapper.queryUserTypeByUserName(userName);
		if(!users.isEmpty()) {
			this.responseBody.put("result", "SUCCESS");
			this.responseBody.put("errorMessage", "");
			this.responseBody.put("list", users.get(0).getTypeid());
		}
		else {
			this.responseBody.put("result", "ERROR");
			this.responseBody.put("errorMessage", "用户不存在");
			
		}
		return this.responseBody;
	}
}
