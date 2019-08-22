//相关的分组信息
package com.example.model;

public class GroupMsg {
	 private String tableId;
     private String groupNum;   		//组数
     private String groupStuNum;		//组学生数量
     private String stuSex;				//学生性别
     private String stuGrade;			//学生年级
     private String stuSchool;			//学生学校
     private String stuHobby;			//学生爱好
     private String isFinish;			//是否结束
	public String getTableId() {
		return tableId;
	}
	public void setTableID(String tableId) {
		this.tableId = tableId;
	}
	public String getGroupNum() {
		return groupNum;
	}
	public void setGroupNum(String groupNum) {
		this.groupNum = groupNum;
	}
	public String getGroupStuNum() {
		return groupStuNum;
	}
	public void setGroupStuNum(String groupStuNum) {
		this.groupStuNum = groupStuNum;
	}
	public String getStuSex() {
		return stuSex;
	}
	public void setStuSex(String stuSex) {
		this.stuSex = stuSex;
	}
	public String getStuGrade() {
		return stuGrade;
	}
	public void setStuGrade(String stuGrade) {
		this.stuGrade = stuGrade;
	}
	public String getStuSchool() {
		return stuSchool;
	}
	public void setStuSchool(String stuSchool) {
		this.stuSchool = stuSchool;
	}
	public String getStuHobby() {
		return stuHobby;
	}
	public void setStuHobby(String stuHobby) {
		this.stuHobby = stuHobby;
	}
	public String getIsFinish() {
		return isFinish;
	}
	public void setIsFinish(String isFinish) {
		this.isFinish = isFinish;
	}
     
}
