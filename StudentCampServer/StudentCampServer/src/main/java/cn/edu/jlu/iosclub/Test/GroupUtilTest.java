package cn.edu.jlu.iosclub.Test;

import cn.edu.jlu.iosclub.util.GroupUtil;
import org.junit.Assert;
import org.junit.jupiter.api.Test;

class GroupUtilTest {
    GroupUtil groupUtil = new GroupUtil();
    @Test
    void getSchoolId() {

        Assert.assertEquals(0,groupUtil.getSchoolId("吉林大学"));

        Assert.assertEquals(1,groupUtil.getSchoolId("长春师范大学"));
        Assert.assertEquals(0,groupUtil.getSchoolId("吉林大学"));
    }

    @Test
    void getGender() {
        Assert.assertEquals(1,groupUtil.getGender("男"));
        Assert.assertEquals(0,groupUtil.getGender("女"));

    }

    @Test
    void getMajor() {
        Assert.assertEquals(0,groupUtil.getMajor("设计"));
        Assert.assertEquals(1,groupUtil.getMajor("计算机"));
        Assert.assertEquals(2,groupUtil.getMajor("法学"));
    }

    @Test
    void getGrade() {
        Assert.assertEquals(1,groupUtil.getGrade("大一"));
        Assert.assertEquals(2,groupUtil.getGrade("大三"));

    }

    @Test
    void getSchoolLevel() {
       Assert.assertEquals(1,groupUtil.getSchoolLevel("吉林大学"));
       Assert.assertEquals(1,groupUtil.getSchoolLevel("浙江大学"));
       Assert.assertEquals(0,groupUtil.getSchoolLevel("浙江学院"));
       Assert.assertEquals(2,groupUtil.getSchoolLevel("浙江超能力大学"));


    }
}