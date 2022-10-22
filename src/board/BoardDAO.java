package board;

import file.FileItem;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.NoSuchElementException;

import static connection.DBConnectionUtil.close;
import static connection.DBConnectionUtil.getConnection;

public class BoardDAO {

    private static final Logger logger = LoggerFactory.getLogger(BoardDAO.class);
    /**
     * 조회수 증가
     * @param board
     * @return 최종 업데이트된 조회수
     * @throws SQLException
     */
    public int updateHit(Board board) throws SQLException {
        String query = "UPDATE board SET hit=hit+1 where id=?";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(query);
            pstmt.setLong(1, board.getId());
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            logger.error("db error", e);
            throw e;
        } finally {
            close(conn, pstmt, null);
        }
    }

    /**
     * 시간값 반환(등록일시, 수정일시)
     * @return Timestamp
     * @throws SQLException
     */
    public Timestamp getTimeStamp() throws SQLException {
        String query = "SELECT NOW()";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getTimestamp(1);
            } else {
                throw new RuntimeException("TimeStamp Now not function");
            }
        } catch (SQLException e) {
            logger.error("db error", e);
            throw e;
        } finally {
            close(conn, pstmt, rs);
        }
    }

    /**
     * pk increment
     * @return id+1
     * @throws SQLException
     */
    public int getNext() throws SQLException {
        String query = "SELECT id FROM Board ORDER BY id DESC";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) + 1;
            } else {
                throw new RuntimeException("getNext not found");
            }
        } catch (SQLException e) {
            logger.error("db error", e);
            throw e;
        } finally {
            close(conn, pstmt, rs);
        }
//        return -1; // 데이터 베이스 오류
    }
//    TODO: file_id 증가 처리
/*    public int getFileNext() {
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
    }*/

    /**
     * 게시판 글 등록
     * @param board
     * @return 1 or -1
     * @throws SQLException
     */
    public int write(Board board) throws SQLException {
        String query = "INSERT INTO Board";
        query += " (id, category, title, content, writer, hit, createdAt, updatedAt)";
        query += " VALUES(?,?,?,?,?,?,?,?)";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(query);
            pstmt.setLong(1, getNext());
            pstmt.setString(2, board.getCategory());
            pstmt.setString(3, board.getTitle());
            pstmt.setString(4, board.getContent());
            pstmt.setString(5, board.getWriter());
            pstmt.setInt(6, 0);
//            pstmt.setLong(7, board.getFileId());
            pstmt.setTimestamp(7, getTimeStamp());
            pstmt.setTimestamp(8, null);
            int resultCnt = pstmt.executeUpdate();
            System.out.println("resultCnt: " + resultCnt);

            return resultCnt;
        } catch (SQLException e) {
            logger.error("db error", e);
            throw e;
        } finally {
            close(conn, pstmt, null);
        }
    }

    /**
     * 총 게시글 갯수
     * @return 게시글 갯수 int
     * @throws SQLException
     */
    public int getCnt() throws SQLException {
        int result = 0;
        String query = "SELECT COUNT(*) FROM Board";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                result = rs.getInt(1);
                return result;
            } else {
                throw new RuntimeException("getCnt not function");
            }
        } catch (SQLException e) {
            logger.error("db error", e);
            throw e;
        } finally {
            close(conn, pstmt, rs);
        }
    }

    /**
     * 게시판 글 목록
     * @param searchOption
     * @param keyword
     * @param startNum
     * @param amount
     * @return 게시글 리스트
     * @throws SQLException
     */
    public List<Board> getList(String searchOption, String keyword, int startNum, int amount) throws SQLException {
        String query = "SELECT * FROM Board ";

        List<Board> list = new ArrayList<>();
        if (keyword != null && !keyword.equals("")) {   // TODO: "".부터, String.format()
            // 전체 검색인 경우
            if ("all".equals(searchOption)) {
                query += "WHERE 1=1 AND (" + "title LIKE '%" + keyword.trim() + "%' ";
                query += "OR content LIKE '%" + keyword.trim() + "%' ";
                query += "OR writer LIKE '%" + keyword.trim() + "%') ";

            // 전체 검색이 아닌 경우
            } else {
                query += "WHERE " + searchOption.trim() + " LIKE '%" + keyword.trim() + "%' ";
            }
        }
        query += "ORDER BY id DESC ";
        query += "LIMIT ?, ?";
        System.out.println("getList query: " + query);

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, startNum);
            pstmt.setInt(2, amount);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Board board = new Board();
                board.setId(rs.getLong("id"));
                board.setCategory(rs.getString("category"));
                board.setTitle(rs.getString("title"));
                board.setContent(rs.getString("content"));
                board.setWriter(rs.getString("writer"));
                board.setHit(rs.getInt("hit"));
