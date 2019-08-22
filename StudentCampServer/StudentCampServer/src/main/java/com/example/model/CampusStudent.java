//报名营员表单
package com.example.model;

public class CampusStudent {
	private String tableId;
	private String stuName;      //学生姓名
	private String stuSex;       //学生性别
	
	private String stuSchool;
	private String stuTel;
	private String stuHobby;
	private String stuMail;
	private String stuClub;
	private String isCheck;      //是否通过审核
	private String createTime;   //报名时间
	private String userName;  
	private String stuGrade;     //学生年级
	//private String groupId;
	
	public String getStuName() {
		return stuName;
	}
	public void setStuName(String stuName) {
		this.stuName = stuName;
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
	public String getStuTel() {
		return stuTel;
	}
	public void setStuTel(String stuTel) {
		this.stuTel = stuTel;
	}
	public String getStuHobby() {
		return stuHobby;
	}
	public void setStuHobby(String stuHobby) {
		this.stuHobby = stuHobby;
	}
	public String getStuMail() {
		return stuMail;
	}
	public void setStuMail(String stuMail) {
		this.stuMail = stuMail;
	}
	public String getStuClub() {
		return stuClub;
	}
	public void setStuClub(String stuClub) {
		this.stuClub = stuClub;
	}
	public String getCreateTime() {
		return createTime;
	}
	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}
	public String getIsCheck() {
		return isCheck;
	}
	public void setIsCheck(String isCheck) {
		this.isCheck = isCheck;
	}
	public String getTableId() {
		return tableId;
	}
	public void setTableId(String tableId) {
		this.tableId = tableId;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	/*public String getGroupId() {
		return groupId;
	}
	public void setGroupId(String groupId) {
		this.groupId = groupId;
	}*/
}
