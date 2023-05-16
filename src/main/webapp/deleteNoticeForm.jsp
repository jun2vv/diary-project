<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// request.Parameter values // 요청값 유효성 검사
	if(request.getParameter("noticeNo") == null) {
		response.sendRedirect("./noticeList.jsp");			// noticeNo가 널일경우에 이 페이지에서 다시 돌아가야할 곳인 noticeList.jsp로 보낸다.
		return;	// return이 하는일 1) 코드진행종료 2) 반환값을 넘길때 사용
	} 

	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	System.out.println(noticeNo +"deleteNoticeForm Parameter noticeNo");	// 디버깅
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<body>
	<div class="container">
	
	<h1>공지 삭제</h1>
	<a class="btn btn-outline-dark" href="./noticeList.jsp">뒤로가기</a>
	<a class="btn btn-outline-dark" href="./home.jsp">홈으로가기</a>
	<form action="./deleteNoticeAction.jsp" method="post">
		<table class="table table-striped">
			<tr>
				<td>번호</td>
				<td>
				<!-- 
					<input type="hidden" name="noticeNo" value="<%="noticeNo"%>">	<!-- hidden은 안보이게한다 -->
				 
					 <input type="text" name="noticeNo" value="<%=noticeNo%>" readonly="readonly">
				</td>
				 	
			</tr>
			<tr>
				<td>비밀번호</td>
				<td>
					<input type="password" name="noticePw" placeholder="비밀번호">
				</td>
			</tr>
			<tr>
				<td><button type="submit">삭제</button></td>
			
			</tr>
		</table>
	</form>
	</div>
</body>
</html>