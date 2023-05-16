<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import ="java.sql.PreparedStatement" %>
<%															
	//post방식 인코딩 처리	
	request.setCharacterEncoding("utf-8"); 
	
	// validation(요청 파라미터값 유효성 검사)	// 무조건 들어가야 하는 값에는 null이나 공백이 들어가지 못하도록 유효성검사를 꼭 해야한다
	if(request.getParameter("noticeTitle")==null
	
		|| request.getParameter("noticeContent")==null
		|| request.getParameter("noticeWriter")==null		
		|| request.getParameter("noticePw")==null
		|| request.getParameter("noticeTitle").equals("")
		|| request.getParameter("noticeContent").equals("")
		|| request.getParameter("noticeWriter").equals("")
		|| request.getParameter("noticePw").equals("")){
		
		response.sendRedirect("./insertNoticeForm.jsp");
		return;
	}
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	String noticeWriter = request.getParameter("noticeWriter");
	String noticePw = request.getParameter("noticePw");
	
	// 값들을 DB 테이블 입력
	/*
		insert into notice(
				notice_title, notice_content, notice_writer, notice_pw, createdate, updatedate) values(?,?,?,?,now(),now())
		
	*/
	Class.forName("org.mariadb.jdbc.Driver"); 	// mariadb 드라이버 로딩
	java.sql.Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");		//  연결 후 로그인 하는 법
	
	String sql = "insert into notice(notice_title, notice_content, notice_writer, notice_pw, createdate, updatedate) values(?,?,?,?,now(),now())";		// 쿼리값을 담을 변수 sql
	PreparedStatement stmt = conn.prepareStatement(sql);	// 문자열 모양의 쿼리를 변환 시켜준다
	
	// ? 4개(1-4)
	stmt.setString(1, noticeTitle);
	stmt.setString(2, noticeContent);
	stmt.setString(3, noticeWriter);
	stmt.setString(4, noticePw);
	int row = stmt.executeUpdate(); //디버깅용 1이면 1행입력성공, 2이면 2행입력, 0이면 입력된 행이 없다 // select, delete, update에는 executeQuery문 사용, insert문에는 executeUpdate문을 사용 
	
	// row값을 이용하 디버깅 추가 // 굳이 넣지 않았음 이번엔
	//conn.commit();	// conn.setAutoCommit(true); 디폴트 값이 true라 자동commit가능 --> commit 생략가능
	
	//redirection
	response.sendRedirect("./noticeList.jsp");		
%>
