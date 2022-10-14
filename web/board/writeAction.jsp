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
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"  %>
<%@ page import="com.oreilly.servlet.MultipartRequest"  %>
<%@ page import="java.io.File" %>
<%@ page import="board.Board" %>

<% request.setCharacterEncoding("UTF-8"); %>

<%--<jsp:useBean id="board" class="board.Board" scope="page" />
<jsp:setProperty name="board" property="category" />
<jsp:setProperty name="board" property="title" />
<jsp:setProperty name="board" property="content" />
<jsp:setProperty name="board" property="writer" />--%>

<%--<jsp:useBean id="file" class="file.File" scope="page" />--%>
<%--<jsp:setProperty name="file" property="*" />--%>

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


    // file 업로드
    String uploadPath = "C:\\WebStudy\\WebDevelement\\JSP\\board_jsp\\upload";
    int maxFileSize = 1024 * 1024 * 2;
    String encType = "utf-8";

    MultipartRequest multi
            = new MultipartRequest(request, uploadPath, maxFileSize, encType, new DefaultFileRenamePolicy());

    // 모든 request를 multi로 바꿔줘야함 환경값 빼고
    String category = multi.getParameter("category");
    String title = multi.getParameter("title");
    String content = multi.getParameter("content");
    String writer = multi.getParameter("writer");

    String filename = multi.getFilesystemName("upload");
    String originFileName = multi.getOriginalFileName("upload");
    File file = multi.getFile("upload");
    long filesize = 0;
    if(file != null){
        filesize = file.length();
    }

    BoardDAO boardDAO = new BoardDAO();
    Board board = new Board();

    board.setCategory(category);
    board.setTitle(title);
    board.setContent(content);
    board.setWriter(writer);
    board.setFileName(filename);
    int result = boardDAO.write(board);

    System.out.println("board:" + board);
    PrintWriter script = response.getWriter();

    if (result == -1) {
        script.println("<script>");
        script.println("alert('글 쓰기에 실패했습니다.')");
        script.println("history.back()");
        script.println("</script>");
    } else {
        script.println("<script>");
        script.print("location.href = 'list.jsp'");
        script.println("</script>");
    }
%>
</body>
</html>
