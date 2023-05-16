<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="vo.*" %>


<%
	
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
	<div><!-- 메인메뉴 -->
		<a href="./home.jsp">홈</a>
		<a href="./noticeList.jsp">공지리스트</a>
		<a href="./scheduleList.jsp">일정리스트</a>
	</div>
	
	<!--  날짜순 최근 공지 5개 & 오늘일정(모두) -->
	<%
		// select  notice_no, notice_title, createdate from notice
		// order by createdate desc
		// limit 0, 5
		
		Class.forName("org.mariadb.jdbc.Driver"); 	// mariadb 드라이버 로딩
		
		java.sql.Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");		//  연결 후 로그인 하는 법
		System.out.println("conn되냐 ?"+ conn );
		
		String sql1 = "select notice_no noticeNo, notice_title noticeTitle, createdate from notice order by createdate desc limit 0, 5";
		
		PreparedStatement stmt = conn.prepareStatement(sql1);	// 문자열 모양의 쿼리를 변환 시켜준다
		System.out.println(stmt +"<--- stmt 실행확인" );			// 꼭 해봐야할 디버깅 무조건 해봐라 꼭해라 두번해라 세번해라 
		
		ResultSet rs1 = stmt.executeQuery();
		System.out.println(rs1 +"<--- rs1 실행확인" );
		// 자료구조 ResultSet타입을 일반적인 자료구조타입(자바 배열 or 기본API 타입) List, Set, Map
		// ResultSet -> ArrayList<Notice> 타입으로 사용할 수 있다.
		ArrayList<Notice> noticeList = new ArrayList<Notice>();
		while(rs1.next()) {
		Notice n = new Notice();
					
		n.noticeNo = rs1.getInt("noticeNo");
		n.noticeTitle = rs1.getString("noticeTitle");
		n.createdate = rs1.getString("createdate");
		noticeList.add(n);
		}
		
		
		/*	쿼리문
		select schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, substr(schedule_memo, 1,10) scheduleMemo 
		from schedule 
		where schedule_date = curdate() order by schedule_time ASC
		*/
		
		String sql2 = "select schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, substr(schedule_memo, 1,10) scheduleMemo from schedule where schedule_date = curdate() order by schedule_time ASC";	// 스케줄을 넣을 sql2 쿼리문
		PreparedStatement stmt2 = conn.prepareStatement(sql2);
		System.out.println(stmt2 +"<--- stmt2 실행확인" );
		
		ResultSet rs2 = stmt2.executeQuery();
		System.out.println(rs2 +"<--- rs2 실행확인" );
		// ResultSet -> ArrayList<Schedule> 타입으로 사용할 수 있다.
		ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
		while(rs2.next()) {
		Schedule s = new Schedule();		// new 연산자를  통해 rs의 갯수만큼 스케줄이 생성됬다.
		s.scheduleNo = rs2.getInt("scheduleNo");
		s.scheduleDate = rs2.getString("scheduleDate");	
		s.scheduleTime = rs2.getString("scheduleTime");	
		s.scheduleMemo = rs2.getString("scheduleMemo"); // 앞글자 10개만 보여준다
		scheduleList.add(s);
		}

	%>	
	<table class="table table-striped">
		<tr>
			<th>번호</th>
			<th>제목</th>
			<th>생성날짜</th>
		</tr>
		<%
			for(Notice n : noticeList) {
		%>
			<tr>
				<td> <%=n.noticeNo %></td>
				<td>
					 <a href = "./noticeOne.jsp?noticeNo=<%=n.noticeNo%>">
						<%= n.noticeTitle %>
					</a>
				
				</td>
				<td><%= n.createdate.substring(0, 10) %></td>
			</tr>
		<% 	
			}
		%>
		
		<tr>
			<th>스케줄 날짜</th>
			<th>시간</th>
			<th>메모</th>
		</tr>
		<%
			for(Schedule s : scheduleList) {
		%>
			 <tr>
           	 	<td>
              		<%=s. scheduleDate%>
            	</td>
            	
            	<td><%=s.scheduleTime%></td>
           	 	<td>
               		<a href="./scheduleOne.jsp?scheduleNo=<%=s.scheduleNo%>">
                 		<%=s.scheduleMemo%>
               		</a>
           		</td>
        	 </tr>
		<% 	
			}
		%>
	</table>
	</div>
</body>
</html>