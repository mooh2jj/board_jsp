<%--
  Created by IntelliJ IDEA.
  User: dsg
  Date: 2022-10-13
  Time: PM 1:04
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="board.Board"%>
<%@ page import="board.BoardDAO"%>
<%@ page import="java.sql.SQLException" %>
<%@ page import="reply.Reply" %>
<%@ page import="reply.ReplyDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="file.FileItem" %>
<%@ page import="file.FileItemDAO" %>
<%@ page import="java.util.ArrayList" %>
<html>
<head>
    <title>게시글 상세보기</title>
</head>
<body>
<%

    long id = 0L;
    String replyText = "";
    if (request.getParameter("id") != null || request.getParameter("replyText") != null) {
        id = Long.parseLong(request.getParameter("id"));
        replyText = request.getParameter("replyText");
    }

    String keyword = "";
    String searchOption = "";
    if (request.getParameter("keyword") != null || request.getParameter("searchOption") != null) {
        keyword = request.getParameter("keyword");
        searchOption = request.getParameter("searchOption");
    }

    PrintWriter script = response.getWriter();
    if (id == 0) {
        script.println("<script>");
        script.println("alert('유효하지 않은 글입니다.')");
        script.println("location.href='board.jsp'");
        script.println("</script>");
    }
    BoardDAO boardDAO = new BoardDAO();
    Board board = null;
    try {
        board = boardDAO.getBoard(id);
    } catch (SQLException e) {
        throw new RuntimeException(e);
    }

    try {
        boardDAO.updateHit(board);
    } catch (SQLException e) {
        throw new RuntimeException(e);
    }

    // 페이지 처리 pageNum, amount
    int pageNum = 0;
    int amount = 10;    // 한 페이지에 보여줄 글의 갯수

    String pageNumStr = request.getParameter("pageNum");
    System.out.println("pageNumStr: "+ pageNumStr);

    if (pageNumStr == null) {
        pageNum = 1;
    } else{
        pageNum = Integer.parseInt(pageNumStr);
        System.out.println("======pageNum: "+ pageNum);
    }


    FileItemDAO fileItemDAO = new FileItemDAO();
    FileItem fileItem = new FileItem();

    List<FileItem> fileItemList = new ArrayList<>();
    try {
        fileItemList = fileItemDAO.getUUIDName(board.getFileUUID());
        System.out.println("fileItemList: "+ fileItemList);
    } catch (SQLException e) {
        throw new RuntimeException(e);
    }

    System.out.println("boardId: " + id);
    ReplyDAO replyDAO = new ReplyDAO();
    Reply reply = null;

    if (!"".equals(replyText) && replyText != null) {
        reply = new Reply();
        reply.setBoardId(id);
        reply.setReplyText(replyText);
        try {
            replyDAO.write(reply);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    List<Reply> replyList = null;
    try {
        replyList = replyDAO.getList(id);
    } catch (SQLException e) {
        throw new RuntimeException(e);
    }
    System.out.println("replyList: "+ replyList);
%>
<h2>게시판 - 보기</h2>

<br>
<%--바로 조회수 1 추가해진 상태로 볼 수 있게 해줌--%>

<c:set var="board" value="<%=board%>"/>
<c:set var="reply" value="<%=reply%>"/>
<c:set var="replyList" value="<%=replyList%>"/>
<c:set var="pageNum" value="<%=pageNum%>" />
<c:set var="amount" value="<%=amount%>" />
<c:set var="keyword" value="<%=keyword%>" />
<c:set var="searchOption" value="<%=searchOption%>" />

${board.writer}
<br>
등록일시 <fmt:formatDate pattern="yyyy.MM.dd HH:mm:ss" value="${board.createdAt}"/>
수정일시 <fmt:formatDate pattern="yyyy.MM.dd HH:mm:ss" value="${board.updatedAt}"/> <br>
[${board.category}]${board.title} 조회수: <%=board.getHit()+1%>

<hr>

<div class="container">
    <div class="row">
        <table class="table table-striped">
            <tr>
                <td style="min-height: 200px; text-align: left;">
                    <%=
                    board.getContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>")
                    %>
                </td>
            </tr>
            <c:forEach var="fileItem" items="<%=fileItemList%>">
            <tr>
                <c:choose>
                    <c:when test="${fileItem.fileName ne null}">
                        <td><a href="downloadAction.jsp?fileUUIDName=${fileItem.fileUUIDName}">${fileItem.fileName}</a></td>
                    </c:when>
                    <c:otherwise>
                        <span>&nbsp;</span>
                    </c:otherwise>
                </c:choose>
            </tr>
            </c:forEach>
            <br>
            <c:forEach var="reply" items="${replyList}">
            <tr>
                <td>
                    <fmt:formatDate pattern="yyyy.MM.dd HH:mm:ss" value="${reply.repliedAt}"/>
                     <br>
                    ${reply.replyText}
                </td>
            </tr>
            </c:forEach>

            <div id="listReply"></div>

            <tr>
                <td>
                    <input type="text" id="replyText" placeholder="댓글을 입력해주세요"/>
                    <button id="btnReply">등록</button>
                <td>
            </tr>
        </table>
        <br>
        <button data-oper='list' class="btn btn-info">목록</button>
        <button data-oper='modify' class="btn btn-default">수정</button>
        <a onclick="return confirm('정말로 삭제하시겠습니까?')" href="deleteAction.jsp?id=${board.id}" class="btn btn-primary">삭제</a>

        <form id='operForm' action="modify.jsp" method="get">
            <input type='hidden' id='id' name='id' value='<c:out value="${board.id}"/>'>
            <input type='hidden' name='pageNum' value='<c:out value="${pageNum}"/>'>
            <input type='hidden' name='amount' value='<c:out value="${amount}"/>'>
            <input type='hidden' name='keyword' value='<c:out value="${keyword}"/>'>
            <input type='hidden' name='searchOption' value='<c:out value="${searchOption}"/>'>
        </form>

    </div>
<script src="https://code.jquery.com/jquery-3.6.1.min.js" integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous"></script>
<script>
    $(document).ready(function () {

        $('#btnReply').on('click', function (e) {
            e.preventDefault();
            console.log('btnReply click');

            var replyText = $('#replyText').val();
            var boardId= "${board.id}";
            console.log("replyText: ", replyText);
            console.log("boardId: ", boardId);

            var param = {
                "replyText" : replyText,
                "id" : boardId
            };


            $.ajax({
                type: "post",
                url: "view.jsp",
                data: param,
                success: function (result){
                    alert("댓글이 입력되었습니다.");
                    console.log("result: ", result)
                    console.log("replyText: ", result.replyText);
                    console.log("boardId: ", result.id);
                    // TODO: jsp로는 ajax result가 html 전체 페이지로 나오게 됨 해결할 수 있는 방법이 없나?
                    // listReply2();
                    replace();  // TODO: 현재 리다이렉트 처리 -> ajax 처리
                }
            });

        });

        function replace() {
            location.replace("view.jsp?id=${board.id}");
        }

        function listReply2() {
            $.ajax({
                type: "get",
                url: "view.jsp?id=${board.id}",
                contentType: "application/json; charset=utf-8", // ==> 생략가능(RestController이기때문에 가능)
                dataType: "json",
                success: function (result) {
                    console.log(result);
                    /* alert(result); */
                    var output = "<table>";
                    for (var i in result) {
                        output += "<tr>";
                        /* output += "<td>"+result[i].userName; */
                        // output += "<td>"+result[i].replyer;
                        output += result[i].repliedAt+"<br>";
                        output += result[i].replyText+"</td>";
                        output += "<tr>";
                    }
                    output += "</table>";
                    $("#listReply").html(output);
                }
            });
        }
        function changeDate(date){
            date = new Date(parseInt(date));
            year = date.getFullYear();
            month = date.getMonth();
            day = date.getDate();
            hour = date.getHours();
            minute = date.getMinutes();
            second = date.getSeconds();
            strDate = year+"-"+month+"-"+day+"-"+hour+"-"+minute+":"+second;

            return strDate;
        }

    });
</script>
<script>
    $(document).ready(function() {

        var operForm = $("#operForm");

        $("button[data-oper='modify']").on("click", function(e){
            operForm.attr("action","modify.jsp").submit();
        });

        $("button[data-oper='list']").on("click", function(e){
            operForm.find("#id").remove();
            operForm.attr("action","list.jsp")
            operForm.submit();
        });
    });
</script>
</div>
</body>
</html>
