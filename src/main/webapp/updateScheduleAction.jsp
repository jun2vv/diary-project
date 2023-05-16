<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>

<%
	request.setCharacterEncoding("utf-8");

	//유효성검사 요청한 값이 null또는 공백이면 scheduleListByDate로 돌아간다.
	String msg = null;
	if(request.getParameter("scheduleNo")== null
		|| request.getParameter("scheduleNo").equals("")) {
		msg = "scheduleNo is required";
	} else if(request.getParameter("scheduleTime")== null 
		|| request.getParameter("scheduleTime").equals("")) {
		msg = "scheduleTime is required";
	} else if(request.getParameter("scheduleColor")== null 
		|| request.getParameter("scheduleColor").equals("")) {
		msg = "scheduleColor is required";
	} else if(request.getParameter("scheduleMemo")== null 
		|| request.getParameter("scheduleMemo").equals("")) {
		msg = "scheduleMemo is required";
	} else if(request.getParameter("schedulePw")== null 
		|| request.getParameter("schedulePw").equals("")) {
		msg = "schedulePw is required";
	}
	
	// msg가 null 이 아닐경우는 
	if(msg != null) { // 위 if else문에 하나라도 해당된다면 아래 폼으로 msg값을 보내버린다.
		response.sendRedirect("./updateScheduleForm.jsp?scheduleNo="
								+request.getParameter("scheduleNo")
								+"&msg="+msg);
			return;
		} 
		
	// 요청한 값을 사용할 변수 선언
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleColor = request.getParameter("scheduleColor");
	String scheduleMemo = request.getParameter("scheduleMemo");
	String schedulePw = request.getParameter("schedulePw");
	
	System.out.println(scheduleNo + "<---updateScheduleForm Para scheduleNo 실행확인" ); //디버깅
	
	// mariadb 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");	
	System.out.println("Driver실행확인" ); //디버깅
			
	// db연결 로그인
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");		
	System.out.println(conn + "<---updateScheduleForm conn 실행확인");	 // 디버깅
			
	// 쿼리문 //update notice set  notice_title = ?,  noticeContent = ?,  create=  now() where noitce_no = ? and notice_pw = ?
	String sql = "update schedule set schedule_time = ?, schedule_color = ?, schedule_memo = ? , updatedate = now() where schedule_no = ? and schedule_pw = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);	// 입력받은 쿼리를 변환 시켜준다
			
	// 요청받은 값을 stmt에 순서대로 저장
	stmt.setString(1,scheduleTime);	
	stmt.setString(2,scheduleColor);	
	stmt.setString(3,scheduleMemo);	
	stmt.setInt(4,scheduleNo);	
	stmt.setString(5,schedulePw);	
	System.out.println(stmt + "<---updateScheduleForm stmt 실행확인"); // 디버깅
			
	int row = stmt.executeUpdate();		
	System.out.println(row + "<---updateScheduleForm row실행확인");	 // 디버깅
	
	// row 가 0 일경우는 수정 실패 변경된 행이 없는경우
	if(row == 0) {
		response.sendRedirect("./updateScheduleForm.jsp?noticeNo="
				+scheduleNo
				+"&msg=incorrect schedulePw");
	} else if(row == 1) {
		response.sendRedirect("./updateScheduleForm.jsp?scheduleNo="+scheduleNo); // 수정이 정상적으로 되면 scheduleListByDate으로 간다.
	} else {
		// update문 실행을 취소(rollback)해야 한다
		System.out.println("error row값 : "+row);
	}	
	
%>
