package board;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.sql.Timestamp;

@Getter
@Setter
@ToString
public class Board {
    private Long id;
    private String category;
    private String password;
    private String title;
    private String content;
    private String writer;
    private int hit;
    private boolean fileYn;
    private String fileUUID;
    private Timestamp createdAt;
    private Timestamp updatedAt;

}
