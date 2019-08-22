package Test;

import com.example.util.FileUtil;
import org.junit.Assert;
import org.junit.Test;
public class FileUtilTest {
    String pic_path="/Users/hp/Desktop/Pic/";
    @Test
    public void testGetPicName(){
        String name=FileUtil.getPicName(pic_path);
        Assert.assertEquals("DateImg.jpg",name);
    }
    @Test
    public void testRmPic(){
        FileUtil.removePic(pic_path);
    }
}
