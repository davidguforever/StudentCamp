//营员总情况的表单
package com.example.model;

public class CampusManager {
	private String tableId;
	private String totalNum;      //总人数
	private String schoolNum;     //当前学校人数上限
	private String deadLine;      //截止日期
	private String isBegin;       //是否开始
	private String tmpNum;       //是否开始
	
	public String getTableId() {
		return tableId;
	}
	public void setTableId(String tableId) {
		this.tableId = tableId;
	}
	public String getTotalNum() {
		return totalNum;
	}
	public void setTotalNum(String totalNum) {
		this.totalNum = totalNum;
	}
	public String getSchoolNum() {
		return schoolNum;
	}
	public void setSchoolNum(String schoolNum) {
		this.schoolNum = schoolNum;
	}
	public String getDeadLine() {
		return deadLine;
	}
	public void setDeadLine(String deadLine) {
		this.deadLine = deadLine;
	}
	public String getIsBegin() {
		return isBegin;
	}
	public void setIsBegin(String isBegin) {
		this.isBegin = isBegin;
	}
	public String getTmpNum() {
		return tmpNum;
	}
	public void setTmpNum(String tmpNum) {
		this.tmpNum = tmpNum;
	}
	
	
}
