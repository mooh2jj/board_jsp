<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
isELIgnored="false"
%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="board.BoardDAO"%>
<%@ page import="board.Board"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.util.List" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>게시판 목록</title>
</head>
<body>

    게시판 - 목록
    <%
        BoardDAO boardDAO = new BoardDAO();
        List<Board> list = boardDAO.getList();
    %>

    <br>
    <br>

    총 <%=list.size()%>건
    <div class="container">
        <div class="row">
            <table class="table table-striped"
                   style="text-align: center; border: 1px solid #dddddd;">
                <tr>
                    <th style="background-color: #eeeeee; text-align: center">카테고리</th>
                    <th style="background-color: #eeeeee; text-align: center">제목</th>
                    <th style="background-color: #eeeeee; text-align: center">작성자</th>
                    <th style="background-color: #eeeeee; text-align: center">조회수</th>
                    <th style="background-color: #eeeeee; text-align: center">등록 일시</th>
                    <th style="background-color: #eeeeee; text-align: center">수정 일시</th>
                </tr>
                <%

                    for(int i=0; i < list.size(); i++){
                %>
                <tr>
                    <td><%= list.get(i).getCategory() %></td>
                    <td><a href="view.jsp?id=<%= list.get(i).getId() %>"><%= list.get(i).getTitle()%></a></td>
                    <td><%= list.get(i).getWriter()%></td>
                    <td><%= list.get(i).getHit()%></td>
                    <td><fmt:formatDate pattern="yyyy.MM.dd HH:mm:ss" value="<%=list.get(i).getCreatedAt()%>"/></td>
                    <td><fmt:formatDate pattern="yyyy.MM.dd HH:mm:ss" value="<%=list.get(i).getUpdatedAt()%>"/></td>
                </tr>
                <%
                    }
                %>

            </table>
            <a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>
        </div>
    </div>
</body>
</html>
