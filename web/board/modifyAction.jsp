<%--
  Created by IntelliJ IDEA.
  User: dsg
  Date: 2022-10-12
  Time: PM 11:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="board.BoardDAO"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="board.Board"%>
<%@ page import="java.sql.SQLException" %>
<% request.setCharacterEncoding("UTF-8"); %>

<jsp:useBean id="board" class="board.Board" scope="page" />
<jsp:setProperty name="board" property="*" />

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
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
        script.println("location.href='list.jsp'");
        script.println("</script>");
    }

//    Board board = new BoardDAO().getBoard(id);

    System.out.println("modify board: "+ board);


    if (request.getParameter("title") == null || request.getParameter("content") == null ||
            request.getParameter("title").equals("") || request.getParameter("content").equals("")) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('입력이 안 된 사항이 있습니다.')");
        script.println("history.back()");
        script.println("</script>");
    } else {
        BoardDAO boardDAO = new BoardDAO();
        int result = 0;
        try {
            result = boardDAO.update(board);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        // TODO: 파일 삭제 후 수정 처리

        if (result == -1) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('글 수정에 실패했습니다.')");
            script.println("history.back()");
            script.println("</script>");
        } else {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.print("location.href = 'list.jsp'");
            script.println("</script>");
        }
    }
%>
</body>
</html>
