package file;

import java.sql.Timestamp;

public class File {

    private Long id;
    private Long board_id;
    private String fileName;
    private String originFileName;
    private Timestamp createdAt;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getBoard_id() {
        return board_id;
    }

    public void setBoard_id(Long board_id) {
        this.board_id = board_id;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getOriginFileName() {
        return originFileName;
    }

    public void setOriginFileName(String originFileName) {
        this.originFileName = originFileName;
    }


    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "File{" +
                "id=" + id +
                ", board_id=" + board_id +
                ", fileName='" + fileName + '\'' +
                ", originFileName='" + originFileName + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
