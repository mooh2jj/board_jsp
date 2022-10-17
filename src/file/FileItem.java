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
    private Long boardId;
    private String fileName;
    private String originName;
    private Timestamp createdAt;



}
