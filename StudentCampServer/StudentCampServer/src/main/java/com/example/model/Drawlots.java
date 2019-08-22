//答辩相关信息
package com.example.model;


public class Drawlots {
	
	private String tableId;
	//轮数
	private Integer turnnum;
	//每轮组数
	private Integer singlenum;
	//答辩顺序
	private String drawlist;
	//当前轮次
	private Integer tmpturn;
	public String getTableId() {
		return tableId;
	}
	public void setTableId(String tableId) {
		this.tableId = tableId;
	}

	public Integer getSinglenum() {
		return singlenum;
	}
	public void setSinglenum(Integer singlenum) {
		this.singlenum = singlenum;
	}
	public String getDrawlist() {
		return drawlist;
	}
	public void setDrawlist(String drawlist) {
		this.drawlist = drawlist;
	}
	public Integer getTmpturn() {
		return tmpturn;
	}
	public void setTmpturn(Integer tmpturn) {
		this.tmpturn = tmpturn;
	}
	public Integer getTurnnum() {
		return turnnum;
	}
	public void setTurnnum(Integer turnnum) {
		this.turnnum = turnnum;
	}

}
