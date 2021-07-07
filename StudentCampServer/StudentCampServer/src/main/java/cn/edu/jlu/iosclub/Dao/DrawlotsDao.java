//答辩抽签
package cn.edu.jlu.iosclub.Dao;

import java.util.List;
import java.util.Map;

import cn.edu.jlu.iosclub.model.Drawlots;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;

import cn.edu.jlu.iosclub.mapper.DrawlotsMapper;

@Service
@MapperScan("DrawlotsMapper")
public class DrawlotsDao extends SuperDao{
	@Autowired
	private DrawlotsMapper drawlotsMapper;
	
	public DrawlotsDao() {
		super();
	}
	
	public Map<String, Object> queryDrawlots() {
		this.responseBody.remove("list");
		List<Drawlots> drawlots = drawlotsMapper.query();
		if(!drawlots.isEmpty()) {
			this.SetSuccess();
			this.responseBody.put("list", drawlots.get(0));
		}
		else {
			this.responseBody.put("result", "ERROR");
			this.responseBody.put("errorMessage", "无答辩信息");
			
		}
		return this.responseBody;
	}
	
	public Map<String, Object> setDrawlots(String drawlist) {
		this.responseBody.remove("list");
		List<Drawlots> drawlots = drawlotsMapper.query();
		if(!drawlots.isEmpty()) {
			return UpdateDrawlots(drawlist);
		}
		else {
			return InsertDrawlots(drawlist);
		}
	}

	//更新答辩信息
	public Map<String, Object> UpdateDrawlots(String drawlist) throws DataAccessException {
		this.responseBody.remove("list");
		int res = drawlotsMapper.reset(drawlist);
		if(res != 0) {
			this.SetSuccess();
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "更新失败");
			
		}
		return this.responseBody;
	}
	//插入答辩信息
	public Map<String, Object> InsertDrawlots(String drawlist) throws DataAccessException {
		this.responseBody.remove("list");
		int res = drawlotsMapper.insert(drawlist);
		if(res != 0) {
			this.SetSuccess();
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "插入失败");
			
		}
		return this.responseBody;
	}
}
