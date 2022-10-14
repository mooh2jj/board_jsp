<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
isELIgnored="false"
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="board.BoardDAO"%>
<%@ page import="board.Board"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.util.List" %>

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
</head>
<body>

    <%
        request.setCharacterEncoding("UTF-8");
        String searchOption = request.getParameter("searchOption");
        String keyword = request.getParameter("keyword");
        BoardDAO boardDAO = new BoardDAO();

        // 페이지 설정 추가
        int startNum = 0;
        int endPage = 0;
        int startPage = 0;
        int amount = 10;    // 한 페이지에 보여줄 글의 갯수

        boolean prev;
        boolean next;

        int total = boardDAO.getCnt();        // 총 카운트=게시글 총 갯수
        int pageNum = 0;

        String pageNumStr = request.getParameter("pageNum");
        System.out.println("pageNumStr: "+ pageNumStr);

        if (pageNumStr == null) {
            pageNum = 1;
        } else{
            pageNum = Integer.parseInt(pageNumStr);
            System.out.println("======pageNum: "+ pageNum);
        }

        startNum = (pageNum-1) * amount;      // pageNum =1 이면, startNum=0
        endPage = ((int)Math.ceil((double)pageNum / (double)amount)) * amount;

        startPage = endPage - 9;

        if(1 > startPage ){
            startPage  = 1;
        }

        int realEnd = (int) Math.ceil((double) total / (double) amount);

        if(realEnd < endPage) {
            endPage = realEnd;
        }

        //이전, 다음 버튼 표출 여부 결정
        prev = startPage > 1;
        next = endPage < realEnd;

        System.out.println("total: "+total);
        System.out.println("endPage: "+ endPage + ", startPage: "+startPage);
        System.out.println("realEnd: "+realEnd);
        System.out.println("prev: "+ prev +", next: "+ next);

        List<Board> list = boardDAO.getList(searchOption, keyword, startNum, amount);
        System.out.println("list.jsp, list: "+ list);
    %>

<h2>게시판 - 목록</h2>
    <br>

    <form align="left" name="form11" method="post" action="list.jsp">
        <select name="searchOption">
            <option value="all" selected>제목+작성자+내용</option>
            <option value="title">제목</option>
            <option value="writer">작성자</option>
            <option value="content">내용</option>
        </select>
        <input type="text" name="keyword" style="width: 290px;" placeholder="검색어를 입력해주세요. (제목+작성자+내용)">
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
                    <th style="background-color: #eeeeee; text-align: center">제목</th>
                    <th style="background-color: #eeeeee; text-align: center">작성자</th>
                    <th style="background-color: #eeeeee; text-align: center">조회수</th>
                    <th style="background-color: #eeeeee; text-align: center">등록 일시</th>
                    <th style="background-color: #eeeeee; text-align: center">수정 일시</th>
                </tr>
            <c:forEach var="board" items="<%=list%>">
                <tr>
                    <td>${board.category}</td>
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
            <c:set var="pageNum" value="<%=pageNum%>" />
            <%
                System.out.println("pageNum: "+ pageNum);
                System.out.println("prev: "+ prev +", next: "+ next);
            %>
            <div>
                <ul class="pagination">
                    <c:if test="<%=prev%>">
                        <li class="pagination_button">
                            <a href="list.jsp?pageNum=<%=startPage - 1 %>&amount=<%=amount%>">Previous</a>
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
                                <li class="pagination_button">
                                    <a href="list.jsp?pageNum=${num}&amount=<%=amount%>">${num}</a>
                                </li>
                            </c:when>
                        </c:choose>
                    </c:forEach>

                    <c:if test="<%=next%>">
                        <li class="pagination_button">
                            <a href="list.jsp?pageNum=<%=endPage + 1%>&amount=<%=amount%>">Next</a>
                        </li>
                    </c:if>
                </ul>
            </div>

            <a href="write.jsp?pageNum=${pageNum}" class="btn btn-primary pull-right">등록</a>
        </div>
    </div>
</body>
</html>
