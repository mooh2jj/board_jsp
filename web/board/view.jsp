<%--
  Created by IntelliJ IDEA.
  User: dsg
  Date: 2022-10-13
  Time: PM 1:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="board.Board"%>
<%@ page import="board.BoardDAO"%>
<%@ page import="java.sql.SQLException" %>
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
    PrintWriter script = response.getWriter();
    if (id == 0) {
        script.println("<script>");
        script.println("alert('유효하지 않은 글입니다.')");
        script.println("location.href='board.jsp'");
        script.println("</script>");
    }
    BoardDAO boardDAO = new BoardDAO();
    Board board = null;
    try {
        board = boardDAO.getBoard(id);
    } catch (SQLException e) {
        throw new RuntimeException(e);
    }

    try {
        boardDAO.updateHit(board);
    } catch (SQLException e) {
        throw new RuntimeException(e);
    }

    // 페이지 처리 pageNum, amount
    int pageNum = 0;
    int amount = 10;    // 한 페이지에 보여줄 글의 갯수

    String pageNumStr = request.getParameter("pageNum");
    System.out.println("pageNumStr: "+ pageNumStr);

    if (pageNumStr == null) {
        pageNum = 1;
    } else{
        pageNum = Integer.parseInt(pageNumStr);
        System.out.println("======pageNum: "+ pageNum);
    }
%>
<h2>게시판 - 보기</h2>

<br>
<%--바로 조회수 1 추가해진 상태로 볼 수 있게 해줌--%>
<c:set var="board" value="<%=board%>"/>
${board.writer}
<br>
등록일시 <fmt:formatDate pattern="yyyy.MM.dd HH:mm:ss" value="${board.createdAt}"/>
수정일시 <fmt:formatDate pattern="yyyy.MM.dd HH:mm:ss" value="${board.updatedAt}"/> <br>
[${board.category}]${board.title} 조회수: <%=board.getHit()+1%>

<hr>

<div class="container">
    <div class="row">
        <table class="table table-striped">
            <tr>
                <td style="min-height: 200px; text-align: left;">
                    <%=
                    board.getContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>")
                    %>
                </td>
            </tr>
            <c:forEach var="fileItem" items="<%=fileItemList%>">
            <tr>
                <c:choose>
                    <c:when test="${fileItem.fileName ne null}">
                        <td><a href="downloadAction.jsp?fileUUIDName=${fileItem.fileUUIDName}">${fileItem.fileName}</a></td>
                    </c:when>
                    <c:otherwise>
                        <span>&nbsp;</span>
                    </c:otherwise>
                </c:choose>
            </tr>
        </table>
        <a href="list.jsp?pageNum=<%=pageNum%>&amount=<%=amount%>" class="btn btn-primary">목록</a>
        <a href="modify.jsp?id=${board.id}&pageNum=<%=pageNum%>" class="btn btn-primary">수정</a>
        <a onclick="return confirm('정말로 삭제하시겠습니까?')" href="deleteAction.jsp?id=${board.id}" class="btn btn-primary">삭제</a>

    </div>
</div>
</body>
</html>