//                board.setFileName(rs.getString("file_name"));
                board.setCreatedAt(rs.getTimestamp("createdAt"));
                board.setUpdatedAt(rs.getTimestamp("updatedAt"));

                list.add(board);
                System.out.println("getList list: " + list);
            }
            return list;
        } catch (SQLException e) {
            logger.error("db error", e);
            throw e;
        } finally {
            close(conn, pstmt, rs);
        }
    }

    /**
     * 1개 게시글 상세보기
     * @param id
     * @return 1개 board
     * @throws SQLException
     */
    public Board getBoard(long id) throws SQLException {
        String query = "SELECT * FROM Board WHERE id = ?";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        Board board = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(query);
            pstmt.setLong(1, id);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                board = new Board();
                board.setId(rs.getLong("id"));
                board.setCategory(rs.getString("category"));
                board.setTitle(rs.getString("title"));
                board.setContent(rs.getString("content"));
                board.setWriter(rs.getString("writer"));
                board.setHit(rs.getInt("hit"));
                board.setFileId(rs.getLong("file_id"));
                board.setCreatedAt(rs.getTimestamp("createdAt"));
                board.setUpdatedAt(rs.getTimestamp("updatedAt"));
                return board;
            } else {
                throw new NoSuchElementException("Board not found board=" + board);
            }
        } catch (SQLException e) {
            logger.error("db error", e);
            throw e;
        } finally {
            close(conn, pstmt, rs);
        }
    }

    /**
     * select 카테고리 모음
     * @return 카테고리 List
     * @throws SQLException
     */
    public List<String> getCategory() throws SQLException {
        String query = "SELECT category FROM board GROUP BY category ORDER BY category";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String category = "";
        List<String> list = new ArrayList<>();
        try {

            conn = getConnection();
            pstmt = conn.prepareStatement(query);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                category = rs.getString("category");
                list.add(category);
            }
        } catch (SQLException e) {
            logger.error("db error", e);
            throw e;
        } finally {
            close(conn, pstmt, rs);
        }
        return list;
    }

    /**
     * 게시글 글 수정
     * @param board
     * @return 수정 영향을 미친 값
     * @throws SQLException
     */
    public int update(Board board) throws SQLException {
        String query = "UPDATE Board SET title=?, content=?, writer=?, updatedAt=?  WHERE id=?";

        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, board.getTitle());
            pstmt.setString(2, board.getContent());
            pstmt.setString(3, board.getWriter());
            pstmt.setTimestamp(4, getTimeStamp());
            pstmt.setLong(5, board.getId());
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            logger.error("db error", e);
            throw e;
        } finally {
            close(conn, pstmt, null);
        }
    }

    /**
     * 게시글 글 1개 삭제
     * @param id
     * @return 1 or -1??
     * @throws SQLException
     */
    public int delete(long id) throws SQLException {
        String query = "DELETE FROM Board WHERE id = ?";

        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(query);
            pstmt.setLong(1, id);
            return pstmt.executeUpdate();
        } catch (SQLException e) {
            logger.error("db error", e);
            throw e;
        } finally {
            close(conn, pstmt, null);
        }
    }

    public int fileUpload(FileItem file) throws SQLException {
        String query = "INSERT INTO File";
        query += " (board_id, file_name, origin_name, createdAt)";
        query += " VALUES(?,?,?,?)";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(query);
            pstmt.setLong(1, file.getBoardId());
            pstmt.setString(2, file.getFileName());
            pstmt.setString(3, file.getOriginName());
            pstmt.setTimestamp(4, getTimeStamp());

            int resultCnt = pstmt.executeUpdate();
            System.out.println("fileUpload resultCnt: "+resultCnt);
            return resultCnt;
        } catch (SQLException e) {
            logger.error("db error", e);
            throw e;
        } finally {
            close(conn, pstmt, null);
        }
    }

}
