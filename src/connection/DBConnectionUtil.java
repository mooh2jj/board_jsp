package connection;

import lombok.extern.slf4j.Slf4j;

import java.sql.*;

import static connection.ConnectionConst.*;

@Slf4j
public class DBConnectionUtil {
    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
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
