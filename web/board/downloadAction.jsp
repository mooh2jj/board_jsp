<%--
  Created by IntelliJ IDEA.
  User: dsg
  Date: 2022-10-12
  Time: PM 11:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.io.*"%>
<%@ page import="java.lang.*" %>


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
    PrintWriter script = response.getWriter();

    // file 다운로드
    InputStream in = null;
    OutputStream os = null;
    boolean skip = false;
    File file = null;

    String uploadPath = "C:\\WebStudy\\WebDevelement\\JSP\\board_jsp\\upload";

    try {
        String fileName = request.getParameter("fileName");
        try {
            file = new File(uploadPath + "/" + fileName);
            in = new FileInputStream(file);
        } catch (FileNotFoundException e) {
            skip = true;
            e.printStackTrace();
        }
        String client = request.getHeader("User-Agent");

        // 파일 다운로드 헤더 지정
        response.reset();
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Description", "JSP Generated Data");

        if(!skip) {
            // IE
            if (client.indexOf("MSIE") != -1) {
                response.setHeader("Content-Disposition", "attachment; filename=" + new String(fileName.getBytes("KSC5601"), "ISO8859_1"));

            } else {
                // 한글 파일명 처리
                fileName = new String(fileName.getBytes("utf-8"), "iso-8859-1");
                response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
                response.setHeader("Content-Type", "application/octet-stream; charset=utf-8");

            }
            response.setHeader("Content-Length", "" + file.length());

            os = response.getOutputStream();
            byte b[] = new byte[(int) file.length()];
            int leng = 0;

            while ((leng = in.read(b)) > 0) {
                os.write(b, 0, leng);
            }
        }else{
            response.setContentType("text/html;charset=UTF-8");
            script.println("<script language='javascript'>alert('파일을 찾을 수 없습니다');history.back();</script>");
        }
        in.close();
        os.close();
    } catch (Exception e) {
        e.printStackTrace();
    }

%>
</body>
</html>
