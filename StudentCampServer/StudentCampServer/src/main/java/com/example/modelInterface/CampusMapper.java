package com.example.modelInterface;
import java.util.ArrayList;
import java.util.List;

import com.example.model.CampusStudent;
import com.example.model.Content;
import com.example.model.User;
import com.example.model.CampusSchool;
import com.example.model.CampusManager;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Update;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;
import org.springframework.dao.DataAccessException;

@Mapper
public interface CampusMapper {
	//查询报名的相关信息
	@Select("Select * from campus_manager")
	@Results(
	   value = {
			   @Result(id=true, column = "id",property = "tableId"),
	   }
	)
	List <CampusManager> queryCampusMsg()throws DataAccessException;
	
	//添加报名相关信息
	@Insert("insert into campus_manager (totalNum, schoolNum, deadLine,isBegin) values (#{totalNum}, #{schoolNum},#{deadLine},'1') ")
	int insert(@Param("totalNum") String totalNum, @Param("schoolNum") String schoolNum,@Param("deadLine") String deadLine) throws DataAccessException;
	
	//更新相关信息
	@Update("update campus_manager set totalNum=#{totalNum},schoolNum=#{schoolNum},deadLine=#{deadLine},isBegin='1'")
	int updateCampusMag(@Param("totalNum") String totalNum,@Param("schoolNum") String schoolNum,@Param("deadLine") String deadLine) throws DataAccessException;
	
	//更新开始状态
	@Update("update campus_manager set isBegin=#{isBegin}")
    int updateIsBegin(@Param("isBegin") String isBegin) throws DataAccessException;
	
	//更新当前人数 自增 
	@Update("update campus_manager set tmpNum=tmpNum + '1' ")
	int updateTmpNumAdd() throws DataAccessException;
	
	//更新当前人数 自减
	@Update("update campus_manager set tmpNum=IF(tmpNum < 1, 0, tmpNum -1) ")
	int updateTmpNumSub() throws DataAccessException;
	
	//统计学校报名情况
	@Select("Select * from campus_teacher")
	@Results(
		value = {
			 @Result(id=true, column = "id",property = "tableID"),
			 @Result(id=true, column = "stuSchool",property = "tecSchool"),
			 @Result(id=true, column = "stuNum",property = "tecStuNum"),
			}
	)
	List <CampusSchool> queryCampusSchoolMsg()throws DataAccessException;
	
	// 教师对应学校报名情况
	@Select("Select * from campus_teacher where teacherId = #{teacherId}")
	@Results(
		value = {
			 @Result(id=true, column = "id",property = "tableID"),
			 @Result(id=true, column = "stuSchool",property = "tecSchool"),
			 @Result(id=true, column = "stuNum",property = "tecStuNum"),
				}
		)
	List <CampusSchool> queryCampusSchoolMsgByTecId(@Param("teacherId") String teacherId)throws DataAccessException;
	
	//教师表的添加
	@Insert("insert into campus_teacher (stuSchool, stuNum, teacherId) values (#{stuSchool}, #{stuNum})")
	int insertTec(@Param("stuSchool") String stuSchool, @Param("stuNum") String stuNu, @Param("teacherId") String teacherId) throws DataAccessException;
	
	//更新学校的报名情况
	@Update("update campus_teacher set stuSchool=#{stuSchool},stuNum=#{stuNum} where teacherId=#{teacherId}")
    int updateTec(@Param("stuSchool") String stuSchool,@Param("stuNum") String stuNum,@Param("teacherId") String teacherId) throws DataAccessException;
	
	//
	@Select("select stuSchool from campus_teacher where teacherId = #{teacherId}")

	List<String>  querySchoolByTeacher(@Param("teacherId") String teacherId);
	//统计本学校的学生情况 未审核
	@Select("select * from campus_student where stuSchool = #{stuSchool}")
	@Results(value={
			 @Result(id=true, column = "id",property = "tableId"),
			})
	ArrayList<CampusStudent>  queryStudentBySchool(@Param("stuSchool") String stuSchool);
	
	//审核学生 通过
	@Update("update campus_student set isCheck= '1' where userName=#{userName}")
    int confirmStuByStuUserName(@Param("userName") String userName) throws DataAccessException;
	
	//学生表的添加
	@Insert("insert into campus_student (stuName, stuSex, stuGrade, stuSchool, stuTel, stuHobby, stuMail, stuClub, userName) "
			+ "values (#{stuName}, #{stuSex},#{stuGrade}, #{stuSchool},#{stuTel}, #{stuHobby},#{stuMail}, #{stuClub},#{userName})")
	int insertCampusStudent(@Param("stuName") String stuName, @Param("stuSex") String stuSex, @Param("stuGrade") String stuGrade, 
			@Param("stuSchool") String stuSchool, @Param("stuTel") String stuTel, @Param("stuHobby") String stuHobby, @Param("stuMail") String stuMail
			, @Param("stuClub") String stuClub, @Param("userName") String userName) 
			throws DataAccessException;
	//更新 根据用户名
	@Update("update campus_student set stuName=#{stuName},stuSex=#{stuSex} ,stuGrade=#{stuGrade},stuSchool=#{stuSchool}"
			+ ",stuTel=#{stuTel},stuHobby=#{stuHobby},stuMail=#{stuMail},stuClub=#{stuClub},isCheck='0'"
			+ "where userName=#{userName}")
	int updateStu(@Param("stuName") String stuName,@Param("stuSex") String stuSex,@Param("stuGrade") String stuGrade,
			@Param("stuSchool") String stuSchool,@Param("stuTel") String stuTel,@Param("stuHobby") String stuHobby,
			@Param("stuMail") String stuMail,@Param("stuClub") String stuClub,@Param("userName") String userName) throws DataAccessException;
	
	//查询报名的相关信息
	//查看自己是否报名成功
	@Select("select * from campus_student where userName = #{userName}")
	@Results(value={
			 @Result(id=true, column = "id",property = "tableId"),
			})
	ArrayList<CampusStudent>  queryStuMsgByUserName(@Param("userName") String userName);
	 
}
