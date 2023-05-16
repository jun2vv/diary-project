<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import ="java.sql.PreparedStatement" %>
<% 
	//request.Parameter values // 요청값 유효성 검사
	if(request.getParameter("noticeNo") == null 
		|| request.getParameter("noticePw") == null
		|| request.getParameter("noticeNo").equals("") 
		|| request.getParameter("noticePw").equals("")) {
		response.sendRedirect("./noticeList.jsp");			// noticeNo가 널일경우에 이 페이지에서 다시 돌아가야할 곳인 noticeList.jsp로 보낸다.
		return;	// return이 하는일 1) 코드진행종료 2) 반환값을 넘길때 사용
	} 
	
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticePw = request.getParameter("noticePw");
	System.out.println(noticeNo + "<------deleteNoticeAction Para noticeNo실행확인" );	 //디버깅
	System.out.println(noticePw + "<------deleteNoticeAction Para noticePw실행확인" );	 //디버깅
			
	Class.forName("org.mariadb.jdbc.Driver");	// mariadb 드라이버 로딩
	System.out.println("Driver실행확인" ); 	//디버깅
	
	java.sql.Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");		//  db연결 로그인
	System.out.println(conn + "conn실행확인");		// 디버깅
			
	// 쿼리문 //delete from notice where notice_no = ? and notice_pw = ?
	String sql = "delete from notice where notice_no = ? and notice_pw = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);	// 문자열 모양의 쿼리를 변환 시켜준다
	
	stmt.setInt(1, noticeNo);		// 첫번째 ? = notice_no 
	stmt.setString(2, noticePw);	// 두번째 ? = notice_pw
	System.out.println(stmt + "<----- deleteNoticeAction sql");	// 디버깅
	
	
	int row = stmt.executeUpdate();	// 디버깅실행시 1번으로 번호확인 2번으로 패스워드 확인
	System.out.println(row + "<------deleteNoticeAction row실행확인");	 // 디버깅
	
	if(row == 0) {	//비밀번호가 틀려서 삭제행이 0행이다
		response.sendRedirect("./deleteNoticeForm.jsp?noticeNo="+noticeNo);
	} else {
		response.sendRedirect("./noticeList.jsp");
	}
%>
