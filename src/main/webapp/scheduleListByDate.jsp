<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%
	
	request.setCharacterEncoding("utf-8");

	//유효성검사 요청한 값이 null또는 공백이면 scheduleList로 돌아간다.
	if(request.getParameter("y") == null
		|| request.getParameter("m") == null 
		|| request.getParameter("d") == null 
		|| request.getParameter("y") == ("") 
		|| request.getParameter("m") == ("") 
		|| request.getParameter("d") == ("")) {
		 response.sendRedirect("./scheduleList.jsp");
		 return;
	} 
	
	int y = Integer.parseInt(request.getParameter("y"));
	// 자바 캘린더API는 12월을 == 11로 , mariaDB에서는 12월을 == 12로 표현 
	int m = Integer.parseInt(request.getParameter("m")) +1; 	//자바API로 넘어가는거라 +1해야함
	int d = Integer.parseInt(request.getParameter("d"));
	
	System.out.println(y + "<--- y para scheduleListByDate 실행확인");		//디버깅
	System.out.println(m + "<--- m para scheduleListByDate 실행확인");		//디버깅
	System.out.println(d + "<--- d para scheduleListByDate 실행확인");		//디버깅
	
	String strM = m+"";
	if(m<10) {
		strM = "0"+strM;
	}
	System.out.println(strM + "<--- strM scheduleListByDate 실행확인");		//디버깅
	
	String strD = d+"";
	if(d<10) {
		strD= "0"+strD;
	}
	System.out.println(strD + "<--- strD scheduleListByDate 실행확인");		//디버깅
	

	Class.forName("org.mariadb.jdbc.Driver"); 	// mariadb 드라이버 로딩
	
	java.sql.Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");		//  연결 후 로그인 하는 법
	System.out.println( conn+ "scheduleListByDate conn 실행확인" );
	
	/* 쿼리문
	select schedule_no scheduleNo, schedule_time scheduleTime, 
	schedule_memo scheduleMemo, createdate, updatedate  
	from schedule 
	where schedule_date = ? order by schedule_time asc
	*/
	
	String sql ="select schedule_no scheduleNo, schedule_time scheduleTime, schedule_memo scheduleMemo, createdate, updatedate  from schedule where schedule_date = ? order by schedule_time asc";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, y+"-"+strM+"-" + strD);		
	System.out.println(stmt + "scheduleListByDate stmt 실행확인" );	//디버깅
	
	// 출력할 공지 데이터
	ResultSet rs = stmt.executeQuery();		// rs 에는 select쿼리에 값이 들어가 있다.
	System.out.println(rs + "scheduleListByDate rs 실행확인" );	//디버깅
	
	// ResultSet -> ArrayList<Schedule> 타입으로 사용할 수 있다.
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();	// scheduleList라는 ArrayList객채를 생성
	while(rs.next()) {	// rs안에 있는 쿼리문에 값이 있을경우 다음행으로 넘어가며 값을 Schedule s라는 클래스 객체에 있는 변수들에 저장 
		Schedule s = new Schedule();		// new 연산자를  통해 rs의 갯수만큼 스케줄이 생성됬다.
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleTime = rs.getString("scheduleTime");	
		s.scheduleMemo = rs.getString("scheduleMemo");	
		s.createdate = rs.getString("createdate");	
		s.updatedate = rs.getString("updatedate");
		scheduleList.add(s);	// scheduleList라는 ArrayList객체에 s라는 변수가 가르키고 있는 값을 scheduleList에 저장
	}
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
	<div>
		<a href="./scheduleList.jsp">달력으로 돌아가기</a>
	</div>
	<h1>스케줄 입력</h1>
	<form action="./insertScheduleAction.jsp" method="post">
		<table class="table table-striped">
			<tr>
				<th>날짜</th>
				<td><input type="date" name= "scheduleDate" 
							value="<%=y %>-<%=strM %>-<%=strD %>" readonly="readonly"></td>
			</tr>
			<tr>
				<th>스케줄 타임</th>
				<td><input type="time" name= "scheduleTime"></td>
							
			</tr>
			<tr>
				<th>스케줄 컬러</th>
				<td><input type="color" name= "scheduleColor" 
							value="#000000"></td>
			</tr>
			<tr>
				<th>스케줄 메모</th>
				<td><textarea cols="80" rows="3" name="scheduleMemo"></textarea> </td>
			</tr>
			<tr>
				<th>비밀번호</th>
				<td><input type="password" name="schedulePw"> </td>
			</tr>
		</table>
		<button class="btn btn-outline-dark" type = "submit">스케줄 추가하기</button>
	</form>
	<h1><%= y %>년 <%= m %>월 <%= d %>일</h1>
	<table class="table table-striped">
		<tr>
			<th>번호</th>
			<th>스케줄 시간</th>
			<th>메모</th>
			<th>생성일</th>
			<th>수정일</th>
			<th>수정</th>
			<th>삭제</th>
		</tr>
		<%
			for(Schedule s : scheduleList) {
			
		%>	
			<tr>
				<td>
					<%= s.scheduleNo %>
				</td>
				<td>
					<%=s.scheduleTime %>
				</td>
			
				<td>
					<%=s.scheduleMemo %>
				</td>
			
				<td>
					<%=s.createdate %>
				</td>
			
				<td>
					<%=s.updatedate %>
				</td>
			
				<td><a class="btn btn-outline-success" href="./updateScheduleForm.jsp?scheduleNo=<%=s.scheduleNo%>">수정</a>
				</td>
		
				<td><a class="btn btn-outline-warning" href="./deleteScheduleForm.jsp?scheduleNo=<%=s.scheduleNo%>">삭제</a>
				</td>
			</tr>
		<% 
			}
		%>
	</table>
	</div>
</body>
</html>