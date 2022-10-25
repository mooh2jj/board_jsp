<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
isELIgnored="false"
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="board.BoardDAO"%>
<%@ page import="board.Board"%>
<%@ page import="java.util.List" %>
<%@ page import="common.PageDTO" %>
<%@ page import="java.sql.SQLException" %>

<%
    request.setCharacterEncoding("UTF-8");
    String searchOption = request.getParameter("searchOption");
    String keyword = request.getParameter("keyword");
    BoardDAO boardDAO = new BoardDAO();

    // 페이지 설정 추가
    String pageNumStr = request.getParameter("pageNum");
    System.out.println("pageNumStr: "+ pageNumStr);
    int total = 0;        // 총 카운트=게시글 총 갯수
    int amount = 10;      // 페이지에 보여질 갯수
    try {
        total = boardDAO.getCnt();
    } catch (SQLException e) {
        throw new RuntimeException(e);
    }
    PageDTO pageDTO = new PageDTO(pageNumStr, amount, total);

    int pageNum = pageDTO.getPageNum();
    int startNum = pageDTO.getStartNum();
    int startPage = pageDTO.getStartPage();
    int endPage = pageDTO.getEndPage();
    int realEnd = pageDTO.getRealEnd();
    boolean prev = pageDTO.isPrev();
    boolean next = pageDTO.isNext();

    List<Board> list = null;
    try {
        list = boardDAO.getList(searchOption, keyword, startNum, amount);
        System.out.println("list.jsp, list: "+ list);
    } catch (SQLException e) {
        throw new RuntimeException(e);
    }
%>

