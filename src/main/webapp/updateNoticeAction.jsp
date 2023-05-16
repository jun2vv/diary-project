<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
    
<%

	
	// 리다이렉션 이 웹페이지를
	request.setCharacterEncoding("utf-8"); 
	//	updateNoticeForm에서 input name을 통해서 보내준 4개의 값 을 null과 ""(공백은) 받지 않겠다 라는 유효성 검사
	System.out.println(request.getParameter("noticeNo") + " <--- noticeNo");
	/*
	if(request.getParameter("noticeNo")== null 
		|| request.getParameter("noticeTitle") == null
		|| request.getParameter("noticeContent") == null
		|| request.getParameter("noticePw") == null
		|| request.getParameter("noticeNo").equals("")	
		|| request.getParameter("noticeTitle").equals("")	
		|| request.getParameter("noticeContent").equals("")	
		|| request.getParameter("noticePw").equals("")) {
		
		String msg ="bad reuqest redirection";
		response.sendRedirect("./updateNoticeForm.jsp?noticeNo="+request.getParameter("noticeNo"));		// 이값중 하나라도 null이거나 공백이면 noticeList.jsp로 이동
		return;	// return이 하는일 1) 코드진행종료 2) 반환값을 넘길때 사용 // 여기서는 코드진행종료
	}
	*/
	
	// 3. 2번 유효성검정 -> 잘못된 결과 -> 분기 -> 코드진행종료(return)
	// -> 리다이렉션(updateNoticeForm.jsp?noticeNo=&msg=)
	
	String msg = null;
	if(request.getParameter("noticeTitle")==null 
		|| request.getParameter("noticeTitle").equals("")) {
		msg = "noticeTitle is required";
	} else if(request.getParameter("noticeContent")==null 
		|| request.getParameter("noticeContent").equals("")) {
		msg = "noticeContent is required";
	} else if(request.getParameter("noticePw")==null 
		|| request.getParameter("noticePw").equals("")) {
		msg = "noticePw is required";
	} 
	
	if(msg != null) { // 위 if else문에 하나라도 해당된다
	response.sendRedirect("./updateNoticeForm.jsp?noticeNo="
							+request.getParameter("noticeNo")
							+"&msg="+msg);
		return;
	} 
	 
	
		
	
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	String noticePw = request.getParameter("noticePw");
	
	System.out.println(noticeNo + "<---updateNoticeAction Para noticeNo 실행확인" ); //디버깅
	System.out.println(noticeTitle + "<---updateNoticeAction Para noticeTitle 실행확인" ); //디버깅
	System.out.println(noticeContent + "<---updateNoticeAction Para noticeContent 실행확인" ); //디버깅
	System.out.println(noticePw + "<---updateNoticeAction Para noticePw 실행확인"); //디버깅
	
	
	// mariadb 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver");	
	System.out.println("Driver실행확인" ); //디버깅
		
	// db연결 로그인
	Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");		
	System.out.println(conn + "<---updateNoticeAction conn 실행확인");	 // 디버깅
		
	// 쿼리문 //update notice set  notice_title = ?,  noticeContent = ?,  create=  now() where noitce_no = ? and notice_pw = ?
	String sql = "update notice set notice_title = ?,  notice_content = ?,  updatedate = now() where notice_no = ? and notice_pw = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);	// 입력받은 쿼리를 변환 시켜준다
		
	stmt.setString(1,noticeTitle);	// 첫번째 ? = notice_title
	stmt.setString(2,noticeContent);	// 두번째 ? = notice_content
	stmt.setInt(3,noticeNo);	// 세번째 ? = where notice_no
	stmt.setString(4,noticePw);	// 네번째 ? = where notice_pw
	System.out.println(stmt + "<---updateNoticeAction stmt 실행확인"); // 디버깅
		
	int row = stmt.executeUpdate();		//디버깅실행시 각번호 확인 // 각행의 수
	System.out.println(row + "<---updateNoticeAction row실행확인");	 // 디버깅
	
	// row 가 0 일경우는 수정 실패 변경된 행이 없는경우
	if(row == 0) {
		response.sendRedirect("./updateNoticeForm.jsp?noticeNo="
				+noticeNo
				+"&msg=incorrect noticePw");
	} else if(row == 1) {
		response.sendRedirect("./noticeOne.jsp?noticeNo="+noticeNo);	// 수정이 정상적으로 되면 noticeOne으로 간다.
	} else {
		// update문 실행을 취소(rollback)해야 한다
		System.out.println("error row값 : "+row);
	}	
		
	
	
	/*
	// 비밀번호로 사용할 noticePw 맞는지 검사 틀리면 행 수정 안됨	
	if(row == 0) {
		response.sendRedirect("./updateNoticeForm.jsp?noticeNo="+noticeNo);	// 수정 실패시 다시 폼으로
	} else {
		response.sendRedirect("./noticeOne.jsp?noticeNo="+noticeNo); 	// 수정완료시 다시 noticeOne화면으로
	}
	*/
%>    

