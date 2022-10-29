package board;

import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.sql.Timestamp;
import java.time.LocalDateTime;

@Slf4j
public class MainTest {

    private static final Logger logger = LoggerFactory.getLogger(MainTest.class);
    public static void main(String[] args) {
        Timestamp timestamp = new Timestamp(System.currentTimeMillis()); // 현재 날짜 출력

        System.out.println("timestamp: " + Timestamp.valueOf(LocalDateTime.now()));

        logger.info(".........logger test");

        String fileUUIDName = "cbcc199b-8817-47b1-81a2-6bca65f76f4c_horse.jpg";

        String fileName = fileUUIDName.substring(fileUUIDName.indexOf("_")+1);
        System.out.println("fileName: "+ fileName);

        String path = System.getProperty("user.dir");
        System.out.println("path: "+ path);

        String UPLOAD_DIRECTORY = "upload";


//        String uploadPath = "C:\\WebStudy\\WebDevelement\\JSP\\board_jsp\\upload";

        String uploadPath = System.getProperty("user.dir")
                + File.separator
                + UPLOAD_DIRECTORY;

        System.out.println("uploadPath: "+ uploadPath);


    }
}
