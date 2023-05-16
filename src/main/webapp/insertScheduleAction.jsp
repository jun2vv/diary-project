<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import ="java.sql.PreparedStatement" %>
<%
	//post방식 인코딩 처리	
	request.setCharacterEncoding("utf-8");

	//유효성검사 요청한 값이 null또는 공백이면 scheduleList로 돌아간다.
	if(request.getParameter("scheduleDate")== null
			|| request.getParameter("scheduleTime")== null
			|| request.getParameter("scheduleColor")== null
			|| request.getParameter("scheduleMemo")== null
			|| request.getParameter("schedulePw")== null
			|| request.getParameter("scheduleDate").equals("")
			|| request.getParameter("scheduleTime").equals("")
			|| request.getParameter("scheduleColor").equals("")
			|| request.getParameter("scheduleMemo").equals("")
			|| request.getParameter("schedulePw").equals("")) {
			
			response.sendRedirect("./scheduleList.jsp");
			return;
	}
	//요청한 값을 사용하기 위한 변수저장
	String scheduleDate = request.getParameter("scheduleDate");
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleColor = request.getParameter("scheduleColor");
	String scheduleMemo = request.getParameter("scheduleMemo");
	String schedulePw = request.getParameter("schedulePw");
	
	System.out.println(scheduleDate +"<--- para insertScheduleAction scheduleDate 실행확인");	//디버깅
	System.out.println(scheduleTime +"<--- para insertScheduleAction scheduleTime 실행확인");	//디버깅
	System.out.println(scheduleColor +"<--- para insertScheduleAction scheduleColor 실행확인");//디버깅
	System.out.println(scheduleMemo +"<--- para insertScheduleAction scheduleMemo 실행확인");	//디버깅
	System.out.println(schedulePw +"<--- para insertScheduleAction schedulePw 실행확인");	//디버깅
		
	// 스케줄을 추가할 날짜로 다시 돌아가기 위해 년 월 일로 잘라서 변수에 담는다. m(월은) 자바에서는 -1값으로 인식해 -1해준다.
	String y = scheduleDate.substring(0,4);	// y = 2023
	int m = Integer.parseInt(scheduleDate.substring(5,7))-1;	// m = 4
	String d = scheduleDate.substring(8); // d = 24
	
	System.out.println(y +"<---  insertScheduleAction y 실행확인");	//디버깅
	System.out.println(m +"<---  insertScheduleAction m 실행확인");	//디버깅
	System.out.println(d +"<---  insertScheduleAction d 실행확인");	//디버깅
	
	// mariadb 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver"); 
	System.out.println("insertScheduleAction Driver실행확인" ); 	//디버깅

	//  연결 후 로그인 하는 법
	java.sql.Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");		
	System.out.println(conn + "insertScheduleAction conn실행확인");		// 디버깅

	/* 
		쿼리값  insert into schedule(schedule_date, schedule_time, schedule_memo, schedule_color, createdate, updatedate) values(?,?,?,?,now(),now())
	*/
	String sql = "insert into schedule(schedule_date, schedule_time, schedule_memo, schedule_color, schedule_pw, createdate, updatedate) values(?,?,?,?,?,now(),now())";		// 쿼리값을 담을 변수 sql
	PreparedStatement stmt = conn.prepareStatement(sql);	// 문자열 모양의 쿼리를 변환 시켜준다
	
	// stmt의 각 값 순서대로 지정
	stmt.setString(1, scheduleDate);
	stmt.setString(2, scheduleTime);
	stmt.setString(3, scheduleMemo);
	stmt.setString(4, scheduleColor);
	stmt.setString(5, schedulePw);
	System.out.println(stmt + "insertScheduleAction stmt실행확인");		// 디버깅

	int row = stmt.executeUpdate();
	
	if(row ==1) {
		System.out.println(row + "insertScheduleAction row 정상 입력완료");		// 디버깅
	} else {
		System.out.println(row + "insertScheduleAction row 비정상 입력");		// 디버깅
	}

	// 값이 제대로 입력되면 다시 돌아감.
	response.sendRedirect("./scheduleListByDate.jsp?y="+y+"&m="+m+"&d="+d);
	
	
%>	