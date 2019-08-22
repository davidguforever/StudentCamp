package com.example.controller;

import com.example.util.FileUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
 
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.HashMap;
import java.util.Map;
 
@RestController
public class UploadDateImg {
    private static final Logger logger = LoggerFactory.getLogger(UploadDateImg.class);
  //  private String uploadDir = "/usr/student_camp";

    private String uploadDir = "/Users/hp/Desktop/Pic/";
    public Map<String, Object> responseBody = new HashMap<String, Object>();
	public void initres() {
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
 
    @RequestMapping(value = "/uploadImage")
    public Map<String, Object> uploadImage(@RequestParam(value = "file") MultipartFile file) throws RuntimeException {
    	initres();
        if (file.isEmpty()) {
        	SetError();
        	responseBody.put("errorMessage", "文件为空");
        }
        // 获取文件名
        String fileName = file.getOriginalFilename();
        logger.info("上传的文件名为：" + fileName);
        // 获取文件的后缀名
        String suffixName = fileName.substring(fileName.lastIndexOf("."));
        logger.info("上传的后缀名为：" + suffixName);
        // 文件上传后的路径
        String filePath = uploadDir;
        // 解决中文问题，liunx下中文路径，图片显示问题
        // fileName = UUID.randomUUID() + suffixName;

        //删除之前的图片
        FileUtil.removePic(uploadDir);
        //生成新的时间的戳文件名
        fileName="camp"+System.currentTimeMillis()+suffixName;

        File dest = new File(filePath + fileName);
        // 检测是否存在目录
        if (!dest.getParentFile().exists()) {
            dest.getParentFile().mkdirs();
        }
        try {
            file.transferTo(dest);
            logger.info("上传成功后的文件路径未：" + filePath + fileName);
            SetSuccess();
        } catch (IllegalStateException e) {
        	SetError();
        	responseBody.put("errorMessage", "数据异常");
            e.printStackTrace();
        } catch (IOException e) {
        	responseBody.put("errorMessage", "数据异常");
            e.printStackTrace();
        }
        return responseBody;
    }
 
    //文件下载相关代码
    @RequestMapping(value = "/downloadImage")
    public String downloadImage(String imageName,HttpServletRequest request, HttpServletResponse response) {
        //String fileName = "123.JPG";
        // 文件名改为直接获取，不再利用参数
        imageName= FileUtil.getPicName(uploadDir);
        logger.debug("the imageName is : "+imageName);
        String fileUrl = uploadDir+imageName;



        if (fileUrl != null) {
            //当前是从该工程的WEB-INF//File//下获取文件(该目录可以在下面一行代码配置)然后下载到C:\\users\\downloads即本机的默认下载的目录
           /* String realPath = request.getServletContext().getRealPath(
                    "//WEB-INF//");*/
            /*File file = new File(realPath, fileName);*/
            File file = new File(fileUrl);
            if (file.exists()) {
                response.setContentType("application/force-download");// 设置强制下载不打开
                response.addHeader("Content-Disposition",
                        "attachment;fileName=" + imageName);// 设置文件名
                byte[] buffer = new byte[1024];
                FileInputStream fis = null;
                BufferedInputStream bis = null;
                try {
                    fis = new FileInputStream(file);
                    bis = new BufferedInputStream(fis);
                    OutputStream os = response.getOutputStream();
                    int i = bis.read(buffer);
                    while (i != -1) {
                        os.write(buffer, 0, i);
                        i = bis.read(buffer);
                    }
                    System.out.println("success");
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (bis != null) {
                        try {
                            bis.close();
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                    if (fis != null) {
                        try {
                            fis.close();
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                }
            }
        }
        return null;
    }
    //询问是否有新图片
    @RequestMapping(value="/newPicName")
    public String getImageTime(HttpServletRequest request, HttpServletResponse response) {
	    String new_pic_name=FileUtil.getPicName(uploadDir);
	    if(new_pic_name==null){
	        return "no";
        }

        return new_pic_name;
    }


}