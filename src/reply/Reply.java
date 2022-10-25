package reply;

import lombok.Data;

import java.sql.Timestamp;

@Data
public class Reply {

    private int id;
    private Long boardId;
    private String replyText;
    private String replyer;
    private Timestamp repliedAt;

}
