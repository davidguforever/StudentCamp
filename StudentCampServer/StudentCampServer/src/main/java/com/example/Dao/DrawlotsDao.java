//答辩抽签
package com.example.Dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;

import com.example.model.CampusManager;
import com.example.model.CampusStudent;
import com.example.model.Drawlots;
import com.example.modelInterface.DrawlotsMapper;

@Service
@MapperScan("com.example.modelInterface.DrawlotsMapper")
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
	
	public Map<String, Object> setDrawlots(String turnnum, String singlenum,String drawlist) {
		this.responseBody.remove("list");
		List<Drawlots> drawlots = drawlotsMapper.query();
		if(!drawlots.isEmpty()) {
			return UpdateDrawlots(turnnum,singlenum,drawlist);
		}
		else {
			return InsertDrawlots(turnnum,singlenum,drawlist);
		}
	}

	//更新答辩信息
	public Map<String, Object> UpdateDrawlots(String turnnum, String singlenum,String drawlist) throws DataAccessException {
		this.responseBody.remove("list");
		int res = drawlotsMapper.reset(turnnum, singlenum, drawlist);
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
	public Map<String, Object> InsertDrawlots(String turnnum, String singlenum,String drawlist) throws DataAccessException {
		this.responseBody.remove("list");
		int res = drawlotsMapper.insert(turnnum, singlenum, drawlist);
		if(res != 0) {
			this.SetSuccess();
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "插入失败");
			
		}
		return this.responseBody;
	}
	
	
	public Map<String, Object> nextTurn()throws DataAccessException{
		this.responseBody.remove("list");
		int res = drawlotsMapper.updateTurn();
		if(res != 0) {
			this.SetSuccess();
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "更新失败");
			
		}
		return this.responseBody;
	}
	//查询本轮报名情况
	public Map<String, Object> getTempTurn() throws DataAccessException {
		this.responseBody.remove("list");
		List<Drawlots> drawlots = drawlotsMapper.query();
		if(!drawlots.isEmpty()) {
			this.SetSuccess();
			int tmpTurn = drawlots.get(0).getTmpturn();
			int singlenum = drawlots.get(0).getSinglenum();
			String[] sourceStrArray = drawlots.get(0).getDrawlist().split(",");
			String res = new String();
			for(int i = 0;i < singlenum;++i)
			{
				res += sourceStrArray[((tmpTurn - 1) * singlenum >= 0? (tmpTurn - 1) * singlenum :0) + i] + ",";
			}
			res = res.substring(0,res.length() - 1);
			this.responseBody.put("list", res);
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "无信息");	
			}
		return this.responseBody;
	}
}
