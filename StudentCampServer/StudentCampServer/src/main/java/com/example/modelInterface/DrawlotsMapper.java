package com.example.modelInterface;

import java.util.List;

import com.example.model.Content;
import com.example.model.Drawlots;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Result;
import org.apache.ibatis.annotations.Results;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;
import org.springframework.dao.DataAccessException;
import org.apache.ibatis.annotations.Delete;
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
	
	//更新当前轮数 自增 
	@Update("update drawlots set tmpturn=tmpturn + '1' ")
	int updateTurn() throws DataAccessException;
	
	//重新抽签
	@Update("update drawlots set turnnum=#{turnnum},singlenum=#{singlenum},drawlist=#{drawlist},tmpturn='1'")
	int reset(@Param("turnnum") String turnnum,@Param("singlenum") String singlenum,@Param("drawlist") String drawlist) throws DataAccessException;
	
	//插入抽签
	@Insert("insert into drawlots (turnnum, singlenum, drawlist) values (#{turnnum}, #{singlenum}, #{drawlist})")
	int insert(@Param("turnnum") String turnnum, @Param("singlenum") String singlenum, @Param("drawlist") String drawlist);
}
