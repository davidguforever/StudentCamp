package com.example.modelInterface;

import java.util.List;
import java.util.ArrayList;

import com.example.model.Content;
import com.example.model.User;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;

@Mapper
public interface ContentMapper {
	
	@Select("Select * from content order by create_time desc")
	@Results(
	   value = {
			   @Result(id=true, column = "id",property = "contentId"),
			   @Result(column="create_time", property = "createTime")
	   }
	)
	List <Content> query();
	
	@Select("Select * from content where id=#{contentId}")
	@Results(
			   value = {
					   @Result(column="create_time", property = "createTime"),
					   @Result(id=true, column = "id",property = "contentId")
			   }
			)
	ArrayList <Content> queryById(@Param("contentId") String contentId);
	
	//发布心得
	@Insert("insert into content (username, title, content,type_id) values (#{username}, #{title}, #{content},#{type_id})")
	int insert(@Param("username") String username, @Param("title") String title, @Param("content") String content, @Param("type_id") String type_id);
	
	//删除心得
	@Delete("delete from content where id=#{contentId}")
	int deleteContent(@Param("contentId") String contentId);
	
	//根据用户名查询用户类型
	@Select("select * from user where username = #{username}")
	@Results(value={
			@Result(column="register_date", property="registerTime"),
			@Result(column="type_id", property="typeid")
			})
	ArrayList<User> queryUserTypeByUserName(@Param("username") String userName);
}


//在ContentMapper接口的query()方法中，该方法所对应的SQL语句是“select * from content”
//也就是查询所有content中的数据。@Results注解提供了数据库表的字段与Model的属性的映射关系。
//下方指定了表字段"id"与"contentId"对应，字段名"create_time"与“createTime”属性相对应
//而未指定的就是字段名与属性名一致。
//queryById()就是带有条件的查询方法了。其参数就是查询的条件。通过@Param注解进行条件与参数的绑定。
