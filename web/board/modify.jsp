<%--
  Created by IntelliJ IDEA.
  User: dsg
  Date: 2022-10-13
  Time: PM 1:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="board.Board"%>
<%@ page import="board.BoardDAO"%>
<%@ page import="java.sql.SQLException" %>
<%@ page import="common.PageDTO" %>
<%@ page import="reply.Reply" %>
<%@ page import="reply.ReplyDAO" %>
<%@ page import="java.util.List" %>
<html>
<head>
    <title>게시글 수정</title>
</head>
<body>
<%
    // 페이지 처리 pageNum, amount

    String pageNumStr = request.getParameter("pageNum");
    System.out.println("pageNumStr: "+ pageNumStr);

    BoardDAO boardDAO = new BoardDAO();

    int pageNum = 0;
    int amount = 10;      // 페이지에 보여질 갯수
    int total = 0;
    try {
        total = boardDAO.getCnt();
    } catch (SQLException e) {
        throw new RuntimeException(e);
    }

    PageDTO pageDTO = new PageDTO(pageNumStr, amount, total);
    pageNum = pageDTO.getPageNum();
%>

<h2>게시판 - 수정</h2>
<br>
<h3>기본정보</h3>
<%

    long id = 0L;
    if (request.getParameter("id") != null) {
        id = Long.parseLong(request.getParameter("id"));
        System.out.println("boardId: "+ id);
    }
    if (id == 0L) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('유효하지 않은 글입니다.')");
        script.println("location.href='board.jsp'");
        script.println("</script>");
    }
    Board board = null;
    try {
        board = new BoardDAO().getBoard(id);
    } catch (SQLException e) {
        throw new RuntimeException(e);
    }
%>
<c:set var="board" value="<%=board%>"/>

<div class="container">
    <div class="row">
        <form action="modifyAction.jsp?id=<%=id%>&pageNum=<%=pageNum%>&amount=<%=amount%>" method="post">
            <table class="table table-striped"
                   style="text-align: center; border: 1px solid #dddddd;">
                <tr>
                    <td style="width: 20%; background-color: #eeeeee;">카테고리</td>
                    <td colspan="2"><%=board.getCategory()%></td>
                </tr>
                <tr>
                    <td style="width: 20%; background-color: #eeeeee;">등록일시</td>
                    <td colspan="2"><fmt:formatDate pattern="yyyy.MM.dd HH:mm:ss" value="<%=board.getCreatedAt()%>"/></td>
                </tr>
                <tr>
                    <td style="width: 20%; background-color: #eeeeee;">수정일시</td>
                    <td colspan="2"><fmt:formatDate pattern="yyyy.MM.dd HH:mm:ss" value="<%=board.getUpdatedAt()%>"/></td>
                </tr>
                <tr>
                    <td style="width: 20%; background-color: #eeeeee;">조회수</td>
                    <td colspan="2"><%=board.getHit()%></td>
                </tr>
                <tr>
                    <td style="width: 20%; background-color: #eeeeee;">작성자</td>
                    <td colspan="2">
                        <input type="text" class="form-control"
                               placeholder="작성자" name="writer" maxlength="50"
                               value="<%=board.getWriter()%>">
                    </td>
                </tr>
                <tr>
                    <td style="width: 20%; background-color: #eeeeee;">비밀번호</td>
                    <td colspan="2">
                        <input type="text" class="form-control"
                               placeholder="비밀번호" name="password" maxlength="50">
                    </td>
                </tr>
                <tr>
                    <td style="width: 20%; background-color: #eeeeee;">제목</td>
                    <td colspan="2">
                        <input type="text" class="form-control"
                               placeholder="제목" name="title" maxlength="50"
                               value="<%=board.getTitle()%>">
                    </td>
                </tr>

                <tr>
                    <td style="width: 20%; background-color: #eeeeee;">내용</td>
                    <td colspan="2">
                        <textarea class="form-control" placeholder="내용"
                                  name="content" maxlength="2048" style="height: 350px;">
                                  <%=board.getContent()%></textarea>
                    </td>
                </tr>
                <tr>
                    <td style="width: 20%; background-color: #eeeeee;">파일 첨부</td>
                    <td colspan="2">
                    <c:choose>
                        <c:when test="${board.fileUUID ne null}">
<%--                            <a href="downloadAction.jsp?fileYn=<%=java.net.URLEncoder.encode(String.format("fileId: %s", board.getFileId()), "UTF-8")%>">${board.fileId}</a> <br>--%>
                        </c:when>
                        <c:otherwise>
                            <span>&nbsp;</span><br>
                        </c:otherwise>
                    </c:choose>
                        <input type="file" name="upload" value="" class="board_view_input" />
                    </td>
                </tr>
            </table>
            <input type="button" class="btn btn-primary" onclick="location.href='list.jsp?pageNum=<%=pageNum%>&amount=<%=amount%>'" value="취소">
            <input type="submit" class="btn btn-primary pull-left" value="저장">
        </form>

    </div>
</div>
</body>
</html>
