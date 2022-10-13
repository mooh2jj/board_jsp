package board;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

public class BoardDAO {
    private Connection conn;
    private ResultSet rs;

//    Timestamp timestamp = new Timestamp(System.currentTimeMillis()); // 현재 날짜 출력

    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
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

    public Timestamp getTimeStamp() {
        String query = "SELECT NOW()";
        try {
            PreparedStatement pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getTimestamp(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null; // 데이터 베이스 오류
    }

    public int getNext() {
        String query = "SELECT id FROM Board ORDER BY id DESC";
        try {
            PreparedStatement pstmt = conn.prepareStatement(query);
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

    public int write(Board board) {
        String query = "INSERT INTO Board";
        query += " (id, category, title, content, writer, hit, createdAt, updatedAt)";
        query += " VALUES(?,?,?,?,?,?,?,?)";
        try {
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setLong(1, getNext());
            pstmt.setString(2, board.getCategory());
            pstmt.setString(3, board.getTitle());
            pstmt.setString(4, board.getContent());
            pstmt.setString(5, board.getWriter());
            pstmt.setInt(6, 0);
            pstmt.setTimestamp(7, getTimeStamp());    // TODO: date타입 insert 작업 추가
            pstmt.setTimestamp(8, null);
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // 데이터 베이스 오류
    }

    public List<Board> getList(){
        String query = "SELECT * FROM Board ORDER BY id DESC LIMIT 10";
        List<Board> list = new ArrayList<>();
        try {
            PreparedStatement pstmt = conn.prepareStatement(query);
//            pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Board board = new Board();
                board.setId(rs.getLong(1));
                board.setCategory(rs.getString(2));
                board.setTitle(rs.getString(3));
                board.setContent(rs.getString(4));
                board.setWriter(rs.getString(5));
                board.setHit(rs.getInt(6));
                board.setCreatedAt(rs.getTimestamp(7));
                board.setUpdatedAt(rs.getTimestamp(8));
                list.add(board);
                System.out.println("getList board: "+board);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Board getBoard(long id){
        String query = "SELECT * FROM Board WHERE id = ?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setLong(1, id);
            rs = pstmt.executeQuery();
            if(rs.next()) {
                Board board = new Board();
                board.setId(rs.getLong(1));
                board.setCategory(rs.getString(2));
                board.setTitle(rs.getString(3));
                board.setContent(rs.getString(4));
                board.setWriter(rs.getString(5));
                board.setHit(rs.getInt(6));
                board.setCreatedAt(rs.getTimestamp(7));
                board.setUpdatedAt(rs.getTimestamp(8));
                return board;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public int update(Board board) {
        String query = "UPDATE Board SET title=?, content=?, writer=?, updatedAt=?  WHERE id=?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, board.getTitle());
            pstmt.setString(2, board.getContent());
            pstmt.setString(3, board.getWriter());
            pstmt.setTimestamp(4, getTimeStamp()); // TODO: updatedAt now 처리
            pstmt.setLong(5, board.getId());
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // 데이터 베이스 오류
    }

    public int delete(long id) {
        String query = "DELETE FROM Board WHERE id = ?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setLong(1, id);
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // 데이터 베이스 오류
    }
}
