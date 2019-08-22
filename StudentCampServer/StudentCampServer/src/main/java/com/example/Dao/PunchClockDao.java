//签到
package com.example.Dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.model.CampusManager;
import com.example.model.CampusStudent;
import com.example.model.PunchClockManager;
import com.example.model.PunchClockStudent;
import com.example.modelInterface.CampusMapper;
import com.example.modelInterface.PunchClockMapper;

@Service
@MapperScan("com.example.modelInterface.PunchClockMapper")
public class PunchClockDao extends SuperDao{
	@Autowired
	private PunchClockMapper punchClockMapper;
	public PunchClockDao() {
		super();
	}
	
	//查询签到总信息
	public Map<String, Object> querySignInMsg(String date) throws DataAccessException {
		this.responseBody.remove("list");
		List<PunchClockManager> manager = punchClockMapper.querySignInMsgByDate(date);
		if(!manager.isEmpty()) {
			this.SetSuccess();
			this.responseBody.put("list", manager.get(0));
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "还未开始签到");
			
		}
		return this.responseBody;
	}
	//开始签到
	public Map<String, Object> beginSignIn(String date, String longitude,String latitude) throws DataAccessException {
		this.responseBody.remove("list");
		List<PunchClockManager> manager = punchClockMapper.querySignInMsgByDate(date);
		if(!manager.isEmpty()) {
			return UpDateSignInMsg(date,longitude,latitude);
		}
		else {
			return InsertSignInMsg(date,longitude,latitude);
		}
	}
	
	//更新签到信息
	public Map<String, Object> UpDateSignInMsg(String date, String longitude,String latitude) throws DataAccessException {
		this.responseBody.remove("list");
		int res = punchClockMapper.updateSignMsgByDate(date,longitude, latitude);
		if(res != 0) {
			this.SetSuccess();
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "更新签到信息失败");
			
		}
		return this.responseBody;
	}
	//插入报名信息
	public Map<String, Object> InsertSignInMsg(String date, String longitude,String latitude) throws DataAccessException {
		this.responseBody.remove("list");
		int res = punchClockMapper.insert(date, longitude, latitude);
		if(res != 0) {
			this.SetSuccess();
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "插入签到信息失败");
			
		}
		return this.responseBody;
	}
	//结束签到
	public Map<String, Object> endSignIn(String date) throws DataAccessException {
		this.responseBody.remove("list");
		int res = punchClockMapper.updateSignBeginByDate(date);
		if(res != 0) {
			this.SetSuccess();
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "结束签到失败");
			
		}
		return this.responseBody;
	}
	
	//拿到某日的签到信息-管理者
	public Map<String, Object> querySignInManager(String date) throws DataAccessException {
		this.responseBody.remove("list");
		Map<String, Object> result = new HashMap<String,Object>();
		List<String> schoolList = punchClockMapper.querySchoolList();
		for(int i = 0;i < schoolList.size();++i)
		{
			List<String> students = punchClockMapper.queryStudentBySchool(date, schoolList.get(i));
			List<String> absentStudents = punchClockMapper.queryAbsentStudentBySchool(date, schoolList.get(i));
			Map<String,String> condition = new HashMap<String,String>();
			condition.put("出席人数："+students.size(), "缺席人数："+absentStudents.size());
			result.put(schoolList.get(i), condition);
			condition = null;
		}
		if(!result.isEmpty()) {
			this.SetSuccess();
			this.responseBody.put("list", result);
		}
		else {
			this.SetSuccess();
			this.responseBody.put("errorMessage", "无信息");
			
		}
		return this.responseBody;
	}
	
	//拿到某日 某校的签到信息
	public Map<String, Object> querySignInTeacher(String date,String teacherId) throws DataAccessException {
		this.responseBody.remove("list");
		Map<String, Object> result = new HashMap<String,Object>();
		List<String> schools = punchClockMapper.querySchoolByTeacher(teacherId);
		List<String> students = punchClockMapper.queryStudentBySchool(date, schools.get(0));
		List<String> absentStudents = punchClockMapper.queryAbsentStudentBySchool(date, schools.get(0));
		result.put("出席人", students);
		result.put("缺席人", absentStudents);
		if(!result.isEmpty()) {
			this.SetSuccess();
			this.responseBody.put("list", result);
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "无信息");		
		}
		return this.responseBody;
	}
	
	//开始签到
	public Map<String, Object> signIn(String date,String userName) throws DataAccessException {
		this.responseBody.remove("list");
		List<PunchClockStudent> student = punchClockMapper.queryStudentByUserName(date, userName);
		if(!student.isEmpty()) {
			return UpDate(date,userName);
		}
		else {
			return Insert(date,userName);
		}
	}
	
	//更新签到信息
	public Map<String, Object> UpDate(String date,String userName) throws DataAccessException {
		this.responseBody.remove("list");
		ArrayList<CampusStudent> stu = punchClockMapper.queryStuMsgByUserName(userName);
		if(stu.isEmpty())
		{
			this.SetError();
			this.responseBody.put("errorMessage", "更新签到信息失败");
			return this.responseBody;
		}
		int res = punchClockMapper.updateStu(date, stu.get(0).getStuName(), stu.get(0).getStuSchool(), userName);
		if(res != 0) {
			this.SetSuccess();
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "更新签到信息失败");
			
		}
		return this.responseBody;
	}
	//插入签到信息
	public Map<String, Object> Insert(String date,String userName) throws DataAccessException {
		this.responseBody.remove("list");
		ArrayList<CampusStudent> stu = punchClockMapper.queryStuMsgByUserName(userName);
		if(stu.isEmpty())
		{
			this.SetError();
			this.responseBody.put("errorMessage", "插入签到信息失败");
			return this.responseBody;
		}
		int res = punchClockMapper.insertStu(date, stu.get(0).getStuName(), stu.get(0).getStuSchool(), userName);
		if(res != 0) {
			this.SetSuccess();
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "插入签到信息失败");
			
		}
		return this.responseBody;
	}
	
	//学生查询自己的出席列表
	public Map<String, Object> querySignInStudent(String userName) throws DataAccessException {
		this.responseBody.remove("list");
		List<String> dates = punchClockMapper.queryStudentSignDateByUserName(userName);
		if(!dates.isEmpty()) {
			this.SetSuccess();
			this.responseBody.put("list", dates);
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "还未开始签到");
			
		}
		return this.responseBody;
	}
	
	//查询某日自己的出席情况
	public Map<String, Object> querySignInStudentByDate(String date,String userName) throws DataAccessException {
		this.responseBody.remove("list");
		List<PunchClockStudent> student = punchClockMapper.queryStudentByUserName(date, userName);
		if(!student.isEmpty()) {
			this.SetSuccess();
			this.responseBody.put("list", student.get(0));
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "未出席");
			
		}
		return this.responseBody;
	}
}


