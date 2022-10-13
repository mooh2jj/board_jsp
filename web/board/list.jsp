<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="board.BoardDAO"%>
<%@ page import="board.Board"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.util.ArrayList"%>

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
                    BoardDAO boardDAO = new BoardDAO();
                    ArrayList<Board> list = boardDAO.getList();
                    for(int i=0; i < list.size(); i++){
                %>
                <tr>
                    <td><%= list.get(i).getCategory() %></td>
                    <td><%= list.get(i).getTitle()%></td>
                    <td><%= list.get(i).getWriter()%></td>
                    <td><%= list.get(i).getHit()%></td>
                    <td><%= list.get(i).getCreatedAt()%></td>
                    <td><%= list.get(i).getUpdatedAt()%></td>
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
