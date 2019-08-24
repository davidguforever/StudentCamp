package cn.edu.jlu.iosclub.util;

import java.io.File;

public class FileUtil {
    /**
     * 获取图片名字
     * @param path 图片所在目录
     * @return 图片的名字
     */
    public static String getPicName(String path){
        String[] suffixnames={"jpg","png","gif","jpeg"};
        File pic_dir = new File(path);
        File[] files = pic_dir.listFiles();
        for(File file:files){
            for(String suf:suffixnames){
                if(file.getName().endsWith(suf)){
                    return file.getName();
                }
            }
        }
        return null;
    }

    /**
     * 删除path文件夹内的所有图片
     * @param path
     */
    public static void removePic(String path){
        String pic_name=null;
        while((pic_name=getPicName(path))!=null){
            new File(path+pic_name).delete();
        }
    }
}
