package com.example.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller

public class IndexController {
	@RequestMapping("/say")
	@ResponseBody
	public String index() {
		return "Welcome Spring Boot";
	}
	
}
