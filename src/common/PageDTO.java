package common;

import lombok.Getter;
import lombok.ToString;

@Getter
@ToString
public class PageDTO {
    private final int total;            // 총 카운트=게시글 총 갯수
    private final int pageNum;          // 현재 페이지
    private final int startNum;         // mysql limit offset 용 (pageNum-1)*amount
    private final int startPage;        // 페이지에 보여질 시작페이지번호
    private int endPage;                // 페이지에 보여질 끝 페이지번호
    private final int realEnd;          // 제일 마지막 페이지번호
    private final boolean prev, next;   // 페이지 이전, 다음 있을지 불린값


    // 페이지 계산식
    public PageDTO(String pageNumStr, int amount, int total) {
        if (pageNumStr == null) {
            this.pageNum = 1;
        } else{
            this.pageNum = Integer.parseInt(pageNumStr);
            System.out.println("======pageNum: "+ this.pageNum);
        }

        this.startNum = (this.pageNum-1) * amount;
        this.total = total;

        this.endPage = ((int) Math.ceil((double) pageNum / (double) amount)) * amount;
        this.startPage = this.endPage - 9;
        
        this.realEnd = (int) Math.ceil((double) total / (double) amount);

        if(this.realEnd < this.endPage) {
            this.endPage = this.realEnd;
        }

        this.prev = this.startPage > 1;
        this.next = this.endPage < realEnd;

    }
}
