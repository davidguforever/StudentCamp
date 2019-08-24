package cn.edu.jlu.iosclub.model;

public class Student {
    int no;
    int school;
    int major; // 0: UI设计类; 1: 技术编程类;2: 其它;
    int gender; //0 : 女; 1 :男; 2: 其它（未填写或错误）
    int grade;// 0: 其它; 1: 大一; 2: 大二~大四
    int schoolLevel;// 1: 重点; 2: 一般; 3: 职院或独立本科
    int group;

    public Student() {
    }

    public Student(int no, int school, int major, int gender, int grade, int schoolLevel, int group) {
        this.no = no;
        this.school = school;
        this.major = major;
        this.gender = gender;
        this.grade = grade;
        this.schoolLevel = schoolLevel;
        this.group = group;
    }

    @Override
    public String toString() {
        return "Student{" +
                "no=" + no +
                ", school=" + school +
                ", major=" + major +
                ", gender=" + gender +
                ", grade=" + grade +
                ", schoolLevel=" + schoolLevel +
                ", group=" + group +
                '}';
    }

    public int getNo() {
        return no;
    }

    public void setNo(int no) {
        this.no = no;
    }

    public int getSchool() {
        return school;
    }

    public void setSchool(int school) {
        this.school = school;
    }

    public int getMajor() {
        return major;
    }

    public void setMajor(int major) {
        this.major = major;
    }

    public int getGender() {
        return gender;
    }

    public void setGender(int gender) {
        this.gender = gender;
    }

    public int getGrade() {
        return grade;
    }

    public void setGrade(int grade) {
        this.grade = grade;
    }

    public int getSchoolLevel() {
        return schoolLevel;
    }

    public void setSchoolLevel(int schoolLevel) {
        this.schoolLevel = schoolLevel;
    }

    public int getGroup() {
        return group;
    }

    public void setGroup(int group) {
        this.group = group;
    }
}
