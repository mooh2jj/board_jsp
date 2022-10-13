<%--
  Created by IntelliJ IDEA.
  User: dsg
  Date: 2022-10-13
  Time: PM 1:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="board.Board"%>
<%@ page import="board.BoardDAO"%>
<html>
<head>
    <title>게시글 상세보기</title>
</head>
<body>
<%

    long id = 0L;
    if (request.getParameter("id") != null) {
        id = Long.parseLong(request.getParameter("id"));
    }
    if (id == 0) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('유효하지 않은 글입니다.')");
        script.println("location.href='board.jsp'");
        script.println("</script>");
    }
    Board board = new BoardDAO().getBoard(id);
%>

<div class="container">
    <div class="row">

        <table class="table table-striped"
               style="text-align: center; border: 1px solid #dddddd;">
            <tr>
                <th colspan="3"
                    style="background-color: #eeeeee; text-align: center">게시판 글보기

                </td>
            </tr>
            <tr>
                <td style="width: 20%;">작성자</td>
                <td colspan="2"><%=board.getWriter()%></td>
            </tr>            
            <tr>
                <td style="width: 20%;">카테고리</td>
                <td colspan="2"><%=board.getCategory()%></td>
            </tr>
            <tr>
                <td style="width: 20%;">글 제목</td>
                <td colspan="2"><%=board.getTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>")%></td>
            </tr>
            <tr>
                <td style="width: 20%;">등록일시</td>
                <td colspan="2"><%=board.getCreatedAt()%></td>
            </tr>
            <tr>
                <td style="width: 20%;">수정일시</td>
                <td colspan="2"><%=board.getUpdatedAt()%></td>
            </tr>
            <tr>
                <td style="width: 20%;">내용</td>
                <td colspan="2" style="min-height: 200px; text-align: left;">
                    <%=
                    board.getContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>")
                    %></td>
            </tr>
        </table>
        <a href="list.jsp" class="btn btn-primary">목록</a>
        <a href="modify.jsp?id=<%= id %>" class="btn btn-primary">수정</a>
        <a onclick="return confirm('정말로 삭제하시겠습니까?')" href="deleteAction.jsp?id=<%= id %>" class="btn btn-primary">삭제</a>

    </div>
</div>
</body>
</html>
