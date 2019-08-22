package com.example.modelInterface;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.apache.ibatis.annotations.Delete;
import org.springframework.dao.DataAccessException;

import com.example.model.User;

@Mapper
public interface UserMapper {
	   //根据用户名查询用户是否存在
		@Select("select * from user where username = #{username}")
		@Results(value={
				@Result(column="register_date", property="registerTime"),
				@Result(column="type_id", property="typeid")
				})
		ArrayList<User>  queryUserInfo(@Param("username") String userName);
		
		//根据用户名和密码查询用户是否存在
		@Select("select * from user where username = #{username} and  password = #{password}")
		@Results(value={
				@Result(column="register_date", property="registerTime"),
				@Result(column="type_id", property="typeid")
				})
		ArrayList<User>  queryUserInfoWithPwd(@Param("username") String userName, @Param("password") String password);
		
		//插入用户，用户注册
		@Insert("insert into user (username, password, type_id) values (#{username}, #{password},#{type_id})")
		int insert(@Param("username") String userName, @Param("password") String password,@Param("type_id") String typeid) throws DataAccessException;
	
		//根据用户名查询用户类型
		@Select("select * from user where username = #{username}")
		@Results(value={
				@Result(column="register_date", property="registerTime"),
				@Result(column="type_id", property="typeid")
				})
		ArrayList<User> queryUserTypeByUserName(@Param("username") String userName);
		
		//更新分组信息
		@Update("update user set type_id=#{type_id} where userName=#{username}")
		int updateMsg(@Param("type_id") String type_id,@Param("username") String userName) throws DataAccessException;
		
		//更新分组信息
		@Update("update user set username=#{username} where password=#{password}")
		int updatePassWord(@Param("username") String username,@Param("password") String password) throws DataAccessException;
		
		
		
}
