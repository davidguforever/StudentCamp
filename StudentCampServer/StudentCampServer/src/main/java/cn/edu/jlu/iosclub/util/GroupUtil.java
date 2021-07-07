package cn.edu.jlu.iosclub.util;

import cn.edu.jlu.iosclub.Dao.GroupDao;
import cn.edu.jlu.iosclub.model.CampusStudent;
import cn.edu.jlu.iosclub.model.Student;

import java.lang.reflect.Array;
import java.util.*;

public class GroupUtil {
    private int CHECK_STRICT_LEVEL=5;
    private int ADJUST_NUM=1;
    private int SCHOOL_W=10000,SCHOOL_LEVEL_W=1000,MAJOR_W=100,GRADE_W=10,GENDER_W=1;
    private List<String> schools = new ArrayList<String>();
    private int  MAJOR_NUM=3,GENDER_NUM=3,GRADE_NUM=3,SCHOOL_LEVEL_NUM=3;
    private int[] sum_schoolLevel=new int[SCHOOL_LEVEL_NUM];//每类学校各有多少学生
    private int[] sum_majors=new int[MAJOR_NUM];//每类专业各有多少学生
    private int[] sum_gender=new int[GENDER_NUM];//每类性别各有多少学生
    private int[] sum_grade=new int[GRADE_NUM];//每类班级各有多少学生

    private int[] mean_schoolLevelPerGroup=new int[SCHOOL_LEVEL_NUM];//每类学校各有多少学生/每组
    private int[] mean_majorsPerGroup=new int[MAJOR_NUM];//每类专业各有多少学生/每组
    private int[] mean_genderPerGroup=new int[GENDER_NUM];//每类性别各有多少学生/每组
    private int[] mean_gradePerGroup=new int[GRADE_NUM];//每类班级各有多少学生/每组

    private double[] dmean_schoolLevelPerGroup=new double[SCHOOL_LEVEL_NUM];//每类学校各有多少学生/每组
    private double[] dmean_majorsPerGroup=new double[MAJOR_NUM];//每类专业各有多少学生/每组
    private double[] dmean_genderPerGroup=new double[GENDER_NUM];//每类性别各有多少学生/每组
    private double[] dmean_gradePerGroup=new double[GRADE_NUM];//每类班级各有多少学生/每组

