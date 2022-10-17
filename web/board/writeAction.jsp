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
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"  %>
<%@ page import="com.oreilly.servlet.MultipartRequest"  %>
<%@ page import="java.io.File" %>
<%@ page import="board.Board" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="file.FileItem" %>

<% request.setCharacterEncoding("UTF-8"); %>

<%--<jsp:useBean id="board" class="board.Board" scope="page" />
<jsp:setProperty name="board" property="category" />
<jsp:setProperty name="board" property="title" />
<jsp:setProperty name="board" property="content" />
<jsp:setProperty name="board" property="writer" />--%>

<%--<jsp:useBean id="file" class="file.FileItem" scope="page" />--%>
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
    // 모든 request를 multi로 바꿔줘야함 환경값 빼고
    String category = "";
    String title = "";
    String content = "";
    String writer = "";

    String item = "";
    String fileName = "";
    File file = null;

    FileItem fileItem = null;


    BoardDAO boardDAO = new BoardDAO();

    int result = 0;

    try {
        // file 업로드 TODO: os에 따라 경로 설정, 다중 업로드 FileItem 저장, 연관관계 매핑 설정하기
        String uploadPath = "C:\\WebStudy\\WebDevelement\\JSP\\board_jsp\\upload";
        int maxFileSize = 1024 * 1024 * 2;
        String encType = "utf-8";

        MultipartRequest multi
                = new MultipartRequest(request, uploadPath, maxFileSize, encType, new DefaultFileRenamePolicy());

        category = multi.getParameter("category");
        title = multi.getParameter("title");
        content = multi.getParameter("content");
        writer = multi.getParameter("writer");

        // board write
        // TODO: Board, FileItem 테이블 연관관계 매핑 처리
        Board board = new Board();
        board.setCategory(category);
        board.setTitle(title);
        board.setContent(content);
        board.setWriter(writer);
//    board.setFileId(fileItem.getId());
//    board.setFileName(fileName);


        try {
            result = boardDAO.write(board);
            System.out.println("result:" + result);
        } catch (SQLException ex) {
            throw new RuntimeException(ex);
        }

        System.out.println("board:" + board);


        // fileItem write
        Enumeration files = multi.getFileNames();  // 폼의 이름 반환

        while (files.hasMoreElements()) {
            item = (String) files.nextElement();
            fileName = multi.getFilesystemName(item);
            String originFileName = multi.getOriginalFileName(item);

            if (fileName != null) {
                file = multi.getFile(item);
                if (file.exists()) {
                    long fileSize = file.length();
                    System.out.println("원본파일명: " + originFileName);
                    System.out.println("파일명: " + file.getName());
                    System.out.println("파일크기: " + fileSize);

                    System.out.println("board.getId(): " + board.getId());

                    fileItem = new FileItem();
                    fileItem.setBoardId(1L);
                    fileItem.setFileName(fileName);
                    fileItem.setOriginName(originFileName);

                    boardDAO.fileUpload(fileItem);

                }
            }

/*        if (fileName != null) {
            File originFile = new File(uploadPath + "/" + fileName);
            String ext = originFileName.substring(originFileName.lastIndexOf("."));
            String fileTempName = System.currentTimeMillis() + ext;
            long filesize = originFile.length();
            File tempFile = new File(uploadPath + "/" + fileTempName);

            if (!originFile.renameTo(tempFile)) {
                System.out.println("파일명변경 실패");
            }
        }*/
        }
    } catch (Exception e) {
        e.printStackTrace();
    }

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
