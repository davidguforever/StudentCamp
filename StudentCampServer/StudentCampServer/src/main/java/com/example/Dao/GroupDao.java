//分组
package com.example.Dao;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.HashMap;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.model.GroupMsg;
import com.example.model.CampusStudent;
import com.example.model.GroupStudent;
import com.example.model.PunchClockManager;
import com.example.model.PunchClockStudent;
import com.example.modelInterface.PunchClockMapper;
import com.example.modelInterface.StuGroupMapper;

@Service
@MapperScan("com.example.modelInterface.stuGroupMapper")
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
	
	int exchangeSex(String str)
	{
		if(str == "男")
			return 0;
		else return 1;
	}
	
	int exchangeHobby(String str)
	{
		if((str.indexOf("计算机") != -1) || (str.indexOf("软件") != -1)||(str.indexOf("通信") != -1)
				||(str.indexOf("大数据") != -1)||(str.indexOf("网络") != -1)||(str.indexOf("移动") != -1)||(str.indexOf("資管") != -1)
				||(str.indexOf("物联网") != -1)||(str.indexOf("信息") != -1)||(str.indexOf("資訊") != -1))
			return 0;
		else if((str.indexOf("设计") != -1) || (str.indexOf("媒体") != -1) )
			return 1;
		else return 2;
	}
	
	int exchangeGrade(String str)
	{
		if(str == "大一")
			return 0;
		else if(str == "大二")
			return 1;
		else if(str == "大三")
			return 2;
		else if(str == "大四")
			return 3;
		else 
			return 4;
	}
	
	//学生分组
	public Map<String, Object> 	divide() throws DataAccessException {
		this.responseBody.remove("list");
		List<GroupMsg> groupMsg = stuGroupMapper.queryMsg();
		if(!groupMsg.isEmpty()) {
			
			int stuSchool = Integer.parseInt(groupMsg.get(0).getStuSchool());
			int stuGrade = Integer.parseInt(groupMsg.get(0).getStuGrade());
			int stuHobby = Integer.parseInt(groupMsg.get(0).getStuHobby());
			int stuSex = Integer.parseInt(groupMsg.get(0).getStuSex());
			int maxScore = 4 * stuSchool + 2 * stuGrade + 3 * stuHobby + stuSex;
			
			int groupNum = Integer.parseInt(groupMsg.get(0).getGroupNum());   		 //组数
			int groupStuNum = Integer.parseInt(groupMsg.get(0).getGroupStuNum());   //每组学生数量
			
			List<CampusStudent> students = stuGroupMapper.queryAllStudent();		//所有学生
			Collections.shuffle(students);
			List<CampusStudent> modelStudents = new ArrayList();					//模板学生
			Random random =new Random();
				
			int sex_man = 0,sex_woman = 1;											//对应映射 性别 专业  年级
			int hobby_program = 0,hobby_art = 2,hobby_else = 3;
			int grade_one = 0,grade_two = 2,grade_three = 3,grade_four = 4;
			
			int[][] groupSex = new int[groupNum][groupStuNum];                                    //每组的响应情况存储结构
			int[][] groupHobby = new int[groupNum][groupStuNum];
			int[][] groupGrade = new int[groupNum][groupStuNum];
			String[][] groupSchool = new String[groupNum][groupStuNum];
			
			int sexMax = groupStuNum / 2;														  //每组各项数据的上限
			int groupHobbyMax = groupStuNum / 3;
			int groupGradeMax = groupStuNum / 4;
			
			int[] index = new int[groupNum];
			
			for(int i = 0 ;i < groupStuNum;i++)
				index[i] = 0;
			
			for(int i = 0;i < groupNum;++i)
			{
				int tmp = random.nextInt(students.size());
				CampusStudent tmpStu = students.get(tmp);
				modelStudents.add(tmpStu);
				Integer groupId = i + 1;
				
				groupSex[i][index[i]] = exchangeSex(tmpStu.getStuSex());
				groupHobby[i][index[i]] = exchangeHobby(tmpStu.getStuHobby());
				groupGrade[i][index[i]] = exchangeGrade(tmpStu.getStuGrade());
				groupSchool[i][index[i]++] = tmpStu.getStuSchool();
                //每组放进去第一个学生
				stuGroupMapper.insertGroupStu(tmpStu.getUserName(), tmpStu.getStuName(), groupId.toString(), tmpStu.getStuSchool());
				students.remove(tmp);
			}
			
			//将同学分到组中
			for(int i = 0; i < groupNum;++i)
			{
				for(int j = 1; j < groupStuNum;++j)
				{
					int max_j = 0;
					int max_sc = 0;
					int k;
					
					for(k = 0; k < students.size();++k)
					{
						CampusStudent tmpStu = students.get(k);
						int tmpStuSex = exchangeSex(tmpStu.getStuSex());
						int tmpStuHobby = exchangeHobby(tmpStu.getStuHobby());
						int tmpStuGrade = exchangeGrade(tmpStu.getStuGrade());
						// 性别 in
						int countSex = 0;
						int countHobby = 0;
						int countGrade = 0;
						
						int scoreSex = 0;
						int scoreHobby = 0;
						int scoreGrade = 0;
						int scoreSch = 0;
						
						
						for(int i2 = 0;i2 < j; i2++)
						{
							if(groupSex[i][i2] == tmpStuSex)
								countSex++;
						}
						if(countSex < sexMax)
							scoreSex = 1 * stuSex;
						// 年级 in
						for(int i2 = 0; i2 < j; i2++)
						{
							if(groupGrade[i][i2] == tmpStuGrade)
								countGrade++;
						}
						if(countGrade < groupGradeMax)
							scoreGrade = 2 * stuGrade;
						// 专业 in 
						for(int i2 = 0; i2 < j;i2++)
						{
							if(groupHobby[i][i2] == tmpStuHobby)
								countHobby++;
						}
						if(countHobby < groupHobbyMax)
							scoreHobby = 3 * stuHobby;
						// 学校 in
						boolean jump = false;
						for(int i2 = 0;i2 <j; i2++)
						{
							if(groupSchool[i][i2].equals(tmpStu.getStuSchool()))
							{
								jump = true;
								break;
							}
						}
						if(jump == false)
							scoreSch = 4 * stuSchool;
				
						int tmpStuScore = scoreSch + scoreSex + scoreGrade + scoreHobby;
						
						if(tmpStuScore == maxScore)
						{
							break;
						}
						if(max_sc < tmpStuScore)
						{
							max_j = k;
							max_sc = tmpStuScore;
						}
					}
					
					if(k == students.size())
					{
						CampusStudent tmpStu = students.get(max_j);
						Integer groupId = i + 1;
						
						groupSex[i][index[i]] = exchangeSex(tmpStu.getStuSex());
						groupHobby[i][index[i]] = exchangeHobby(tmpStu.getStuHobby());
						groupGrade[i][index[i]] = exchangeGrade(tmpStu.getStuGrade());
						groupSchool[i][index[i]++] = tmpStu.getStuSchool();
						
						stuGroupMapper.insertGroupStu(tmpStu.getUserName(), tmpStu.getStuName(), groupId.toString(), tmpStu.getStuSchool());
					//	stuGroupMapper.updateGroup(groupId.toString(), tmpStu.getUserName());
						students.remove(max_j);
					}
					else 
					{
						CampusStudent tmpStu = students.get(k);
						Integer groupId = i + 1;
						
						groupSex[i][index[i]] = exchangeSex(tmpStu.getStuSex());
						groupHobby[i][index[i]] = exchangeHobby(tmpStu.getStuHobby());
						groupGrade[i][index[i]] = exchangeGrade(tmpStu.getStuGrade());
						groupSchool[i][index[i]++] = tmpStu.getStuSchool();
						
						stuGroupMapper.insertGroupStu(tmpStu.getUserName(), tmpStu.getStuName(), groupId.toString(), tmpStu.getStuSchool());
					//	stuGroupMapper.updateGroup(groupId.toString(), tmpStu.getUserName());
						students.remove(k);
					}
				}
			}
			//处理剩余同学
			while(!students.isEmpty())
			{
				int tmp = random.nextInt(groupNum);
				CampusStudent tmpStu = students.get(0);
				Integer groupId = tmp + 1;
				stuGroupMapper.insertGroupStu(tmpStu.getUserName(), tmpStu.getStuName(), groupId.toString(), tmpStu.getStuSchool());
				//stuGroupMapper.updateGroup(groupId.toString(), tmpStu.getUserName());
				students.remove(0);
			}
			this.SetSuccess();
		}
		else {
			this.SetError();
			this.responseBody.put("errorMessage", "分组失败");		
		}
		return this.responseBody;
	}
}
