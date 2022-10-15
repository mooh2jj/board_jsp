package connection;

import java.sql.Connection;
import java.sql.DriverManager;

import static connection.ConnectionConst.*;


public class DBConnectionUtil {
    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            System.out.println("get connection=" + connection + ", class=" + connection.getClass());
            return connection;
        } catch (Exception e) {
            throw new IllegalStateException(e);
        }
    }
}
