//分组
package cn.edu.jlu.iosclub.Dao;

import java.util.*;

import cn.edu.jlu.iosclub.model.CampusStudent;
import cn.edu.jlu.iosclub.model.GroupMsg;
import cn.edu.jlu.iosclub.model.GroupStudent;
import cn.edu.jlu.iosclub.model.Student;
import cn.edu.jlu.iosclub.util.GroupUtil;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;

import cn.edu.jlu.iosclub.mapper.StuGroupMapper;

@Service
@MapperScan("com.example.mapper.stuGroupMapper")
public class GroupDao extends SuperDao{
	@Autowired
	private StuGroupMapper stuGroupMapper;
	public GroupDao() {
		super();
	}
	
	//查询分组设置信息
	public Map<String, Object> queryGroupMsg() throws DataAccessException {
		this.responseBody.remove("list");
		List<GroupMsg> groupMsg = stuGroupMapper.queryMsg();
		if(!groupMsg.isEmpty()) {
			this.SetSuccess();
			this.responseBody.put("list", groupMsg.get(0));
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "无信息");
			
		}
		return this.responseBody;
	}
	//设置分组信息
	public Map<String, Object> setGroupMsg(String groupNum, String groupStuNum,String stuSex,String stuGrade,String stuSchool,String stuHobby) throws DataAccessException {
		this.responseBody.remove("list");
		List<GroupMsg> groupMsg = stuGroupMapper.queryMsg();
		if(!groupMsg.isEmpty()) {
			return UpDateGroupMsg(groupNum,groupStuNum,stuSex,stuGrade,stuSchool,stuHobby);
		}
		else {
			return InsertGroupMsg(groupNum,groupStuNum,stuSex,stuGrade,stuSchool,stuHobby);
		}
	}
	
	//更新签到信息
	public Map<String, Object> UpDateGroupMsg(String groupNum, String groupStuNum,String stuSex,String stuGrade,String stuSchool,String stuHobby) throws DataAccessException {
		this.responseBody.remove("list");
		int res = stuGroupMapper.updateMsg(groupNum, groupStuNum, stuSex, stuGrade, stuSchool, stuHobby);
		if(res != 0) {
			this.SetSuccess();
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "更新分组信息失败");
			
		}
		return this.responseBody;
	}
	//插入报名信息
	public Map<String, Object> InsertGroupMsg(String groupNum, String groupStuNum,String stuSex,String stuGrade,String stuSchool,String stuHobby) throws DataAccessException {
		this.responseBody.remove("list");
		int res = stuGroupMapper.insert(groupNum, groupStuNum, stuSex, stuGrade, stuSchool, stuHobby);
		if(res != 0) {
			this.SetSuccess();
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "插入分组信息失败");
			
		}
		return this.responseBody;
	}
	//确认分组
	public Map<String, Object> confirmGroup() throws DataAccessException {
		this.responseBody.remove("list");
		int res = stuGroupMapper.updateIsFinish();
		if(res != 0) {
			this.SetSuccess();
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "确认失败");
			
		}
		return this.responseBody;
	}
	//调整分组
	public Map<String, Object> adjustGroup(String userName,String groupId) throws DataAccessException {
		this.responseBody.remove("list");
		int res = stuGroupMapper.updateStu(userName, groupId);
		if(res != 0) {
			this.SetSuccess();
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "确认失败");
			
		}
		return this.responseBody;
	}
	//拿到分组信息-管理者
	public Map<String, Object> queryGroupManager() throws DataAccessException {
		this.responseBody.remove("list");
		List<GroupStudent> students = stuGroupMapper.queryAllGroupStudent();
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
	//拿到分组信息-教师
	public Map<String, Object> queryGroupTeacher(String teacherId) throws DataAccessException {
		this.responseBody.remove("list");
		Map<String, Object> result = new HashMap<String,Object>();
		List<String> schools = stuGroupMapper.querySchoolByTeacher(teacherId);
		List<GroupStudent> students = stuGroupMapper.queryGroupStudentBySchoolName(schools.get(0));
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
	//拿到分组信息-学生
	public Map<String, Object> 	queryGroupStudent(String userName) throws DataAccessException {
		this.responseBody.remove("list");
		List<String> groupId = stuGroupMapper.queryGroupIdByUserName(userName);
		if(!groupId.isEmpty()) {
			List<GroupStudent> students= stuGroupMapper.queryGroupMsgByGroupId(groupId.get(0));
			this.SetSuccess();
			this.responseBody.put("list", students);
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "无信息");		
		}
		return this.responseBody;
	}
	
	
	public Map<String, Object> 	queryTotalNum() throws DataAccessException {
		this.responseBody.remove("list");
		List<CampusStudent> students = stuGroupMapper.queryAllStudent();
		if(!students.isEmpty()) {
			this.SetSuccess();
			this.responseBody.put("list", students.size());
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "无信息");		
		}
		return this.responseBody;
	}
	public Map<String, Object> 	resetDivide() throws DataAccessException {
		this.responseBody.remove("list");
		int res = stuGroupMapper.deleteAll();
		if(res != 0) {
			this.SetSuccess();
			return divide();
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "无信息");		
		}
		return this.responseBody;
	}

	//学生分组
	public Map<String, Object> 	divide() throws DataAccessException {
		this.responseBody.remove("list");
		List<GroupMsg> groupMsg = stuGroupMapper.queryMsg();
		if(!groupMsg.isEmpty()) {
			//0.获取数据
			// int groupStuNum = Integer.parseInt(groupMsg.get(0).getGroupStuNum());   //每组学生数量
			int groupNum = Integer.parseInt(groupMsg.get(0).getGroupNum());   		 //组数
			List<CampusStudent> raw_students = stuGroupMapper.queryAllStudent();		//所有学生
            List<Student> students = new GroupUtil().grouping(raw_students, groupNum);
            System.out.println("end");
            //写入到数据库
            for(Student student:students){
                CampusStudent campusStudent=raw_students.get(student.getNo());
                stuGroupMapper.insertGroupStu(campusStudent.getUserName(), campusStudent.getStuName(), String.valueOf(student.getGroup()), campusStudent.getStuSchool());
            }

        }
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "分组失败");		
		}
		return this.responseBody;
	}


}
