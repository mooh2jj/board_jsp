<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>게시판 등록</title>
</head>
<body>
<div class="container">
    <div class="row">
        <form action="writeAction.jsp" method="post">
            <table class="table table-striped"
                   style="text-align: center; border: 1px solid #dddddd;">
                <tr>
                    <td colspan="2"	style="background-color: #eeeeee; text-align: center">게시판 - 등록</td>
                </tr>
                <tr>
                    <td><input type="text" class="form-control" placeholder="카테고리" name="category" maxlength="50"></td>
                </tr>
                <tr>
                    <td><input type="text" class="form-control" placeholder="작성자" name="writer" maxlength="50"></td>
                </tr>
                <tr>
                    <td><input type="text" class="form-control" placeholder="글 제목" name="title" maxlength="50"></td>
                </tr>
                <tr>
                    <td><textarea class="form-control" placeholder="글 내용" name="content" maxlength="2048" style="height: 350px;"></textarea></td>
                </tr>
            </table>
            <input type="submit" class="btn btn-primary pull-right" value="저장">
        </form>
    </div>
</div>


</body>
</html>
