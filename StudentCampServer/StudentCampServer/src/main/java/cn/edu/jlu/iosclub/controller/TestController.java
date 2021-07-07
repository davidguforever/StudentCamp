package cn.edu.jlu.iosclub.controller;


import cn.edu.jlu.iosclub.Dao.GroupDao;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

//@RestController
public class TestController {
    @Autowired
    private GroupDao groupDao;
    /**
     * 用来测试分组
     * @param
     * @return
     */
    @RequestMapping(value="/testGroup")
    public Map<String, Object> testGroup() {


        return groupDao.divide();
    }
}
