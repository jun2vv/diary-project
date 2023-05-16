<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import ="java.sql.PreparedStatement" %>
<%
	request.setCharacterEncoding("utf-8"); 
	//유효성검사 요청한 값이 null또는 공백이면 deleteScheduleForm.jsp로 돌아간다.
	if(request.getParameter("scheduleNo")== null 
		|| request.getParameter("storePw") == null
		|| request.getParameter("scheduleNo").equals("")	
		|| request.getParameter("storePw").equals("")) {
		response.sendRedirect("./deleteScheduleForm.jsp");		
		return;	// return이 하는일 1) 코드진행종료 2) 반환값을 넘길때 사용 // 여기서는 코드진행종료
	}
	
	// 요청한 반환값을 담을 변수 생성
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	String storePw = request.getParameter("storePw");
	System.out.println(scheduleNo + "<---deleteScheduleAction Para scheduleNo실행확인" ); //디버깅
	System.out.println(storePw + "<---deleteScheduleAction Para storePw실행확인" ); //디버깅
	
	// mariadb 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");	
	System.out.println("deleteScheduleAction Driver실행확인" ); //디버깅
		
	// db연결 로그인
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");		
	System.out.println(conn + "<---deleteScheduleAction conn실행확인");	 // 디버깅

	// 쿼리문 //delete from schedule where schedule_no = ? and schedule_pw = ?
	String sql = "delete from schedule where schedule_no = ? and schedule_pw = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);	// 입력받은 쿼리를 변환 시켜준다	
	
	// 요청받은 값을 stmt에 순서대로 저장 
	stmt.setInt(1,scheduleNo);	// 첫번째 ? = schedule_no
	stmt.setString(2,storePw);	// 두번째 ? = schedule_pw
	System.out.println(stmt + "<--- deleteScheduleAction stmt 실행확인"); // 디버깅
	
	int row = stmt.executeUpdate();		//디버깅실행시 1번으로 번호확인 2번으로 상점이름 확인
	System.out.println(row + "<---deletestoreAction row실행확인");	 // 디버깅
	
	// 비밀번호로 사용할 storePw 맞는지 검사 틀리면 일정 삭제 안됨	
	if(row == 0) {
		response.sendRedirect("./deleteScheduleForm.jsp?scheduleNo="+scheduleNo);
	} else {
		response.sendRedirect("./scheduleListByDate.jsp"); 	//삭제시 다시 scheduleListByDate화면으로
	}
%>