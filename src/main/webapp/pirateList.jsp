<%@ page language="java" contentType="text/html; charset=UTF-8"pageEncoding="UTF-8"%>
<%@ page import= "java.sql.Connection" %>
<%@ page import= "java.sql.DriverManager" %>
<%@ page import= "java.sql.PreparedStatement" %>
<%@ page import= "java.sql.ResultSet" %>
<%
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("드라이버 로딩");
	
	Connection con = null;
	con = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/pirate","root","java1234");
	System.out.println("접속" + con);
	
	String sql2 = "select p_no as 번호, p_name from pirate order bu p_no desc";
	PreparedStatement stmt2 = con.prepareStatement(sql2);
	
	ResultSet rs = stmt2.executeQuery();
	System.out.println("쿼리실행성공" + rs);
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<table>
		<tr>
			<th>p_no</th>
			<th>p_name</th>
			
		</tr>
		
		<% 
			while(rs.next()) {
				
		%>
			<tr>
				<td><%=rs.getInt("p_no")%></td>
				<td><a href=""><%=rs.getString("p_name")%></a></td>
			</tr>
		<% 
			}
		%>
	</table>
</body>
</html>