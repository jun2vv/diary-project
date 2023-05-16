<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%
	// 유효성 검사 scheduleNo가 널일경우에  scheduleListByDate.jsp로 보낸다
	if(request.getParameter("scheduleNo") == null
		|| request.getParameter("scheduleNo").equals("")) {
		response.sendRedirect("./scheduleListByDate.jsp");	
		return;	
	}
		
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	System.out.println(scheduleNo + "<---	updateScheduleform Para scheduleNo");	// 디버깅
		
	// mariadb 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver"); 	
	System.out.println("updateScheduleform Driver실행확인"  ); //디버깅
		
	// db연결 로그인
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");		
	System.out.println(conn + "<--- updateScheduleform conn 실행확인");	 // 디버깅
		
	/* 쿼리
	select schedule_no scheduleNo, schedule_date scheduleDate, 
	schedule_time scheduleTime, schedule_memo scheduleMemo, 
	schedule_color scheduleColor, createdate, updatedate 
	from schedule
	where schedule_no = ?
	*/
	String sql = "select schedule_no scheduleNo , schedule_time scheduleTime, schedule_memo scheduleMemo, schedule_color scheduleColor, createdate, updatedate from schedule where schedule_no = ? " ;		// 쿼리 입력할 곳
	PreparedStatement stmt = conn.prepareStatement(sql);	// 문자열 모양의 sql로 입력받은 쿼리를 변환 시켜준다  
		
	stmt.setInt(1, scheduleNo);	// ? = scheduleNo
	System.out.println(stmt + "<--- updateScheduleform sql stmt 실행확인"); // 디버깅
		
	ResultSet rs = stmt.executeQuery();
	System.out.println(rs + "<--- updateScheduleform  rs 실행확인" ); // 디버깅
		
	// ResultSet -> ArrayList<Schedule> 타입으로 사용할 수 있다.
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	if(rs.next()) {
		Schedule s = new Schedule();		// new 연산자를  통해 rs의 갯수만큼 스케줄이 생성됬다.
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleTime = rs.getString("scheduleTime");	 
		s.scheduleMemo = rs.getString("scheduleMemo");	
		s.scheduleColor = rs.getString("scheduleColor");
		s.createdate = rs.getString("createdate");
		s.updatedate = rs.getString("updatedate");
		scheduleList.add(s);
	}
	// 굳이 ArrayList를 사용하여 rs.next를 돌리지 않아도 됬다 if문 사용해도 된다 한행만 출력할때는


%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
  	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<body>
	<div class="container">
	<h1>스케줄 수정하기</h1>
	<div>
		<%	// updateAction에서 온 msg 값이 널이 아니면 출력한다.
			if(request.getParameter("msg") != null) {
		%>
				<%=request.getParameter("msg")%>
		<%
			}
		%>
	</div>
	<a class="btn btn-outline-success" href="./scheduleListByDate.jsp">뒤로가기</a>
	<form action="./updateScheduleAction.jsp" method="post">
		<table class="table table-striped">
			
			<%
				for(Schedule s : scheduleList){
			%>
			<tr>
				<th>스케줄 번호</th>
				<td><input type ="text" name="scheduleNo" readonly="readonly" value="<%=s.scheduleNo%>"></td>
			</tr>
			<tr>
				<th>시간</th>
				<td><input type="time" name="scheduleTime"></td>
			</tr>
			<tr>
				<th>일정 메모</th>
				<td><textarea cols="80" rows="3" name="scheduleMemo"></textarea></td>
			</tr>
			<tr>
				<th>색상</th>
				<td><input type="color" name="scheduleColor"></td>
			</tr>
			<tr>
				<th>수정일</th>
				<td><%=s.updatedate %></td>
			</tr>
			<tr>
				<th>비밀번호</th>
				<td><input type ="password" name="schedulePw"></td>
			</tr>
			<tr>
				<td colspan="2">
					<button class="btn btn-outline-success" type="submit">수정</button>
				</td>
			</tr>
			<%
				}
			%>
		</table>
	</form>
	</div>
</body>
</html>