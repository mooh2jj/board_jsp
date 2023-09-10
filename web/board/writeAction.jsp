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
<%@ page import="file.FileItem" %>
<%@ page import="file.FileItemDAO" %>
<%@ page import="java.util.UUID" %>

<% request.setCharacterEncoding("UTF-8"); %>

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
    String password = "";

    String item = "";

    FileItem fileItem = null;

    BoardDAO boardDAO = new BoardDAO();
    FileItemDAO fileItemDAO = new FileItemDAO();

    int result = 0;
    String UPLOAD_DIRECTORY = "upload";
    System.out.println("writeAction.jsp start!!");

    try {
        // file 업로드 TODO: os에 따라 경로 설정, 다중 업로드 FileItem 저장, 연관관계 매핑 설정하기

        String uploadPath = System.getProperty("user.dir") // user.dir == C:\WebStudy\WebDevelement\JSP\board_jsp
                + File.separator        // 윈도우 : '\' 리눅스 : '/'
                + UPLOAD_DIRECTORY;
        // TODO : 다시 tomcat 내 bin 폴더로 경로가 잡힘.. 원인 파악
        System.out.println(" writeAction start uploadPath: "+uploadPath);

        int maxFileSize = 1024 * 1024 * 100;
        String encType = "utf-8";

        MultipartRequest multi
                = new MultipartRequest(request, uploadPath, maxFileSize, encType, new DefaultFileRenamePolicy());

        category = multi.getParameter("category");
        title = multi.getParameter("title");
        password = multi.getParameter("password");
        content = multi.getParameter("content");
        writer = multi.getParameter("writer");

        // board write
        // Board, FileItem 테이블 연관관계 매핑 처리, uuid로 매핑
        // TODO : board Write시 board 테이블, file_item 테이블 같은 Transaction 내에 처리
        Board board = new Board();
        board.setCategory(category);
        board.setPassword(password);
        board.setTitle(title);
        board.setContent(content);
        board.setWriter(writer);

        int writeResult = boardDAO.write(board);
        System.out.println("writeResult: " + writeResult);

        long lastInsertId = boardDAO.getLastInsertId();

        System.out.println("board lastInsertId:" + lastInsertId);

        // fileItem write, 다수일때
        Enumeration files = multi.getFileNames();  // 폼의 이름 반환
        if (files != null) {
            UUID uuid = UUID.randomUUID();
            board.setFileYn(true);

            while (files.hasMoreElements()) {
                item = (String) files.nextElement();
                String fileSysName = multi.getFilesystemName(item);
                String originFileName = multi.getOriginalFileName(item);
                String uuidFileName = uuid + "_" + originFileName;
                if(fileSysName == null) continue;
                File file = multi.getFile(item);
                if (file.exists()) {
                    long fileSize = file.length();

                    System.out.println("원본파일명: " + originFileName);
                    System.out.println("파일명: " + uuidFileName);
                    System.out.println("파일크기: " + fileSize);

                    System.out.println("board.getId(): " + board.getId());

                    fileItem = new FileItem();
                    fileItem.setPath(uploadPath);
                    fileItem.setFileUUIDName(uuidFileName);
                    fileItem.setFileName(originFileName);
                    fileItem.setSize(fileSize);
                    fileItem.setBoardId(lastInsertId);        // lastInsertId 가져옴

                    fileItemDAO.fileUpload(fileItem);
                }

                File originFile = new File(uploadPath + "/" + originFileName);
                System.out.println("originFile: "+ originFile);
                File uuidFile = new File(uploadPath + "/" + uuidFileName);
                System.out.println("uuidFile: "+ uuidFile);
                // 파일 업로드
                if (!originFile.renameTo(uuidFile)) {
                    System.out.println("파일명변경 실패");
                }
            }
            board.setFileUUID(String.valueOf(uuid));
        }
//        result = boardDAO.write(board);
        System.out.println("writeAction boardDAO result: " +result);
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
