package connection;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;


public class DBConnectionUtil {
    private static final Logger log = LoggerFactory.getLogger(DBConnectionUtil.class);

    // DriverManager 사용
/*    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            log.info("get connection={}, class={}",connection, connection.getClass());
            return connection;
        } catch (Exception e) {
            throw new IllegalStateException(e);
        }
    }*/

    /**
     * DataSource(ConnectionPool 사용)
     * @return
     */
    public static Connection getConnection() {
        try {
            Context init = new InitialContext();
            DataSource dataSource = (DataSource) init.lookup("java:comp/env/jdbc/mysql");
            Connection connection = dataSource.getConnection();
            log.info("get connection={}, class={}",connection, connection.getClass());
            return connection;
        } catch (Exception e) {
            throw new IllegalStateException(e);
        }
    }

    /**
     * 커넥션 객체 반환하기 위한 close 메서드
     * @param con
     * @param pstmt
     * @param rs
     */
    public static void close(Connection con, PreparedStatement pstmt, ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();   // SQLException 터져도 여기서 나올 수 있어
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        if (pstmt != null) {
            try {
                pstmt.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        if (con != null) {
            try {
                con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
