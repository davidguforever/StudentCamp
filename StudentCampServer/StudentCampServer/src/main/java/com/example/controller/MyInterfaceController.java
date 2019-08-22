package com.example.controller;

import java.util.List;
import java.util.Map;
import com.example.modelInterface.ContentMapper;
import com.example.model.Content;
import com.example.Dao.ContentDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class MyInterfaceController {

	@Autowired
	private ContentDao contentDao;
	
	//http://127.0.0.1:8080/queryContentById?contentId=6
	//获取内容详情
	@RequestMapping(value="/contentDetail")
	public Map<String, Object> contentDetail(String contentId) {
		try {
			return contentDao.queryContent(contentId);
		}catch (DataAccessException e){
			contentDao.responseBody.put("result", "ERROR");
			//contentDao.responseBody.put("errorMessage", e);
			contentDao.responseBody.put("errorMessage", "查询异常");
            return contentDao.responseBody;
        }
	}
	
	//http://127.0.0.1:8080/queryAll
	@RequestMapping(value="/queryAll")
	public Map<String, Object> queryAll() {
		try{
			return contentDao.queryAll();
		}catch (DataAccessException e){
			contentDao.responseBody.put("result", "ERROR");
			contentDao.responseBody.put("errorMessage", "查询异常");
            return contentDao.responseBody;
        }
	}

	@RequestMapping("/test")
	@ResponseBody
	public String index() {
		return "test没问题";
	}
	
	//添加内容
	@RequestMapping(value="/contentAdd")
	public Map<String, Object> addContent(String username, String title, String content) {
		try{
			return contentDao.addContent(username, title, content);
		}catch (DataAccessException e){
			contentDao.responseBody.put("result", "ERROR");
			contentDao.responseBody.put("errorMessage", "添加异常");
            return contentDao.responseBody;
        }
	}
	
	//删除内容
	@RequestMapping(value="/contentDelete")
	public Map<String, Object> deleteContent(String contentId) {
		try{
			return contentDao.deleteContent(contentId);
		}catch (DataAccessException e){
			contentDao.responseBody.put("result", "ERROR");
			contentDao.responseBody.put("errorMessage", "删除异常");
            return contentDao.responseBody;
        }
	}
}
