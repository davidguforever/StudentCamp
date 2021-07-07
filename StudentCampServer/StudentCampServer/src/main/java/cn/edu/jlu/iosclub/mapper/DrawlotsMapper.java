package cn.edu.jlu.iosclub.mapper;

import java.util.List;

import cn.edu.jlu.iosclub.model.Drawlots;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.springframework.dao.DataAccessException;
import org.apache.ibatis.annotations.Insert;

@Mapper
public interface DrawlotsMapper {
	//拿到当前答辩信息
	@Select("Select * from drawlots")
	@Results(
	   value = {
			   @Result(id=true, column = "id",property = "tableId")
	   }
	)
	List <Drawlots> query();

	//重新抽签
	@Update("update drawlots set drawlist=#{drawlist}")
	int reset(@Param("drawlist") String drawlist) throws DataAccessException;

	//插入抽签
	@Insert("insert into drawlots (drawlist) values ( #{drawlist})")
	int insert(@Param("drawlist") String drawlist);



}
