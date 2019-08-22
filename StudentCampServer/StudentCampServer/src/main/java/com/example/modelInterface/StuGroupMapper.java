package com.example.modelInterface;
import java.util.ArrayList;
import java.util.List;

import com.example.model.CampusManager;
import com.example.model.CampusStudent;
import com.example.model.CampusSchool;
import com.example.model.GroupMsg;
import com.example.model.GroupStudent;
import com.example.model.PunchClockManager;
import com.example.model.PunchClockStudent;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Update;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;
import org.springframework.dao.DataAccessException;

@Mapper

public interface StuGroupMapper {
		//查询分组信息
		@Select("Select * from group_manager")
		@Results(
		   value = {
				   @Result(id=true, column = "id",property = "tableId"),
		   }
		)
		List <GroupMsg> queryMsg()throws DataAccessException;
		
		//添加分组信息
		@Insert("insert into group_manager (groupNum, groupStuNum, stuSex,stuGrade,stuSchool,stuHobby) values (#{groupNum}, #{groupStuNum},#{stuSex},#{stuGrade},#{stuSchool},#{stuHobby})")
		int insert(@Param("groupNum") String groupNum, @Param("groupStuNum") String groupStuNum,@Param("stuSex") String stuSex,@Param("stuGrade") String stuGrade, @Param("stuSchool") String stuSchool,@Param("stuHobby") String stuHobby) throws DataAccessException;
		
		//更新分组信息
		@Update("update group_manager set groupNum=#{groupNum},groupStuNum=#{groupStuNum},stuSex=#{stuSex},stuGrade=#{stuGrade},stuSchool=#{stuSchool},stuHobby=#{stuHobby},isFinish='0'")
		int updateMsg(@Param("groupNum") String groupNum, @Param("groupStuNum") String groupStuNum,@Param("stuSex") String stuSex,@Param("stuGrade") String stuGrade, @Param("stuSchool") String stuSchool,@Param("stuHobby") String stuHobby) throws DataAccessException;
		
		//确认分组
		@Update("update group_manager set isFinish='1'")
		int updateIsFinish() throws DataAccessException;
		
		//拿到所有学生数据
		@Select("Select * from campus_student;")
		List <CampusStudent> queryAllStudent();
		
		//插入学生分组信息
		@Insert("insert into group_student (userName, stuName, groupId, schoolName) values (#{userName}, #{stuName},#{groupId},#{schoolName})")
		int insertGroupStu(@Param("userName") String userName, @Param("stuName") String stuName,@Param("groupId") String groupId,@Param("schoolName") String schoolName) throws DataAccessException;	
		//删除表中元素
		@Insert("delete from group_student")
		int deleteAll();
		//查询所有学生分组信息
		@Select("Select * from group_student")
		@Results(
			value = {
					@Result(id=true, column = "id",property = "tableId"),
				   }
				)
		List <GroupStudent> queryAllGroupStudent()throws DataAccessException;
		//根绝教师Id查学校名
		@Select("select stuSchool from campus_teacher where teacherId = #{teacherId}")
		List<String>  querySchoolByTeacher(@Param("teacherId") String teacherId);
	    //根据teacherId查询学生分组信息
		@Select("Select * from group_student where schoolName=#{schoolName}")
		@Results(
			value = {
					@Result(id=true, column = "id",property = "tableId"),
				   }
				)
		List <GroupStudent> queryGroupStudentBySchoolName(@Param("schoolName") String schoolName)throws DataAccessException;
		//查询单个学生分组信息
		@Select("Select groupId from group_student where userName=#{userName}")
		List <String> queryGroupIdByUserName(@Param("userName") String userName)throws DataAccessException;
		@Select("Select * from group_student where groupId=#{groupId}")
		@Results(
				value = {
						@Result(id=true, column = "id",property = "tableId"),
					   }
					)
		List <GroupStudent> queryGroupMsgByGroupId(@Param("groupId") String groupId)throws DataAccessException;
		//调整分组
		@Update("update group_student set groupId=#{groupId} where userName=#{userName}")
	    int updateStu(@Param("userName") String userName,@Param("groupId") String groupId) throws DataAccessException;
		
		//更新组号
		@Update("update campus_student set groupId= #{groupId} where userName=#{userName}")
	    int updateGroup(@Param("groupId") String groupId,@Param("userName") String userName) throws DataAccessException;
}
