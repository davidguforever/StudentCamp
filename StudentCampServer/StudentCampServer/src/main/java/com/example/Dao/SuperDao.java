package com.example.Dao;

import java.util.HashMap;
import java.util.Map;

public class SuperDao {
	public Map<String, Object> responseBody = new HashMap<String, Object>();
	public SuperDao() {
		this.responseBody.put("result", "SUCCESS");
		this.responseBody.put("errorMessage", "");
	}
	public void SetSuccess()
	{
		this.responseBody.put("result", "SUCCESS");
		this.responseBody.put("errorMessage", "");
	}
	public void SetError()
	{
		this.responseBody.put("result", "ERROR");
	}
}
