package file;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.sql.Timestamp;

@Getter
@Setter
@ToString
public class FileItem {

    private Long id;
    private String path;
    private String fileUUIDName;
    private String fileName;
    private Long size;
    private Long boardId;
    private Timestamp createdAt;

}
