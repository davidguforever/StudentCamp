package com.example.modelInterface;
import java.util.ArrayList;
import java.util.List;

import com.example.model.CampusManager;
import com.example.model.CampusStudent;
import com.example.model.PunchClockManager;
import com.example.model.PunchClockStudent;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Update;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;
import org.springframework.dao.DataAccessException;

@Mapper

public interface PunchClockMapper {
	//查询当日报名的相关信息
	@Select("Select * from sign_manager where date=#{date}")
	@Results(
	   value = {
			   @Result(id=true, column = "id",property = "tableId"),
	   }
	)
	List <PunchClockManager> querySignInMsgByDate(@Param("date") String date)throws DataAccessException;
	
	//开始报名
	@Insert("insert into sign_manager (date, longitude, latitude) values (#{date}, #{longitude},#{latitude})")
	int insert(@Param("date") String date, @Param("longitude") String longitude,@Param("latitude") String latitude) throws DataAccessException;
	
	//更新报名 更新相关信息
	@Update("update sign_manager set longitude=#{longitude},latitude=#{latitude},isBegin='1' where date=#{date}")
	int updateSignMsgByDate(@Param("date") String date,@Param("longitude") String longitude,@Param("latitude") String latitude) throws DataAccessException;
	
	//停止报名 更新当日的报名情况//更新相关信息
	@Update("update sign_manager set isBegin='0' where date=#{date}")
	int updateSignBeginByDate(@Param("date") String date) throws DataAccessException;
	
	//查询学校名的list
	@Select("Select Distinct stuSchool from campus_student;")
	List <String> querySchoolList();
	//查询对应学校出席人数情况
	@Select("Select stuName from sign_student where date=#{date} and stuSchool=#{stuSchool}")
	List <String> queryStudentBySchool(@Param("date") String date,@Param("stuSchool") String stuSchool);	
	
	//根据学校名查未出席的学生
	@Select("Select stuName from campus_student where stuSchool=#{stuSchool}"
			+ "and stuName not in (select stuName from sign_student where date=#{date} and stuSchool=#{stuSchool})")

	List <String> queryAbsentStudentBySchool(@Param("date") String date,@Param("stuSchool") String stuSchool);
	//学生签到
	@Insert("insert into sign_student (date, stuName, stuSchool, userName) values (#{date}, #{stuName},#{stuSchool},#{userName})")
	int insertStu(@Param("date") String date, @Param("stuName") String stuName,@Param("stuSchool") String stuSchool,@Param("userName") String userName) throws DataAccessException;	
	
	//更新学生的签到情况
	@Update("update sign_student set date=#{date},stuName=#{stuName},stuSchool=#{stuSchool} where userName=#{userName}")
    int updateStu(@Param("date") String date,@Param("stuName") String stuName,@Param("stuSchool") String stuSchool,@Param("userName") String userName) throws DataAccessException;
	
	//查询学生对应日期出席情况
	@Select("Select * from sign_student where date=#{date} or userName=#{userName}")
	@Results(
	   value = {
			   @Result(id=true, column = "id",property = "tableId"),
	   }
	)
	List <PunchClockStudent> queryStudentByUserName(@Param("date") String date,@Param("userName") String userName);
	//查询学生的所有出席日期
	@Select("Select date from sign_student where userName=#{userName}")
	List <String> queryStudentSignDateByUserName(@Param("userName") String userName);
	//根绝教师Id查学校名
	@Select("select stuSchool from campus_teacher where teacherId = #{teacherId}")
	List<String>  querySchoolByTeacher(@Param("teacherId") String teacherId);
	
	@Select("select * from campus_student where userName = #{userName}")
	@Results(value={
			 @Result(id=true, column = "id",property = "tableId"),
			})
	ArrayList<CampusStudent>  queryStuMsgByUserName(@Param("userName") String userName);
}
