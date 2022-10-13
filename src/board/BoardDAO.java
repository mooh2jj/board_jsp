package board;

import java.sql.*;
import java.util.ArrayList;

public class BoardDAO {
    private Connection conn;
    private ResultSet rs;

    public BoardDAO() {
        try {
            String dbURL = "jdbc:mysql://localhost:3306/board_dsg?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=Asia/Seoul&characterEncoding=UTF-8";
            String dbID = "board_dsg";
            String dbPassword = "doseong9114!!";
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public String getDate() {
        String SQL = "SELECT NOW()";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getString(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ""; // 데이터 베이스 오류
    }

    public int getNext() {
        String SQL = "SELECT id FROM Board ORDER BY id DESC";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) + 1;
            }
            return 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // 데이터 베이스 오류
    }

    public int write(String category, String title, String content, String writer) {
        String SQL = "INSERT INTO Board";
        SQL += " (id, category, title, content, writer, hit)";
        SQL += " VALUES(?,?,?,?,?,?)";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setLong(1, getNext());
            pstmt.setString(2, category);
            pstmt.setString(3, title);
            pstmt.setString(4, content);
            pstmt.setString(5, writer);
            pstmt.setInt(6, 0);
//            pstmt.setString(7, getDate());    // TODO: date타입 insert 작업 추가
//            pstmt.setString(8, null);
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // 데이터 베이스 오류
    }

    public ArrayList<Board> getList(){
        String SQL = "SELECT * FROM Board ORDER BY id DESC LIMIT 10";
        ArrayList<Board> list = new ArrayList<Board>();
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
//            pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Board board = new Board();
//                board.setBbsID(rs.getInt(1));
                board.setCategory(rs.getString(2));
                board.setTitle(rs.getString(3));
                board.setContent(rs.getString(4));
                board.setWriter(rs.getString(5));
                board.setHit(rs.getInt(6));
                board.setCreatedAt(rs.getDate(7));
                board.setCreatedAt(rs.getDate(8));
                list.add(board);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
