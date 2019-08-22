//签到的管理层model
package com.example.model;

public class PunchClockManager {

	private String tableId;
	private String date;
	private String isBegin;
	private String longitude;
	private String latitude;
	
	public String getTableId() {
		return tableId;
	}
	public void setTableID(String tableID) {
		this.tableId = tableId;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public String getIsBegin() {
		return isBegin;
	}
	public void setIsBegin(String isBegin) {
		this.isBegin = isBegin;
	}
	public String getLongitude() {
		return longitude;
	}
	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}
	public String getLatitude() {
		return latitude;
	}
	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}
}
