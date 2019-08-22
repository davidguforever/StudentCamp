//签到的学生Model
package com.example.model;

public class PunchClockStudent {
	private String tableId;
	private String date;
	private String stuName;
	private String stuSchool;
	private String userName;
	public String getTableId() {
		return tableId;
	}
	public void setTableId(String tableID) {
		this.tableId = tableID;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public String getStuName() {
		return stuName;
	}
	public void setStuName(String stuName) {
		this.stuName = stuName;
	}
	public String getStuSchool() {
		return stuSchool;
	}
	public void setStuSchool(String stuSchool) {
		this.stuSchool = stuSchool;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
}
