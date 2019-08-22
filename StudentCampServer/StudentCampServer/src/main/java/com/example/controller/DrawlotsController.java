package com.example.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.example.Dao.DrawlotsDao;
import com.example.model.Content;

@RestController
public class DrawlotsController {
	@Autowired
	private DrawlotsDao drawlotsDao;
	
	@RequestMapping(value="/queryDrawlots")
	
	public Map<String, Object> queryDrawlots() {
		try {
		return drawlotsDao.queryDrawlots();
		}catch (DataAccessException e){
			drawlotsDao.responseBody.put("result", "ERROR");
			drawlotsDao.responseBody.put("errorMessage", "更新失败");
            return drawlotsDao.responseBody;
        }
	}
	
	@RequestMapping(value="/setDrawlots")
	public Map<String, Object> setDrawlots(String turnnum, String singlenum,String drawlist) {
		try {
		return drawlotsDao.setDrawlots(turnnum, singlenum,drawlist);
		}catch (DataAccessException e){
			drawlotsDao.responseBody.put("result", "ERROR");
			drawlotsDao.responseBody.put("errorMessage", "更新失败");
            return drawlotsDao.responseBody;
        }
	}
	//127.0.0.1:8080/register?userName=Sabistian2&password=123123&typeId=2
	@RequestMapping(value="/nextTurn")
	public Map<String, Object> nextTurn() {
		try {
			return drawlotsDao.nextTurn();
		}catch (DataAccessException e){
			drawlotsDao.responseBody.put("result", "ERROR");
			drawlotsDao.responseBody.put("errorMessage", "更新失败");
            return drawlotsDao.responseBody;
        }
		
	}
	//127.0.0.1:8080/queryUserTypeByUserName?userName=XinQ
	@RequestMapping(value="/getTempTurn")
	public Map<String, Object> getTempTurn() {
		try {
		return drawlotsDao.getTempTurn();
		}catch (DataAccessException e){
			drawlotsDao.responseBody.put("result", "ERROR");
			drawlotsDao.responseBody.put("errorMessage", "更新失败");
            return drawlotsDao.responseBody;
        }
	}
}
