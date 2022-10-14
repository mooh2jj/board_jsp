package board;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

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

    public int updateHit(Board board) {
        String query = "UPDATE board SET hit=hit+1 where id=?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setLong(1, board.getId());

            int resultCnt = pstmt.executeUpdate();
            pstmt.close();

            return resultCnt;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // 데이터 베이스 오류
    }

    public Timestamp getTimeStamp() {
        String query = "SELECT NOW()";
        try {
            PreparedStatement pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getTimestamp(1);
            }
            rs.close();
            pstmt.close();
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
            rs.close();
            pstmt.close();
            return 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // 데이터 베이스 오류
    }

    public int getFileNext() {
        String query = "SELECT id FROM File ORDER BY id DESC";
        try {
            PreparedStatement pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) + 1;
            }
            rs.close();
            pstmt.close();
            return 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // 데이터 베이스 오류
    }

    public int write(Board board) {
        String query = "INSERT INTO Board";
        query += " (id, category, title, content, writer, hit, file_name, createdAt, updatedAt)";
        query += " VALUES(?,?,?,?,?,?,?,?,?)";
        try {
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setLong(1, getNext());
            pstmt.setString(2, board.getCategory());
            pstmt.setString(3, board.getTitle());
            pstmt.setString(4, board.getContent());
            pstmt.setString(5, board.getWriter());
            pstmt.setInt(6, 0);
            pstmt.setString(7, board.getFileName());
            pstmt.setTimestamp(8, getTimeStamp());
            pstmt.setTimestamp(9, null);
            int resultCnt = pstmt.executeUpdate();
            pstmt.close();
            System.out.println("resultCnt: "+ resultCnt);

            return resultCnt;
        }
        catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // 데이터 베이스 오류
    }

    public List<Board> getList(String searchOption, String keyword){
        String query = "SELECT * FROM Board ";

        List<Board> list = new ArrayList<>();
        try {
            if(keyword != null && !keyword.equals("")) {
                // 전체 검색인 경우
                if ("all".equals(searchOption)) {
                    query += "WHERE 1=1 AND (" + "title LIKE '%" + keyword.trim() + "%'";
                    query += "OR content LIKE '%" + keyword.trim() + "%'";
                    query += "OR writer LIKE '%" + keyword.trim() + "%')";
                // 전체 검색이 아닌 경우
                } else {
                    query += "WHERE " + searchOption.trim() + " LIKE '%" + keyword.trim() + "%' ORDER BY id";
                }
            } else query += "ORDER BY id";

            System.out.println("getList query: "+query);
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
                board.setFileName(rs.getString(7));
                board.setCreatedAt(rs.getTimestamp(8));
                board.setUpdatedAt(rs.getTimestamp(9));
                list.add(board);
                System.out.println("getList board: "+board);
            }
            rs.close();
            pstmt.close();
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
                board.setFileName(rs.getString(7));
                board.setCreatedAt(rs.getTimestamp(8));
                board.setUpdatedAt(rs.getTimestamp(9));
                return board;
            }
            rs.close();
            pstmt.close();
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
            pstmt.setTimestamp(4, getTimeStamp());
            pstmt.setLong(5, board.getId());
            int resultCnt = pstmt.executeUpdate();
            pstmt.close();
            return resultCnt;
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
            int resultCnt = pstmt.executeUpdate();
            pstmt.close();

            return resultCnt;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // 데이터 베이스 오류
    }

/*    public int fileUpload(File file, long boardId) {
        String query = "INSERT INTO File";
        query += " (id, board_id, fileName, originFileName, size, createdAt)";
        query += " VALUES(?,?,?,?,?,?)";
        try {
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setLong(1, getFileNext());
            pstmt.setLong(2, boardId);
            pstmt.setString(3, file.getFileName());
            pstmt.setString(4, file.getOriginFileName());
            pstmt.setString(5, file.getSize());
            pstmt.setTimestamp(6, getTimeStamp());

            int resultCnt = pstmt.executeUpdate();
            pstmt.close();
            System.out.println("fileUpload resultCnt: "+resultCnt);
            return resultCnt;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // 데이터 베이스 오류
    }*/
}
