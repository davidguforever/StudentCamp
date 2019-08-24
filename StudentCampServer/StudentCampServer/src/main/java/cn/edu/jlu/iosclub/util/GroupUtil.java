package cn.edu.jlu.iosclub.util;

import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class GroupUtil {
    List<String> schools = new ArrayList<String>();
    String[] goodSchools={"清华大学","北京大学","中国人民大学","北方交通大学","北京工业大学","北京航空航天大学","北京理工大学","北京科技大学","北京化工大学","北京邮电大学",
            "中国农业大学","北京林业大学","北京大学医学部","北京中医药大学","北京师范大学","北京外国语大学","对外经济贸易大学","中央民族大学","中央音乐学院",
            "中国传媒大学","中国石油大学","中国政法大学","中央财经大学","华北电力大学","北京体育大学","中国地质大学",
            "上海交通大学","复旦大学","华东师范大学","上海外国语大学","东华大学","上海财经大学","复旦大学医学院","同济大学","华东理工大学","上海大学",
            "南开大学","天津大学","天津医科大学",
            "重庆大学","西南大学",
            "河北工业大学",
            "太原理工大学",
            "内蒙古大学",
            "大连理工大学","东北大学","辽宁大学", "大连海事大学","东北林业大学",
            "吉林大学","东北师范大学","延边大学",
            "哈尔滨工业大学","哈尔滨工程大学","东北农业大学",
            "南京大学","东南大学","苏州大学", "南京师范大学", "中国矿业大学", "中国药科大学", "河海大学" ,"南京航空航天大学" ,"江南大学" ,"南京农业大学" ,"南京理工大学",
            "浙江大学",
            "中国科学技术大学" ,"安徽大学","合肥工业大学",
            "厦门大学","福州大学",
            "南昌大学",
            "山东大学","中国海洋大学","石油大学",
            "郑州大学",
            "武汉大学" ,"华中科技大学","中国地质大学","武汉理工大学","华中师范大学", "华中农业大学" ,"中南财经政法大学",
            "湖南大学","中南大学","湖南师范大学",
            "中山大学","暨南大学","华南理工大学","华南师范大学",
            "广西大学",
            "四川大学","西南交通大学","电子科技大学","四川农业大学","西南财经大学",
            "云南大学",
            "贵州大学",
            "西北大学","西安交通大学","西北工业大学","西安电子科技大学","长安大学","西北农林科技大学","陕西师范大学",
            "兰州大学",
            "新疆大学","石河子大学",
            "海南大学",
            "宁夏大学",
            "青海大学",
            "西藏大学",
            "第二军医大学","第四军医大学","国防科技大学" };

    List<String > goodSchoolList=new ArrayList<String>(Arrays.asList(goodSchools));
    public int getSchoolId(String schoolname){
        int index;
        if((index=schools.indexOf(schoolname))!=-1){
            return index;
        }
        else {
            schools.add(schoolname);
            return schools.size()-1;
        }
    }
    public int getGender(String gender)
    {
        if(gender == "女")
            return 0;
        else return 1;
    }

    public int getMajor(String major)
    {
        if((major.indexOf("设计") != -1) || (major.indexOf("媒体") != -1) )
            return 0;
        else  if((major.indexOf("计算机") != -1) || (major.indexOf("软件") != -1)||(major.indexOf("通信") != -1)
                ||(major.indexOf("数据") != -1)||(major.indexOf("网络") != -1)||(major.indexOf("移动") != -1)||(major.indexOf("資管") != -1)
                ||(major.indexOf("物联网") != -1)||(major.indexOf("信息") != -1)||(major.indexOf("資訊") != -1))
            return 1;
        else return 2;
    }

    public int getGrade(String grade)
    {
        if(grade == "大一")
            return 1;
        else if(grade == "大二")
            return 2;
        else if(grade == "大三")
            return 2;
        else if(grade == "大四")
            return 2;
        else
            return 3;
    }
    public int getSchoolLevel(String schoolname){
        int index=goodSchoolList.indexOf(schoolname);
        if(index!=-1)
            return 1;//重点学校
        else if(schoolname.indexOf("职业")!=-1||schoolname.indexOf("学院")!=-1)
            return 0;
        return  2;//一般学校

    }
}
