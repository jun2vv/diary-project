<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import ="java.util.*" %>
<%@ page import ="vo.*" %>
<%
	if(request.getParameter("noticeNo") == null) {
		response.sendRedirect("./noticeList.jsp");			// noticeNo가 널일경우에 이 페이지에서 다시 돌아가야할 곳인 noticeList.jsp로 보낸다.
		return;	
	} 

	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	System.out.println(noticeNo + "<---	updateNotcieform Para noticeNo");	// 디버깅
	
	// mariadb 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver"); 	// mariadb 드라이버 로딩
	System.out.println("Driver실행확인" ); //디버깅
	
	// db연결 로그인
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");		//  연결 후 로그인 하는 법
	System.out.println(conn + "<--- updateNotcieform conn");	 // 디버깅
	
	/* 쿼리
	select notice_no, notice_title , notice_content , notice_writer , createdate, updatedate from notice where notice_no = ?
	*/
	String sql = "select notice_no, notice_title , notice_content , notice_writer , createdate, updatedate from notice where notice_no = ? " ;		// 쿼리 입력할 곳
	PreparedStatement stmt = conn.prepareStatement(sql);	// 문자열 모양의 sql로 입력받은 쿼리를 변환 시켜준다  
	
	stmt.setInt(1, noticeNo);	// ? = notice_no
	System.out.println(stmt + "<--- updateNotcieform sql stmt"); // 디버깅
	
	ResultSet rs = stmt.executeQuery();
	System.out.println(rs + "<--- updateNotcieform sql rs" ); // 디버깅
	
	rs.next();
	// 자료구조 ResultSet타입을 일반적인 자료구조타입(자바 배열 or 기본API 타입) List, Set, Map
	// ResultSet -> ArrayList<Notice> 타입으로 사용할 수 있다.
	
	
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
	<a class="btn btn-outline-dark" href="./noticeList.jsp">리스트로가기</a>
	<a class="btn btn-outline-dark" href="./home.jsp">홈으로가기</a>
	<h1>수정하기</h1>
	<div>
		<%
			if(request.getParameter("msg") != null) {
		%>
				<%=request.getParameter("msg")%>
		<%
			}
		%>
	</div>
	<form action="./updateNoticeAction.jsp" method = "post">
		<table  class="table table-striped">
			<tr>
				<td>
					notice_no
				</td>
				<td>
					<input type="number" name="noticeNo" value="<%=rs.getInt("notice_no") %>" readonly="readonly"> 
				</td>
			</tr>
			<tr>
				<td>
					notice_title
				</td>
				<td>
					<input type="text" name="noticeTitle" value="<%=rs.getString("notice_title") %>" > 
				</td>
			</tr>
			<tr>
				<td>
					notice_content
				</td>
				<td>
					<textarea rows="5" cols="80" name="noticeContent"> <%=rs.getString("notice_content") %></textarea>
				</td>
			</tr>
			<tr>
				<td>
					notice_writer
				</td>
				<td>
					<%=rs.getString("notice_writer") %>
				</td>
			</tr>
			<tr>
				<td>
					createdate
				</td>
				<td>
					<%=rs.getString("createdate") %>
				</td>
			</tr>
			<tr>
				<td>
					updatedate
				</td>
				<td>
					<%=rs.getString("updatedate") %>
				</td>
			</tr>
			<tr>
				<td>
					notice_pw
				</td>
				<td>
					<input type="password" name="noticePw">
				</td>
			</tr>
		</table>
		<div>
			<button class="btn btn-outline-success" type="submit">수정하기</button>
		</div>
	</form>
	</div>
</body>
</html>