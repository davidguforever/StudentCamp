//分组
package cn.edu.jlu.iosclub.Dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;

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
			int studentNum=raw_students.size() ;//学生总数

			//1. 数据预处理
			List<Student> students=new ArrayList<Student>();
			GroupUtil groupUtil = new GroupUtil();
			int i=0;
			for(CampusStudent raw_student:raw_students){
				Student student = new Student();
				//System.out.println(raw_student.toString());
				student.setNo(i);
				student.setSchool(groupUtil.getSchoolId(raw_student.getStuSchool()));
				student.setSchoolLevel(groupUtil.getSchoolLevel(raw_student.getStuSchool()));
				student.setGender(groupUtil.getGender(raw_student.getStuSex()));
				student.setGrade(groupUtil.getGrade(raw_student.getStuGrade()));
				student.setMajor(groupUtil.getMajor(raw_student.getStuHobby()));
				students.add(student);
				i++;
			}

			System.out.println("数据预处理后的学生数："+students.size());

			//2. 计算平均数
			int  MAJOR_NUM=3,GENDER_NUM=3,GRADE_NUM=3,SCHOOL_LEVEL_NUM=3;
			int[] sum_schoolLevel=new int[SCHOOL_LEVEL_NUM];//每类学校各有多少学生
			int[] sum_majors=new int[MAJOR_NUM];//每类专业各有多少学生
			int[] sum_gender=new int[GENDER_NUM];//每类性别各有多少学生
			int[] sum_grade=new int[GRADE_NUM];//每类班级各有多少学生

			int[] mean_schoolLevelPerGroup=new int[SCHOOL_LEVEL_NUM];//每类学校各有多少学生/每组
			int[] mean_majorsPerGroup=new int[MAJOR_NUM];//每类专业各有多少学生/每组
			int[] mean_genderPerGroup=new int[GENDER_NUM];//每类性别各有多少学生/每组
			int[] mean_gradePerGroup=new int[GRADE_NUM];//每类班级各有多少学生/每组

			double[] dmean_schoolLevelPerGroup=new double[SCHOOL_LEVEL_NUM];//每类学校各有多少学生/每组
			double[] dmean_majorsPerGroup=new double[MAJOR_NUM];//每类专业各有多少学生/每组
			double[] dmean_genderPerGroup=new double[GENDER_NUM];//每类性别各有多少学生/每组
			double[] dmean_gradePerGroup=new double[GRADE_NUM];//每类班级各有多少学生/每组

			for(Student student:students){
				sum_schoolLevel[student.getSchoolLevel()]++;
				sum_gender[student.getGender()]++;
				//System.out.println(student.getGender());
				sum_majors[student.getMajor()]++;
				sum_grade[student.getGrade()]++;
			}
			groupUtil.getAvgInt(sum_gender,mean_genderPerGroup,groupNum);
			groupUtil.getAvgInt(sum_grade,mean_gradePerGroup,groupNum);
			groupUtil.getAvgInt(sum_majors,mean_majorsPerGroup,groupNum);
			groupUtil.getAvgInt(sum_schoolLevel,mean_schoolLevelPerGroup,groupNum);

			groupUtil.getAvgDouble(sum_gender,dmean_genderPerGroup,groupNum);
			groupUtil.getAvgDouble(sum_grade,dmean_gradePerGroup,groupNum);
			groupUtil.getAvgDouble(sum_majors,dmean_majorsPerGroup,groupNum);
			groupUtil.getAvgDouble(sum_schoolLevel,dmean_schoolLevelPerGroup,groupNum);

			System.out.printf("%10s,%10s,%10s,%10s,%10s,%10s\n","type","group_num","gender" ,"grade","major","schoollevel");
			for(int j=0;j<3;j++){
				System.out.printf("%10s,%10d,%10d,%10d,%10d,%10d\n","sum",j,sum_gender[j],sum_grade[j] ,sum_majors[j],sum_schoolLevel[j]);
			}
			for(int j=0;j<3;j++) {
				System.out.printf("%10s,%10d,%10d,%10d,%10d,%10d\n", "avg_int",j, mean_genderPerGroup[j], mean_gradePerGroup[j], mean_majorsPerGroup[j], mean_schoolLevelPerGroup[j]);
			}
			for(int j=0;j<3;j++) {
				System.out.printf("%10s,%10d,%10f,%10f,%10f,%10f\n", "avg_double",j, dmean_genderPerGroup[j], dmean_gradePerGroup[j], dmean_majorsPerGroup[j], dmean_schoolLevelPerGroup[j]);
			}

			//3. 排序

			//4. 贪心法先生成一个解
			//5. 调整N次
			//6. 提交到数据库


		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "分组失败");		
		}
		return this.responseBody;
	}
}
