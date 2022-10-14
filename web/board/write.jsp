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

<h2>게시판 - 등록</h2>

<br>
<br>
<div class="container">
    <div class="row">
        <form action="writeAction.jsp" method="post" enctype="multipart/form-data">
            <table class="table table-striped"
                   style="text-align: center; border: 1px solid #dddddd;">
                <tr>
                    <td style="width: 20%; background-color: #eeeeee;">카테고리</td>
                    <td colspan="2"><input type="text" class="form-control" placeholder="카테고리" name="category" maxlength="50"></td>
                </tr>
                <tr>
                    <td style="width: 20%; background-color: #eeeeee;">작성자</td>
                    <td colspan="2"><input type="text" class="form-control" placeholder="작성자" name="writer" maxlength="50"></td>
                </tr>
                <tr>
                    <td style="width: 20%; background-color: #eeeeee;">제목</td>
                    <td colspan="2"><input type="text" class="form-control" placeholder="제목" name="title" size="67" maxlength="300"></td>
                </tr>
                <tr>
                    <td style="width: 20%; background-color: #eeeeee;">내용</td>
                    <td colspan="2"><textarea class="form-control" placeholder="글 내용" name="content" rows="10" cols="65" maxlength="4000"></textarea></td>
                </tr>
                <tr>
                    <td style="width: 20%; background-color: #eeeeee;">파일 첨부</td>
                    <td>
<%--                        <input type="file" name="file1"> <br>--%>
<%--                        <input type="file" name="file2"> <br>--%>
<%--                        <input type="file" name="file3">--%>
                    <%-- TODO: 다중 파일 업로드 처리      --%>
                        <input type="file" name="upload" value="" class="board_view_input" />
                    </td>
                </tr>
            </table>
            <input type="button" class="btn btn-primary" onclick="history.back();" value="취소">
            <input type="submit" class="btn btn-primary pull-right" value="저장">
        </form>
    </div>
</div>


</body>
</html>
