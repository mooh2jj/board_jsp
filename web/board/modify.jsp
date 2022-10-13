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
<%@ page import="java.io.PrintWriter"%>
<%@ page import="board.Board"%>
<%@ page import="board.BoardDAO"%>
<html>
<head>
    <title>게시글 수정</title>
</head>
<body>

<h2>게시판 - 수정</h2>

<br>

<h3>기본정보</h3>
<%

    long id = 0L;
    if (request.getParameter("id") != null) {
        id = Long.parseLong(request.getParameter("id"));
    }
    if (id == 0L) {
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
        <form action="modifyAction.jsp?id=<%=id%>" method="post">
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
            </table>
            <input type="button" class="btn btn-primary" onclick="history.back();" value="취소">
            <input type="submit" class="btn btn-primary pull-left" value="저장">
        </form>

    </div>
</div>
</body>
</html>
