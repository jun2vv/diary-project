<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.Connection" %>
<%@ page import ="java.sql.DriverManager" %>
<%@ page import ="java.sql.PreparedStatement" %>
<%@ page import ="java.sql.ResultSet" %>
<%

	Class.forName("org.mariadb.jdbc.Driver");  //연결
	
	Connection conn2 = null; // 접속정보 타입
	conn2 = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");     // 로그인 //마리아디비 밑에 내 로컬호스트 밑에 포트넘버 밑에 내가만든 데이터베이스명
	
	String sql = "select * from student;";                      // 쿼리 작성
	PreparedStatement stmt2 = conn2.prepareStatement(sql);      // sql을 쿼리문으로 변환
	ResultSet rs = stmt2.executeQuery(); 						// ResultSet (ArrayList)배열하고 비슷한 데이터 타입
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
	table, td, th {
		border: 1px solid #000000;}
</style>
</head>
<body>
	<table>
		<tr>
			<th>student_no</th>
			<th>studnet_name</th>
			<th>studnet_age</th>
			
		</tr>
		
		<% 
			while(rs.next()) {
		%>
			<tr>
				<td><%=rs.getInt("student_no")%></td>
				<td><%=rs.getString("student_name")%></td>
				<td><%=rs.getInt("student_age")%></td>
			</tr>
		<% 
			}
		%>
	</table>
</body>
</html>