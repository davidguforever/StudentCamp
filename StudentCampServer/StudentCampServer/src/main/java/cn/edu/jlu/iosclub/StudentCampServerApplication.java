package cn.edu.jlu.iosclub;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan(basePackages = {"cn.edu.jlu.iosclub.mapper"})
public class StudentCampServerApplication {
	public static void main(String[] args) {
		SpringApplication.run(StudentCampServerApplication.class, args);
	}

}
