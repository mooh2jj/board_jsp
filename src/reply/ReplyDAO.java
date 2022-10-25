package reply;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import static connection.DBConnectionUtil.close;
import static connection.DBConnectionUtil.getConnection;

public class ReplyDAO {
    private static final Logger log = LoggerFactory.getLogger(ReplyDAO.class);


/*    public int update(Reply reply) throws SQLException {
        String query = "UPDATE Reply SET reply_text=?, replied_at=?  WHERE board_id=?;";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try{
            conn = getConnection();
            pstmt = conn.prepareStatement(query);

            pstmt.setString(1, reply.getReplyText());
            pstmt.setTimestamp(2, getTimeStamp());
            pstmt.setLong(3, reply.getBoardId());

            return pstmt.executeUpdate();

        }catch (SQLException e) {
            log.error("db error", e);
            throw e;
        } finally {
            close(conn, pstmt, null);
        }
    }*/

    /**
     * 댓글 등록
     * @param reply
     * @return
     * @throws SQLException
     */
    public int write(Reply reply) throws SQLException {
        String query = "INSERT INTO Reply";
        query += " (id, board_id, reply_text, replyer, replied_at)";
        query += " VALUES(?,?,?,?,?)";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, getNext());
            pstmt.setLong(2, reply.getBoardId());
            pstmt.setString(3, reply.getReplyText());
            pstmt.setString(4, reply.getReplyer());
            pstmt.setTimestamp(5, getTimeStamp());
            int resultCnt = pstmt.executeUpdate();
            System.out.println("resultCnt: " + resultCnt);

            return resultCnt;
        } catch (SQLException e) {
            log.error("db error", e);
            throw e;
        } finally {
            close(conn, pstmt, null);
        }
    }

    /**
     * 한 게시글에 댓글 목록 가져오기
     * @param boardId
     * @return List<Reply>
     * @throws SQLException
     */
    public List<Reply> getList(long boardId) throws SQLException {
        String query = "SELECT * FROM Reply WHERE board_id = ? ";

        List<Reply> list = new ArrayList<>();
        query += "ORDER BY id DESC";

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(query);
            pstmt.setLong(1, boardId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                Reply reply = new Reply();
                reply.setId(rs.getInt("id"));
                reply.setBoardId(rs.getLong("board_id"));
                reply.setReplyText(rs.getString("reply_text"));
                reply.setReplyer(rs.getString("replyer"));
                reply.setRepliedAt(rs.getTimestamp("replied_at"));

                list.add(reply);
                System.out.println("getReplyList: " + list);
            }
            return list;
        } catch (SQLException e) {
            log.error("db error", e);
            throw e;
        } finally {
            close(conn, pstmt, rs);
        }
    }

    /**
     * inset시 pk id +1 증가 처리
     * @return int
     * @throws SQLException
     */
    public int getNext() throws SQLException {
        String query = "SELECT id FROM reply ORDER BY id DESC";

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
            log.error("db error", e);
            throw e;
        } finally {
            close(conn, pstmt, rs);
        }
    }

    /**
     * NOW() 처리
     * @return Timestamp 타입 NOW()
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
            log.error("db error", e);
            throw e;
        } finally {
            close(conn, pstmt, rs);
        }
    }

}
