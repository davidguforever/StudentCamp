//分享
package com.example.Dao;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;

import com.example.modelInterface.ContentMapper;
import com.example.model.Content;
import com.example.model.User;

@Service
@MapperScan("com.example.modelInterface.ContentMapper")
public class ContentDao extends SuperDao {
	
	@Autowired
	private ContentMapper contentMapper;
	
	public ContentDao() {
		super();
	}
	
	public Map<String, Object> queryContent (String contentId) throws DataAccessException {
		this.responseBody.remove("list");
		ArrayList<Content> contents = contentMapper.queryById(contentId);
		if(!contents.isEmpty()){
			this.SetSuccess();
			this.responseBody.put("list", contents.get(0));
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "无信息");	
		}
		return this.responseBody;
	}
	public Map<String, Object> queryAll () throws DataAccessException{
		this.responseBody.remove("list");
		List <Content> contents = contentMapper.query();
		if(!contents.isEmpty()){
			this.SetSuccess();
			this.responseBody.put("list", contents);
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "无信息");	
		}
		return this.responseBody;
	}
	
	public Map<String, Object> addContent (String username, String title, String content) throws DataAccessException{
		this.responseBody.remove("list");
		ArrayList<User> users = contentMapper.queryUserTypeByUserName(username);
		int res = contentMapper.insert(username, title, content,users.get(0).getTypeid());
		if(res != 0)
		{
			this.SetSuccess();
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "添加失败");	
		}
		return this.responseBody;
	}
	
	public Map<String, Object> deleteContent (String contentId) throws DataAccessException{
		this.responseBody.remove("list");
		int res = contentMapper.deleteContent(contentId);
		if(res != 0)
		{
			this.SetSuccess();
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "删除失败");	
		}
		return this.responseBody;
	}
}

