package file;

import board.Board;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import static connection.DBConnectionUtil.close;
import static connection.DBConnectionUtil.getConnection;

public class FileItemDAO {

    private static final Logger log = LoggerFactory.getLogger(FileItemDAO.class);

    public List<FileItem> getUUIDName(String fileUUID) throws SQLException {
        String query = "SELECT * FROM file_item\n" +
                "WHERE 1=1\n" +
                "AND SUBSTRING_INDEX(file_uuid_name,'_',1) = ?";

        List<FileItem> list = new ArrayList<>();

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(query);

            pstmt.setString(1, fileUUID);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                FileItem fileItem = new FileItem();
                fileItem.setId(rs.getLong("id"));
                fileItem.setPath(rs.getString("path"));
                fileItem.setFileUUIDName(rs.getString("file_uuid_name"));
                fileItem.setFileName(rs.getString("file_name"));
                fileItem.setSize(rs.getLong("size"));
                fileItem.setBoardId(rs.getLong("board_id"));
                fileItem.setCreatedAt(rs.getTimestamp("created_at"));

                list.add(fileItem);
                System.out.println("getList fileItem list: " + list);
            }
            return list;
        } catch (SQLException e) {
            log.error("db error", e);
            throw e;
        } finally {
            close(conn, pstmt, null);
        }
    }

    public int fileUpload(FileItem file) throws SQLException {
        String query = "INSERT INTO file_item";
        query += " (path, file_uuid_name, file_name, size, board_id, created_at)";
        query += " VALUES(?,?,?,?,?,?)";

        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(query);
            pstmt.setString(1, file.getPath());
            pstmt.setString(2, file.getFileUUIDName());
            pstmt.setString(3, file.getFileName());
            pstmt.setLong(4, file.getSize());
            pstmt.setLong(5, file.getBoardId());
            pstmt.setTimestamp(6, getTimeStamp());

            int resultCnt = pstmt.executeUpdate();
            log.info("fileUpload resultCnt: {}", resultCnt);
            return resultCnt;
        } catch (SQLException e) {
            log.error("db error", e);
            throw e;
        } finally {
            close(conn, pstmt, null);
        }
    }

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
