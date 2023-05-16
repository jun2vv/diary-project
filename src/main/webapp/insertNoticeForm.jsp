<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>insertNoticeForm.jsp</title>
</head>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<body>
	<div class="container">
	<div><!-- 메인메뉴 -->
		<a href="./home.jsp">홈</a>
		<a href="./noticeList.jsp">공지리스트</a>
		<a href="./scheduleList.jsp">일정리스트</a>
	</div>
	
	<h1>공지 입력</h1>
	<a class="btn btn-outline-dark" href="./noticeList.jsp">뒤로가기</a>
	<form action="insertNoticeAction.jsp" method="post">
		<table class="table table-striped">
			<tr>
				<td>제목</td>
				<td>
					<input type="text" name="noticeTitle">
				</td>
			</tr>
			<tr>
				<td>내용</td>
				<td>
					<textarea rows="5" cols="80" name="noticeContent"></textarea>
				</td>
			</tr>
			<tr>
				<td>작성자</td>
				<td>
					<input type="text" name="noticeWriter">
				</td>
			</tr>
			<tr>
				<td>비밀번호</td>
				<td>
					<input type="text" name="noticePw" placeholder="비밀번호">
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<button class="btn btn-outline-success" type="submit">입력</button>
				</td>
				<td></td>
			</tr>
		</table>
	</form>
	</div>
</body>
</html>