<c:set var="searchOption" value="<%=searchOption%>" />
<c:set var="keyword" value="<%=keyword%>" />
<c:set var="pageNum" value="<%=pageNum%>" />
<c:set var="amount" value="<%=amount%>" />
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>게시판 목록</title>
    <style>
        ul {
            list-style: none;
            width : 30%;
            display: inline-block;
        }

        li {
            float: left;
            margin-left : 5px;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.1.min.js" integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous"></script>
</head>
<body>
<h2>게시판 - 목록</h2>
    <br>

    <form align="left" id="searchForm" method="get" action="list.jsp">
        <select name="searchOption">
            <option value="all" <c:out value="${searchOption eq 'all'?'selected':''}"/>>제목+작성자+내용</option>
            <option value="title" <c:out value="${searchOption eq 'title'?'selected':''}"/>>제목</option>
            <option value="writer" <c:out value="${searchOption eq 'writer'?'selected':''}"/>>작성자</option>
            <option value="content" <c:out value="${searchOption eq 'content'?'selected':''}"/>>내용</option>
        </select>
        <input type="text" name="keyword" style="width: 290px;" placeholder="검색어를 입력해주세요. (제목+작성자+내용)">
        <input type='hidden' name='pageNum' value='<c:out value="${pageNum}"/>' />
        <input type='hidden' name='amount' value='<c:out value="${amount}"/>' />
        <input type="submit" value="검색"/>
    </form>

    <br>
    총 <%=total%>건
    <br>
    <div class="container">
        <div class="row">
            <table class="table table-striped"
                   style="text-align: center; border: 1px solid #dddddd;">
                <tr>
                    <th style="background-color: #eeeeee; text-align: center">카테고리</th>
                    <th style="background-color: #eeeeee; text-align: center">&nbsp;</th>
                    <th style="background-color: #eeeeee; text-align: center">제목</th>
                    <th style="background-color: #eeeeee; text-align: center">작성자</th>
                    <th style="background-color: #eeeeee; text-align: center">조회수</th>
                    <th style="background-color: #eeeeee; text-align: center">등록 일시</th>
                    <th style="background-color: #eeeeee; text-align: center">수정 일시</th>
                </tr>
            <c:forEach var="board" items="<%=list%>">
                <tr>
                    <td>${board.category}</td>
                    <c:choose>
                        <c:when test="${board.fileYn}">
                            <td><img src="/img/file_img.png"  alt=""></td>
                        </c:when>
                        <c:otherwise>
                            <td>&nbsp;</td>
                        </c:otherwise>
                    </c:choose>
                    <td style="text-overflow:ellipsis; overflow:hidden; white-space:nowrap; max-width: 500px"><a href="view.jsp?id=${board.id}&pageNum=<%=pageNum%>">${board.title}</a></td>
                    <td>${board.writer}</td>
                    <td>${board.hit}</td>
                    <td><fmt:formatDate pattern="yyyy.MM.dd HH:mm:ss" value="${board.createdAt}"/></td>
                    <c:choose>
                        <c:when test="${board.updatedAt ne null}">
                            <td><fmt:formatDate pattern="yyyy.MM.dd HH:mm:ss" value="${board.updatedAt}"/></td>
                        </c:when>
                        <c:otherwise>
                            <td style="text-align: center">-</td>
                        </c:otherwise>
                    </c:choose>
                </tr>
            </c:forEach>
            </table>
<%--            <%
                for(int i=1; i<=total; i++){ %>
            <a href="list.jsp?pageNum=<%=i %>">[<%=i%>]</a>
            <% } %>--%>

            <%
                System.out.println("list view pageNum: "+ pageNum);
                System.out.println("list view prev: "+ prev +", next: "+ next);
            %>
            <div>
                <ul class="pagination">
                    <c:if test="<%=prev%>">
                        <li class="pagination_button prev">
                            <a href="list.jsp?pageNum=<%=1%>&amount=<%=amount%>">&lt;&lt;</a>
                            <a href="list.jsp?pageNum=<%=startPage - 1 %>&amount=<%=amount%>">&lt;</a>
                        </li>
                    </c:if>

                    <c:forEach var="num" begin="<%=startPage%>" end="<%=endPage%>">
                        <c:choose>
                            <c:when test="${ num == pageNum }">
                                <li class="pagination_button">
                                <a>${num}</a>
                                </li>
                            </c:when>
                            <c:when test="${ num != pageNum }">
                                <li class="pagination_button next">
                                    <a href="list.jsp?pageNum=${num}&amount=<%=amount%>">${num}</a>
                                </li>
                            </c:when>
                        </c:choose>
                    </c:forEach>

                    <c:if test="<%=next%>">
                        <li class="pagination_button">
                            <a href="list.jsp?pageNum=<%=endPage + 1%>&amount=<%=amount%>">&gt;</a>
                            <a href="list.jsp?pageNum=<%=realEnd%>&amount=<%=amount%>">&gt;&gt;</a>
                        </li>
                    </c:if>
                </ul>
            </div>
            <%-- TODO: 검색시, 페이징이동해도 검색유지 처리  --%>
            <form id='actionForm' action="list.jsp" method='get'>
                <input type='hidden' name='pageNum' value='${pageNum}'>
                <input type='hidden' name='amount' value='${amount}'>
                <input type='hidden' name='searchOption' value='<c:out value="${searchOption}"/>'>
                <input type='hidden' name='keyword' value='<c:out value="${keyword}"/>'>
            </form>

            <a href="write.jsp?pageNum=${pageNum}" class="btn btn-primary pull-right">등록</a>
        </div>
    </div>

<script>
    $(document).ready(function () {

        var searchForm = $("#searchForm");

        $("#searchForm button").on("click", function(e) {

                if (!searchForm.find("option:selected").val()) {
                    alert("검색종류를 선택하세요");
                    return false;
                }

                if (!searchForm.find("input[name='keyword']").val()) {
                    alert("키워드를 입력하세요");
                    return false;
                }

                searchForm.find("input[name='pageNum']").val("1");
                e.preventDefault();
                searchForm.submit();

            });

        var actionForm = $("#actionForm");

        $(".paginate_button a").on("click", function(e) {
                e.preventDefault();
                console.log('click');

                actionForm.find("input[name='pageNum']").val($(this).attr("href"));
                actionForm.submit();
            });
    });
</script>
</body>
</html>
