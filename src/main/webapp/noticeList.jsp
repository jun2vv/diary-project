<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import ="java.util.*" %>
<%@ page import ="vo.*" %>

<%
	// 요청 분석(currentPage, ,,,, )
	// 현재페이지
	int currentPage = 1;
	if(request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage")); 	// 다음페이지로 넘겨주는거
	}
	System.out.println(currentPage + "<----currentPage");
	
	// 페이지당 출력할 행의 수
	int rowPerPage = 10;
	
	//시작 행번호
	int startRow = (currentPage - 1) * rowPerPage;	// int startRow = 0; // 1page일때만 startRow가 0
	/*
		currentPage		startRow(rowPerPage 10일때)
		1				0	<-- (currentPage - 1) * rowPerPage
		2				10
		3				20
		4				30
	*/
	
	
	
		// DB연결 설정
		// select  notice_no, notice_title, createdate from notice
		// order by createdate desc
		// limit ?, ? 
		
		Class.forName("org.mariadb.jdbc.Driver"); 	// mariadb 드라이버 로딩
		
		java.sql.Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");		//  연결 후 로그인 하는 법
		System.out.println( conn+ "conn되냐 ?" );
																// 코드를 읽기 편하게 이름을 ArrayList에 배열과 동일하게 변경하여준다.
		PreparedStatement stmt = conn.prepareStatement("select notice_no noticeNo, notice_title noticeTitle, createdate from notice order by createdate desc limit ?, ?");	// 문자열 모양의 쿼리를 변환 시켜준다
		
		stmt.setInt(1, startRow);		// 첫번째 ? = 1을 startRow로 바꿈
		stmt.setInt(2, rowPerPage);		// 두번째 ? + 2를 rowPerPage로 바꿈
		System.out.println(stmt + "쿼리 전달 됬냐?" );			// 꼭 해봐야할 디버깅 무조건 해봐라 꼭해라 두번해라 세번해라 
		// 출력할 공지 데이터
		ResultSet rs = stmt.executeQuery();
		// 자료구조 ResultSet타입을 일반적인 자료구조타입(자바 배열 or 기본API 타입) List, Set, Map
		// ResultSet -> ArrayList<Notice> 타입으로 사용할 수 있다.
		ArrayList<Notice> noticeList = new ArrayList<Notice>();	// noticeList라는 ArrayList객채를 생성
		while(rs.next()) {	// rs안에 있는 쿼리문에 값이 있을경우 다음행으로 넘어가며 값을 Notice n이라는 클래스 객체에 있는 변수들에 저장  
			Notice n = new Notice();	// Notice클래스를 가르키는 n 이라는 변수로 객체 생성 
			n.noticeNo = rs.getInt("noticeNo");
			n.noticeTitle = rs.getString("noticeTitle");
			n.createdate = rs.getString("createdate");
			noticeList.add(n);	// noitceList라는 ArrayList객체에 n이라는 변수가 가지고 있는 값을 noticeList에 저장
		}
		//마지막 페이지
		// select count(*) from notice;
		PreparedStatement stmt2 = conn.prepareStatement("select count(*) from notice");
		ResultSet rs2 = stmt2.executeQuery();
		int totalRow = 0;	//전체 행의 갯수를 담을 변수
		if(rs2.next()) {
		
			totalRow = rs2.getInt("count(*)"); // SELECT COUNT(*) FROM notice; 이 쿼리를 통하여 토탈 500에 숫자를 구한다
		}
		int lastPage = totalRow / rowPerPage;		//라스트 페이지 구하기
		if(totalRow % rowPerPage != 0) {			
			lastPage = lastPage + 1;
		}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
	<!-- Latest compiled and minified CSS -->
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<!-- Latest compiled JavaScript -->
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="container">
	<div><!-- 메인메뉴 -->
		<a href="./home.jsp">홈</a>
		<a href="./noticeList.jsp">공지리스트</a>
		<a href="./scheduleList.jsp">일정리스트</a>
	</div>
	
	<!--  날짜순 최근 공지 5개 -->
	
	<h1>공지사항 리스트</h1>
	
	<a class="btn btn-dark" href ="./insertNoticeForm.jsp">공지입력</a>
	
	<table class="table table-striped">
		<tr>
			<th>제목</th>
			<th>수정일</th>
		</tr>
		<%
			for(Notice n : noticeList) {
		%>
			<tr>
				<td>
					 <a style="color: black" href = "./noticeOne.jsp?noticeNo=<%=n.noticeNo%>">
						<%= n.noticeTitle%>
					</a>
				
				</td>
				<td><%= n.createdate.substring(0, 10) %></td>
			</tr>
		<% 	
			}
		
			
		%>
	</table>
	<%
		if(currentPage > 1){
			
	%>
			<a class="btn btn-dark" href="./noticeList.jsp?currentPage=<%= currentPage -1%>">이전</a>		<!-- 이전페이지로 -->
	<% 		
		}
	%>	
			페이지<%= currentPage %>
	<% 
		if(currentPage < lastPage) {
	%>
			<a class="btn btn-dark" href="./noticeList.jsp?currentPage=<%= currentPage +1%>">다음</a>	<!-- 다음페이지로 -->
	<% 	
		}
	%>
	</div>
</body>
</html>