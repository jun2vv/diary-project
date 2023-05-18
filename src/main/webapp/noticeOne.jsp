<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import ="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	if(request.getParameter("noticeNo") == null) {
		response.sendRedirect("./noticeList.jsp");			// noticeNo가 널일경우에 이 페이지에서 다시 돌아가야할 곳인 noticeList.jsp로 보낸다.
		return;	// return이 하는일 1) 코드진행종료 2) 반환값을 넘길때 사용
	} 
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	System.out.println(noticeNo + "Parameter noticeNo");	// 디버깅
	
	Class.forName("org.mariadb.jdbc.Driver"); 	// mariadb 드라이버 로딩
	
	java.sql.Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");		//  연결 후 로그인 하는 법
	System.out.println("conn되냐 ?"+ conn );		// 디버깅
	
	/* 쿼리문
	select notice_no noticeNo, notice_title noticeTitle, 
	notice_content noticeContent, notice_writer noticeWriter, 
	createdate, updatedate from notice where notice_no = ? 
	*/
	String sql = "select notice_no noticeNo, notice_title noticeTitle, notice_content noticeContent, notice_writer noticeWriter, createdate, updatedate from notice where notice_no = ? " ;		// 쿼리 입력할 곳
	PreparedStatement stmt = conn.prepareStatement(sql);	// 문자열 모양의 sql로 입력받은 쿼리를 변환 시켜준다  
	// stmt의 첫번째 noticeNo(?)를 1로 바꾼다 
	stmt.setInt(1, noticeNo);		
	System.out.println("쿼리 전달 됬냐?"+ stmt );	// 꼭 해봐야할 디버깅 무조건 해봐라 꼭해라 두번해라 세번해라
	ResultSet rs = stmt.executeQuery();
	// 자료구조 ResultSet타입을 일반적인 자료구조타입(자바 배열 or 기본API 타입) List, Set, Map
	// ResultSet -> ArrayList<Notice> 타입으로 사용할 수 있다.
	ArrayList<Notice> noticeList = new ArrayList<Notice>();	// noticeList라는 ArrayList객채를 생성
	while(rs.next()) {	//rs안에 있는 쿼리문에 값이 있을경우 다음행으로 넘어가며 값을 Notice n이라는 클래스 객체에 있는 변수들에 저장 
	Notice n = new Notice();	// Notice클래스를 가르키는 n 이라는 변수로 객체 생성 
	n.noticeNo = rs.getInt("noticeNo");
	n.noticeTitle = rs.getString("noticeTitle");
	n.noticeContent = rs.getString("noticeContent");
	n.noticeWriter = rs.getString("noticeWriter");
	n.createdate = rs.getString("createdate");
	n.updatedate = rs.getString("updatedate");
	noticeList.add(n);	// noitceList라는 ArrayList객체에 n이라는 변수가 가지고 있는 값을 noticeList에 저장
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
	
	<h1>공지</h1>
	<div style=" text-align: center;"><!-- 메인메뉴 -->
		<a href="./home.jsp">홈으로</a>
		<a href="./noticeList.jsp">공지리스트</a>
		<a href="./scheduleList.jsp">일정리스트</a>
	</div>
	<%	
		for(Notice n : noticeList) {
	%>
		<table class="table table-striped">
			<tr>
				<td>공고 번호</td>	
				<td><%=n.noticeNo %></td>	
			</tr>
			<tr>
				<td>공고 제목</td>	
				<td><%=n.noticeTitle %></td>	
			</tr>
			<tr>
				<td>공고 내용</td>	
				<td><%=n.noticeContent %></td>	
			</tr>
			<tr>
				<td>작성자</td>	
				<td><%=n.noticeWriter %></td>	
			</tr>
			<tr>
				<td>생성일</td>	
				<td><%=n.createdate %></td>	
			</tr>
			<tr>
				<td>수정일</td>	
				<td><%=n.updatedate %></td>	
			</tr>
		</table>
	<% 		
		}
	%>
	<div style=" text-align: center;">
		<a class="btn btn-outline-success" href="./updateNoticeForm.jsp?noticeNo=<%=noticeNo %>">수정</a>
		<a class="btn btn-outline-warning" href="./deleteNoticeForm.jsp?noticeNo=<%=noticeNo %>">삭제</a>
	</div>
	</div>
</body>
</html>