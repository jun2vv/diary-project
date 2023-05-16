<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//request.Parameter 요청값 유효성 검사
	if(request.getParameter("scheduleNo") == null) {
		response.sendRedirect("./scheduleListByDate.jsp");	// storeNo가 널값이면 다시storeList페이지로 돌아옴
		return; 
}
	// 넘겨줄 변수 storeNo 선언
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	System.out.println(scheduleNo + " <-- deleteScheduleForm.jsp para scheduleNo");
	
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
<style>
	table, tr, td {
    border: 1px solid #bcbcbc;
     width: 20px; 
    height: 20px;
  }
  	
</style>
<body>
	<div class="container">
	<h1>스케줄 삭제</h1>
	<a class="btn btn-outline-dark" href="./scheduleList.jsp">뒤로가기</a>
	<form action="./deleteScheduleAction.jsp" method="post">
		<table class="table table-striped">
			<tr>
				<td>번호</td>
				<td>
					 <input type="text" name="scheduleNo" value="<%=scheduleNo%>" readonly="readonly">
				</td>
			</tr>
			<tr class="table-secondary">
				<td>비밀번호</td>
				<td>
					
					 <input type="password" class="form-control" id="exampleInputPassword1" name="storePw" placeholder="비밀번호" style="text-align:center; width:150px; height:30px;">
				</td>
			</tr>
			<tr>
				<td><button class="btn btn-outline-warning" type="submit">삭제</button></td>
			</tr>
		</table>
	</form>
	</div>
</body>
</html>