    private String[] goodSchools=
            {
            "清华大学","北京大学","中国人民大学","北方交通大学","北京工业大学","北京航空航天大学","北京理工大学","北京科技大学","北京化工大学","北京邮电大学",
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
    public int getGender(String gender) {
        if(gender.contains("女"))
            return 0;
        else return 1;
    }
    public int getMajor(String major) {
        if((major.contains("设计")) || (major.contains("媒体")) )
            return 0;
        else  if((major.contains("计算机")) || (major.contains("软件"))||(major.contains("通信"))
                ||(major.contains("数据"))||(major.contains("网络"))||(major.contains("移动"))||(major.contains("資管"))
                ||(major.contains("物联网"))||(major.contains("信息"))||(major.contains("資訊")))
            return 1;
        else return 2;
    }
    public int getGrade(String grade) {
        if(grade.contains("大一") || grade.contains("1"))
            return 1;
        else if(grade.contains("大二") || grade.contains("2"))
            return 2;
        else if(grade.contains("大三") || grade.contains("3"))
            return 2;
        else if(grade.contains("大四") || grade.contains("4"))
            return 2;
        else
            return 0;
    }
    public int getSchoolLevel(String schoolname){
        int index=goodSchoolList.indexOf(schoolname);
        if(index!=-1)
            return 0;//重点学校
        else if(schoolname.contains("职业")
        ||(schoolname.contains("学院")))
            return 2;//职业学院
        return  1;//一般学校

    }
    public void getAvgInt(int[] sum,int[] avg,int groupNum){
        for(int i=0;i<sum.length;i++){
            avg[i]=sum[i]/groupNum;
            if(avg[i]*groupNum<sum[i])
                avg[i]++;
        }
    }
    public void getAvgDouble(int[] sum,double[] avg,int groupNum){
        for(int i=0;i<sum.length;i++){
            avg[i]=sum[i]*1.0/groupNum;
        }
    }
    public  List<Student> grouping(List<CampusStudent> raw_students ,int groupNum){
        int studentNum=raw_students.size() ;//学生总数

        //1. 数据预处理
        List<Student> students=new ArrayList<Student>();
        GroupUtil groupUtil = new GroupUtil();
        int i=0;
        for(CampusStudent raw_student:raw_students){
            Student student = new Student();
            //System.out.println(raw_student.toString());
            student.setNo(i);
            student.setSchool(groupUtil.getSchoolId(raw_student.getStuSchool()));
            student.setSchoolLevel(groupUtil.getSchoolLevel(raw_student.getStuSchool()));
            student.setGender(groupUtil.getGender(raw_student.getStuSex()));
            student.setGrade(groupUtil.getGrade(raw_student.getStuGrade()));
            student.setMajor(groupUtil.getMajor(raw_student.getStuHobby()));
            students.add(student);
            i++;
        }

        System.out.println("数据预处理后的学生数："+students.size());

        //2. 计算平均数
        getStaticsSum(students);
        getStaticsMean(students,groupNum);
        //打印统计结果
        {
            printStaticSum("所有学生",students);
            printStaticMean("所有学生");
        }
        //3.初始化group
        int maxStudentNumperGroup=studentNum/groupNum;
        Group[] groups =new Group[groupNum];
        for(int j=0;j<groupNum;j++){
            groups[j]= new Group();
            groups[j].maxStudentNum=maxStudentNumperGroup;
            if(j<studentNum%groupNum){
                groups[j].maxStudentNum++;
            }
        }
        //4. 排序
        students.sort(new Comparator<Student>() {
            @Override
            public int compare(Student a, Student b) {
                if(a.getSchoolLevel() < b.getSchoolLevel()) return -1;
                if(a.getSchoolLevel() == b.getSchoolLevel()){
                    if (a.getGrade() > b.getGrade() ) return -1;
                    if (a.getGrade() == b.getGrade()
                            && a.getMajor() < b.getMajor() ) return -1;
                }

                return 1;
            }
        });

        //5. 贪心法先生成一个解
        int strict = CHECK_STRICT_LEVEL;
        int[] used=new int[studentNum];//学生是否被分配
        for (i=0;i<studentNum;i++){
            used[i]=0;
        }
        for(int h = 0; h < studentNum;){    //插入studentNum次
            i = h % groupNum; //group: 0~groupNum-1 应该操作第i组

            int k=0;//遍历每个学生
            for(k=0;k<studentNum;k++){
                if(used[k]!=1 && checkGroupCanInsert(groups[i],students.get(k),strict)) {//插入第一个满足条件的学生
                    groups[i].students.add(students.get(k));
                    used[k]=1;
                    System.out.println(k+"插入到"+i+"组");
                    break;
                }
            }

            if(k >= studentNum) {
                strict--;//如果没有满足条件的学生，则降低要求
                System.out.println("降低要求，当前级别："+strict);
            }
            else h++;
            if(strict<0) {
                System.out.println("error");
                break;
            }
        }
        System.out.println("贪心法完成");
        //6. 调整N次

        //adjust
        Random r=new Random();
        int time=0;
        for (int adjust = 1; adjust <= ADJUST_NUM; adjust++) {
            int h = r.nextInt(studentNum);
            int k = r.nextInt(studentNum);
            if (h == k) continue;
            int hi = h % groupNum, hj = h / groupNum;
            int ki = k % groupNum, kj = k / groupNum;
            if (hi == ki) continue;
            double efv1 = getEFV(groups[hi]) + getEFV(groups[ki]);

            {
                Student shihj = groups[hi].students.get(hj);
                groups[hi].students.remove(hj);
                Student skikj = groups[ki].students.get(kj);
                groups[ki].students.remove(kj);
                groups[hi].students.add(skikj);
                groups[ki].students.add(shihj);
            }

            double efv2 = getEFV(groups[hi]) + getEFV(groups[ki]);

            if (efv1 <= efv2) {
                Student shihj = groups[hi].students.get(hj);
                groups[hi].students.remove(hj);
                Student skikj = groups[ki].students.get(kj);
                groups[ki].students.remove(kj);
                groups[hi].students.add(skikj);
                groups[ki].students.add(shihj);
            } else {
                time++;
            }
        }
        System.out.println("交换成功" + time+"次");

        for(i=0;i<groupNum;i++)
            for(Student student:groups[i].students)
                student.setGroup(i);
        int k=0;
        for(Group group:groups){
            //2. 计算平均数
            getStaticsSum(group.students);
            //打印统计结果
            {
                printStaticSum("第"+k+"组学生"+group.students.size()+"人   ",group.students);
            }
            k++;
        }
        //7. 提交到数据库
        return students;
    }


    void printStaticSum(String title){
        System.out.println("---------------------------------------------------------------");
        System.out.println("				"+title+"Sum");
        System.out.printf("%15s,%10s,%10s,%10s\n", "\\", "0", "1", "2");
        System.out.printf("%15s,%10d,%10d,%10d\n", "gender", sum_gender[0], sum_gender[1], 0);
        System.out.printf("%15s,%10d,%10d,%10d\n", "grade", sum_grade[0], sum_grade[1], sum_grade[2]);
        System.out.printf("%15s,%10d,%10d,%10d\n", "majors", sum_majors[0], sum_majors[1], sum_majors[2]);
        System.out.printf("%15s,%10d,%10d,%10d\n", "schoollevel", sum_schoolLevel[0], sum_schoolLevel[1], sum_schoolLevel[2]);

    }
    void printStaticSum(String title,List<Student> students){
        getStaticsSum(students);
        System.out.println("---------------------------------------------------------------");
        System.out.println("				"+title+"Sum,不同学校个数"+getSchoolNum(students));
        System.out.printf("%15s,%10s,%10s,%10s\n", "\\", "0", "1", "2");
        System.out.printf("%15s,%10d,%10d,%10d\n", "gender", sum_gender[0], sum_gender[1], 0);
        System.out.printf("%15s,%10d,%10d,%10d\n", "grade", sum_grade[0], sum_grade[1], sum_grade[2]);
        System.out.printf("%15s,%10d,%10d,%10d\n", "majors", sum_majors[0], sum_majors[1], sum_majors[2]);
        System.out.printf("%15s,%10d,%10d,%10d\n", "schoollevel", sum_schoolLevel[0], sum_schoolLevel[1], sum_schoolLevel[2]);

    }
    void printStaticMean(String title){
        System.out.println("				"+title+"mean统计");
        System.out.printf("%15s,%10s,%10s,%10s\n", "\\", "0", "1", "2");
        System.out.printf("%15s,%10d,%10d,%10d\n", "gender", mean_genderPerGroup[0], mean_genderPerGroup[1], 0);
        System.out.printf("%15s,%10d,%10d,%10d\n", "grade", mean_gradePerGroup[0], mean_gradePerGroup[1], mean_gradePerGroup[2]);
        System.out.printf("%15s,%10d,%10d,%10d\n", "majors", mean_majorsPerGroup[0], mean_majorsPerGroup[1], mean_majorsPerGroup[2]);
        System.out.printf("%15s,%10d,%10d,%10d\n", "schoollevel", mean_schoolLevelPerGroup[0], mean_schoolLevelPerGroup[1], mean_schoolLevelPerGroup[2]);

        System.out.println("				"+title+"mean-double统计");
        System.out.printf("%15s,%10s,%10s,%10s\n", "\\", "0", "1", "2");
        System.out.printf("%15s,%10f,%10f,%10d\n", "gender", dmean_genderPerGroup[0], dmean_genderPerGroup[1], 0);
        System.out.printf("%15s,%10f,%10f,%10f\n", "grade", dmean_gradePerGroup[0], dmean_gradePerGroup[1], dmean_gradePerGroup[2]);
        System.out.printf("%15s,%10f,%10f,%10f\n", "majors", dmean_majorsPerGroup[0], dmean_majorsPerGroup[1], dmean_majorsPerGroup[2]);
        System.out.printf("%15s,%10f,%10f,%10f\n", "schoollevel", dmean_schoolLevelPerGroup[0], dmean_schoolLevelPerGroup[1], dmean_schoolLevelPerGroup[2]);

    }

    /**
     * 获得统计数据
     * @param students 传入待统计的学生列表
     */
    void getStaticsSum(List<Student> students) {
        int j;
        for (j = 0; j < SCHOOL_LEVEL_NUM; j++)
            sum_schoolLevel[j] = 0;
        for (j = 0; j < MAJOR_NUM; j++)
            sum_majors[j] = 0;
        for (j = 0; j < GRADE_NUM; j++)
            sum_grade[j] = 0;
        for (j = 0; j < GENDER_NUM; j++)
            sum_gender[j] = 0;
        for (Student student : students) {
            sum_schoolLevel[student.getSchoolLevel()]++;
            sum_gender[student.getGender()]++;
            sum_majors[student.getMajor()]++;
            sum_grade[student.getGrade()]++;
        }

    }

    /**
     * 获得平均数数据
     * @param students 待统计的学生列表
     * @param groupNum 一共有多少组
     */
    void getStaticsMean(List<Student> students ,int groupNum){
        getStaticsSum(students);
        getAvgInt(sum_gender, mean_genderPerGroup, groupNum);
        getAvgInt(sum_grade, mean_gradePerGroup, groupNum);
        getAvgInt(sum_majors, mean_majorsPerGroup, groupNum);
        getAvgInt(sum_schoolLevel, mean_schoolLevelPerGroup, groupNum);

        getAvgDouble(sum_gender, dmean_genderPerGroup, groupNum);
        getAvgDouble(sum_grade, dmean_gradePerGroup, groupNum);
        getAvgDouble(sum_majors, dmean_majorsPerGroup, groupNum);
        getAvgDouble(sum_schoolLevel, dmean_schoolLevelPerGroup, groupNum);
    }

    /**
     * 平方
     * @param x 要计算的数
     * @return x的平方
     */
    private double sq(double x){
        return x*x;
    }

    /**
     * 获得列表内不同学校的个数
     * @param students
     * @return
     */
    private int getSchoolNum(List<Student> students){
        ArrayList<Integer> schools = new ArrayList<Integer>();
        for(Student student:students){
            if(!schools.contains(student.getSchool())){
                schools.add(student.getSchool());
            }
        }
        return schools.size();
    }

    /**
     * 与均值差的加权平方和
     * @param g 要计算的组
     * @return
     */
    double getEFV(Group g)
    {
        //与均值差的加权平方和
        double efv,schoolEFV,schoolLevelEFV,majorEFV,gradeEFV,genderEFV;
        List<Student> studentsInGroupG = g.students;
        int j,k;

        //school
        schoolEFV = getSchoolNum(studentsInGroupG);
        schoolEFV = sq(studentsInGroupG.size() - schoolEFV);

        //school level
        for(j=1;j<SCHOOL_LEVEL_NUM;j++)
            sum_schoolLevel[j] = 0;

        for(Student eachStudent:studentsInGroupG)
            sum_schoolLevel[eachStudent.getSchoolLevel()]++;

        schoolLevelEFV = 0;
        for(j=1;j<SCHOOL_LEVEL_NUM;j++)
            schoolLevelEFV+=sq(sum_schoolLevel[j] - dmean_schoolLevelPerGroup[j]) ;

        //major
        for(j=0;j<MAJOR_NUM;j++)
            sum_majors[j] = 0;

        for(Student eachStudent:studentsInGroupG)
            sum_majors[eachStudent.getMajor()]++;

        majorEFV = 0;
        for(j=0;j<MAJOR_NUM;j++)
            majorEFV += sq(sum_majors[j] - dmean_majorsPerGroup[j]);


        //grade
        for(j=0;j<GRADE_NUM;j++)
            sum_grade[j] = 0;

        for(Student eachStudent:studentsInGroupG)
            sum_grade[eachStudent.getGrade()]++;

        gradeEFV = 0;
        for(j=0;j<GRADE_NUM;j++)
            gradeEFV += sq(sum_grade[j] - dmean_gradePerGroup[j]);

        //gender
        for(j=0;j<GENDER_NUM;j++)
            sum_gender[j] = 0;

        for(Student eachStudent:studentsInGroupG)
            sum_gender[eachStudent.getGender()]++;

        genderEFV = 0;
        for(j=0;j<GENDER_NUM;j++)
            genderEFV = sq(sum_gender[j] - dmean_genderPerGroup[j]);


        efv = SCHOOL_W * schoolEFV + SCHOOL_LEVEL_W * schoolLevelEFV
                + MAJOR_W * majorEFV + GRADE_W * gradeEFV + GENDER_W * genderEFV;

        return efv;
    }

    /**
     *
     * @param groupTocheck 将要插入的组
     * @param studentToInsert 将要插入的学生
     * @param strict 严格等级
     * @return 是否能插入 满足严格等级
     */
    Boolean checkGroupCanInsert(Group groupTocheck,Student studentToInsert,int strict){
        List<Student> studentsInGroupG = groupTocheck.students;

        //school
        if(strict > 0)
            for (Student eachStudent:studentsInGroupG)
                if(eachStudent.getSchool()==studentToInsert.getSchool()) {
                    System.out.println("出现重复学校");
                    return false;
                }

        //school level
        int j;
        if(strict > 1){
            for(j=1;j<SCHOOL_LEVEL_NUM;j++)
                sum_schoolLevel[j] = 0;

            for(Student eachStudent:studentsInGroupG)
                sum_schoolLevel[eachStudent.getSchoolLevel()]++;

            for(j=1;j<SCHOOL_LEVEL_NUM;j++)
                if(sum_schoolLevel[j] > mean_schoolLevelPerGroup[j])
                {
                    System.out.println("学校等级超出平均数"+j);
                    return false;
                }
        }

        //major
        if(strict > 2){
            for(j=0;j<MAJOR_NUM;j++)
                sum_majors[j] = 0;

            for(Student eachStudent:studentsInGroupG)
                sum_majors[eachStudent.getMajor()]++;

            for(j=0;j<MAJOR_NUM;j++)
                if(sum_majors[j] > mean_majorsPerGroup[j])
                {
                    System.out.println("专业超出平均值");
                    return false;
                }
        }

        //grade
        if(strict>3){
            for(j=0;j<GRADE_NUM;j++)
                sum_grade[j] = 0;

            for(Student eachStudent:studentsInGroupG)
                sum_grade[eachStudent.getGrade()]++;

            for(j=0;j<GRADE_NUM;j++)
                if(sum_grade[j] > mean_gradePerGroup[j])
                {
                    System.out.println("年纪超出平均时");
                    return false;
                }
        }
        //gender
        if(strict > 4){
            for(j=0;j<GENDER_NUM;j++)
                sum_gender[j] = 0;

            for(Student eachStudent:studentsInGroupG)
                sum_gender[eachStudent.getGender()]++;

            for(j=0;j<GENDER_NUM;j++)
                if(sum_gender[j] > mean_genderPerGroup[j])
                {
                    System.out.println("性别超出平均值");
                    return false;
                }
        }

        return true;
    }

    static class Group{
        int maxStudentNum;
        List<Student> students=new ArrayList<Student>();
    }
}
