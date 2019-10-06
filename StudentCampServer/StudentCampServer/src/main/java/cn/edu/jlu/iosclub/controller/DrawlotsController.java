package cn.edu.jlu.iosclub.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import cn.edu.jlu.iosclub.Dao.DrawlotsDao;

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
	public Map<String, Object> setDrawlots(String drawlist) {
		try {
		return drawlotsDao.setDrawlots(drawlist);
		}catch (DataAccessException e){
			drawlotsDao.responseBody.put("result", "ERROR");
			drawlotsDao.responseBody.put("errorMessage", "更新失败");
            return drawlotsDao.responseBody;
        }
	}

}
