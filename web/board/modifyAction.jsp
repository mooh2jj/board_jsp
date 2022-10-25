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
<%@ page import="java.sql.SQLException" %>
<%@ page import="common.PageDTO" %>
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
        System.out.println("boardId: "+id);
    }
    if (id == 0) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('유효하지 않은 글입니다.')");
        script.println("location.href='list.jsp'");
        script.println("</script>");
    }

//    Board board = new BoardDAO().getBoard(id);
    BoardDAO boardDAO = new BoardDAO();

    String pageNumStr = request.getParameter("pageNum");
    int pageNum = 0;
    int amount = 10;      // 페이지에 보여질 갯수
    int total = 0;
    try {
        total = boardDAO.getCnt();
    } catch (SQLException e) {
        throw new RuntimeException(e);
    }
    int result = 0;

    PageDTO pageDTO = new PageDTO(pageNumStr, amount, total);
    pageNum = pageDTO.getPageNum();

    System.out.println("modify board: "+ board);
    PrintWriter script = response.getWriter();

    String password = request.getParameter("password");
    System.out.println("modify password: "+password);
    String dbPassword = null;
    try {
        dbPassword = boardDAO.getPassword(id);
    } catch (SQLException e) {
        throw new RuntimeException(e);
    }
    System.out.println("dbPassword: "+ dbPassword);

    if (request.getParameter("title") == null || request.getParameter("content") == null ||
            request.getParameter("title").equals("") || request.getParameter("content").equals("") || password.equals("") ) {
        script.println("<script>");
        script.println("alert('입력이 안 된 사항이 있습니다.')");
        script.println("history.back();");
        script.println("</script>");
    } else {

        if(password.equals(dbPassword)){
            try {
                result = boardDAO.update(board);
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
            script.println("<script>");
            script.println("location.href='list.jsp';");
            script.println("</script>");
        } else {
            script.println("<script>");
            script.println("alert('패스워드가 맞지 않습니다.')");
            script.println("history.back();");
            script.println("</script>");
        }
        // TODO: 파일 삭제 후 수정 처리
    }
%>
<script src="https://code.jquery.com/jquery-3.6.1.min.js" integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous"></script>
<script>
    $(document).ready(function () {
        let result = <%=result%>;

        if (result === -1) {
            alert('글 수정에 실패했습니다.');
            history.back();
        } else {
            location.href = "list.jsp?pageNum=<%=pageNum%>&amount=<%=amount%>";
        }
    });
</script>
</body>
</html>
