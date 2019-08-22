//报名
package com.example.Dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;

import com.example.model.CampusManager;
import com.example.model.CampusSchool;
import com.example.model.CampusStudent;
import com.example.modelInterface.CampusMapper;

@Service
@MapperScan("com.example.modelInterface.CampusMapper")
public class CampusDao extends SuperDao{
	@Autowired
	private CampusMapper campusMapper;
	
	public CampusDao() {
		super();
	}
	//查询报名总信息
	public Map<String, Object> queryCampusMsg() throws DataAccessException {
		this.responseBody.remove("list");
		List<CampusManager> manager = campusMapper.queryCampusMsg();
		if(!manager.isEmpty()) {
			this.SetSuccess();
			this.responseBody.put("list", manager.get(0));
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "无信息");
			
		}
		return this.responseBody;
	}
	
	//查询教师报名信息
	public Map<String, Object> queryCampusTecMsg(String teacherId) throws DataAccessException {
		this.responseBody.remove("list");
		List<CampusSchool> school = campusMapper.queryCampusSchoolMsgByTecId(teacherId);
		if(!school.isEmpty()) {
			this.SetSuccess();
			this.responseBody.put("list", school.get(0));
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "无信息");
			
		}
		return this.responseBody;
	}
	
	//查询学生报名信息
	public Map<String, Object> queryCampusStuMsg(String userName) throws DataAccessException {
		this.responseBody.remove("list");
		ArrayList<CampusStudent> student = campusMapper.queryStuMsgByUserName(userName);
		if(!student.isEmpty()) {
			this.SetSuccess();
			this.responseBody.put("list", student.get(0));
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "无信息");
				
		}
		return this.responseBody;
	}
	
	//查询是否开始报名
	public Map<String, Object> queryIsBeginEnter() throws DataAccessException {
		this.responseBody.remove("list");
		List<CampusManager> manager = campusMapper.queryCampusMsg();
		if(!manager.isEmpty()) {
			this.SetSuccess();
			this.responseBody.put("list", manager.get(0).getIsBegin());
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "无信息");
			
		}
		return this.responseBody;
	}
	//查询报名的DeadLine
	public Map<String, Object> queryCampusDeadLine() throws DataAccessException {
		this.responseBody.remove("list");
		List<CampusManager> manager = campusMapper.queryCampusMsg();
		if(!manager.isEmpty()) {
			this.SetSuccess();
			this.responseBody.put("list", manager.get(0).getDeadLine());
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "无信息");
			
		}
		return this.responseBody;
	}
	//管理者设置报名情况
	public Map<String, Object> BeginEnter(String totalNum, String schoolNum,String DeadLine) throws DataAccessException {
		this.responseBody.remove("list");
		List<CampusManager> manager = campusMapper.queryCampusMsg();
		if(!manager.isEmpty()) {
			return UpDateCampusMsg(totalNum,schoolNum,DeadLine);
		}
		else {
			return InsertCampusMsg(totalNum,schoolNum,DeadLine);
		}
	}
	//更新报名信息
	public Map<String, Object> UpDateCampusMsg(String totalNum, String schoolNum,String DeadLine) throws DataAccessException {
		this.responseBody.remove("list");
		int res = campusMapper.updateCampusMag(totalNum, schoolNum, DeadLine);
		if(res != 0) {
			this.SetSuccess();
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "更新失败");
			
		}
		return this.responseBody;
	}
	//插入报名信息
	public Map<String, Object> InsertCampusMsg(String totalNum, String schoolNum,String DeadLine) throws DataAccessException {
		this.responseBody.remove("list");
		int res = campusMapper.insert(totalNum, schoolNum, DeadLine);
		if(res != 0) {
			this.SetSuccess();
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "插入失败");
			
		}
		return this.responseBody;
	}
	
	//教师设置报名情况
	public Map<String, Object> SetCampusTeacher( String stuSchool,String stuNum ,String teacherId) throws DataAccessException {
		this.responseBody.remove("list");
		List<CampusSchool> campusSchool = campusMapper.queryCampusSchoolMsgByTecId(teacherId);
		if(!campusSchool.isEmpty()) {
			return UpDateCampusSchoolMsg(stuSchool,stuNum,teacherId);
		}
		else {
			return InsertCampusSchoolMsg(stuSchool,stuNum,teacherId);
		}
	}
	
	   //更新教师设置相关报名情况信息
		public Map<String, Object> UpDateCampusSchoolMsg(String stuSchool,String stuNum,String teacherId) throws DataAccessException {
			this.responseBody.remove("list");
			int res = campusMapper.updateTec(stuSchool, stuNum, teacherId);
			if(res != 0) {
				this.SetSuccess();
			}
			else {
				this.SetError();
				this.responseBody.put("errorMessage", "更新失败");
				
			}
			return this.responseBody;
		}
		//插入教师设置相关报名情况信息
		public Map<String, Object> InsertCampusSchoolMsg(String stuSchool,String stuNum,String teacherId) throws DataAccessException {
			this.responseBody.remove("list");
			int res = campusMapper.insertTec(stuSchool, stuNum, teacherId);
			if(res != 0) {
				this.SetSuccess();
			}
			else {
				this.SetError();
				this.responseBody.put("errorMessage", "插入失败");
				
			}
			return this.responseBody;
		}
	
		//学生设置报名情况
		public Map<String, Object> SetCampusStudent( String stuName, String stuSex,  String stuGrade, 
				String stuSchool,  String stuTel,  String stuHobby,  String stuMail
				,  String stuClub,  String userName) throws DataAccessException {
			this.responseBody.remove("list");
			ArrayList<CampusStudent> student = campusMapper.queryStuMsgByUserName(userName);
			if(!student.isEmpty()) {
				return UpDateCampusSchoolMsg(stuName,stuSex,stuGrade,stuSchool,stuTel,stuHobby,stuMail,stuClub,userName);
			}
			else {
				return InsertCampusSchoolMsg(stuName,stuSex,stuGrade,stuSchool,stuTel,stuHobby,stuMail,stuClub,userName);
			}
		}
		//更新学生信息
		public Map<String, Object> UpDateCampusSchoolMsg(String stuName, String stuSex,  String stuGrade, 
				String stuSchool,  String stuTel,  String stuHobby,  String stuMail
				,  String stuClub,  String userName) throws DataAccessException {
			this.responseBody.remove("list");
			int res = campusMapper.updateStu(stuName, stuSex, stuGrade, stuSchool, stuTel, stuHobby, stuMail, stuClub, userName);
			if(res != 0) {
				campusMapper.updateTmpNumSub();
				this.SetSuccess();
			}
			else {
				this.SetError();
				this.responseBody.put("errorMessage", "更新失败");
				
			}
			return this.responseBody;
		}
		//插入学生信息
		public Map<String, Object> InsertCampusSchoolMsg(String stuName, String stuSex,  String stuGrade, 
				String stuSchool,  String stuTel,  String stuHobby,  String stuMail
				,  String stuClub,  String userName) throws DataAccessException {
			this.responseBody.remove("list");
			int res = campusMapper.insertCampusStudent(stuName, stuSex, stuGrade, stuSchool, stuTel, stuHobby, stuMail, stuClub, userName);
			if(res != 0) {
				this.SetSuccess();
			}
			else {
				this.SetError();
				this.responseBody.put("errorMessage", "插入失败");
				
			}
			return this.responseBody;
		}
		
		//查询报名情况 - 管理者
		public Map<String, Object> queryInfoManger() throws DataAccessException {
			this.responseBody.remove("list");
			List<CampusSchool> schools = campusMapper.queryCampusSchoolMsg();
			if(!schools.isEmpty()) {
				this.SetSuccess();
				this.responseBody.put("list", schools);
			}
			else {
				this.SetError();
				this.responseBody.put("errorMessage", "无信息");
				
			}
			return this.responseBody;
		}
		
		//查询报名情况 - 教师
		public Map<String, Object> queryInfoTeacher(String teacherId) throws DataAccessException {
			this.responseBody.remove("list");
			List<String> schools = campusMapper.querySchoolByTeacher(teacherId);
			List<CampusStudent> students = campusMapper.queryStudentBySchool(schools.get(0));
			if(!students.isEmpty()) {
				this.SetSuccess();
				this.responseBody.put("list", students);
			}
			else {
				this.SetError();
				this.responseBody.put("errorMessage", "无信息");	
				}
			return this.responseBody;
		}
		//查询报名情况 - 学生
		public Map<String, Object> queryInfoStudent(String userName) throws DataAccessException {
			this.responseBody.remove("list");
			List<CampusStudent> students = campusMapper.queryStuMsgByUserName(userName);
			
			if(!students.isEmpty()) {
				this.SetSuccess();
				this.responseBody.put("list", students.get(0).getIsCheck());
			}
			else {
				this.SetError();
				this.responseBody.put("errorMessage", "无信息");	
				}
			return this.responseBody;
		}
		//审核学生报名 confirmCampusStudent
		public Map<String, Object> confirmCampusStudent(String userName) throws DataAccessException {
			this.responseBody.remove("list");
			int res =  campusMapper.confirmStuByStuUserName(userName);
			
			if( res != 0) {
				campusMapper.updateTmpNumAdd();
				this.SetSuccess();
			}
			else {
				this.SetError();
				this.responseBody.put("errorMessage", "无信息");	
				}
			return this.responseBody;
		}
				
}
