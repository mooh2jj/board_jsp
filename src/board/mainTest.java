package board;

import java.sql.Timestamp;
import java.time.LocalDateTime;

public class mainTest {
    public static void main(String[] args) {
        Timestamp timestamp = new Timestamp(System.currentTimeMillis()); // 현재 날짜 출력

        System.out.println("timestamp: "+ Timestamp.valueOf(LocalDateTime.now()));
    }
}
