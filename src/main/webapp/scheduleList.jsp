<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%
	int targetYear = 0;
	int targetMonth = 0;
	
	// 년 or 월이 요청했을때 널이거나 넘어오지 않으면 오늘 날짜의 년과 월값으로 한다.
	if(request.getParameter("targetYear") == null 
			|| request.getParameter("targetMonth") == null) {
		Calendar c = Calendar.getInstance();	// Calendar 클래스를 사용할 수 있도록 객체생성
		targetYear = c.get(Calendar.YEAR);
		targetMonth = c.get(Calendar.MONTH);

	// 값이 들어올 경우 들어온 값으로 targetYear,targetMonth를 지정한다.	
	} else {
		targetYear = Integer.parseInt(request.getParameter("targetYear"));	
		targetMonth = Integer.parseInt(request.getParameter("targetMonth"));
		
	}
	System.out.println(targetYear + "<--- targetYear Para  scheduleList 실행확인");		//디버깅
	System.out.println(targetMonth + "<--- targetMonth Para scheduleList 실행확인");	//디버깅
	
	// 1.오늘 날짜 
	Calendar today = Calendar.getInstance();
	int todayDate = today.get(Calendar.DATE);	
	System.out.println(todayDate + "<--- todayDate scheduleList 실행확인");	 	//디버깅
	
	// 2.targetMonth 1일의 요일을 알고 싶다.
	Calendar firstDay = Calendar.getInstance();	// 현재날짜 
	firstDay.set(Calendar.YEAR, targetYear);	// YEAR 을 targetYear로 변경
	firstDay.set(Calendar.MONTH, targetMonth);	// MONTH 을 targetMonth로 변경
	firstDay.set(Calendar.DATE, 1);	// DATE 을 1로 변경	// 총 바뀐 날짜 2023.4.1
	int firstYoil = firstDay.get(Calendar.DAY_OF_WEEK);	// 2023.4.1 몇번째 요일인지 일요일 =1, 토요일=7
	System.out.println(firstYoil + "<--- fristYoil scheduleList 실행확인");	 	//디버깅
	
	// 23년12월 입력 Calendar API 24년1월 변경
	// 23년-1월 입력 Calendar API 22년12월 변경
	targetYear = firstDay.get(Calendar.YEAR);
	targetMonth = firstDay.get(Calendar.MONTH);
	System.out.println(targetYear + "<--- targetYear scheduleList 실행확인");	 //디버깅
	System.out.println(targetMonth + "<--- targetMonth scheduleList 실행확인");	 //디버깅

	// 1일앞의 전달의 공백수를 알 수 있는 변수 
	int startBlank = firstYoil - 1;	
	System.out.println(startBlank + "<--- startBlank scheduleList 실행확인");	 //디버깅
	

	// 3.targetMonth(현재달의) 마지막일
	int lastDate = firstDay.getActualMaximum(Calendar.DATE); //
	System.out.println(lastDate + "<--- lastDate  scheduleList 실행확인");	 //디버깅
	
	
	// lastDate날짜(마지막일) 뒤 공백칸의 수
	int endBlank = 0;
	if((startBlank + lastDate) %7 !=0) {
		endBlank = 7- (startBlank + lastDate)%7;
	}
	System.out.println(endBlank + "<--- endBlank scheduleList 실행확인");	 //디버깅

	
	// 전체 TD의 개수
	int totalTD = startBlank + lastDate + endBlank;
	System.out.println(totalTD + "<--- totalTD scheduleList 실행확인");	 //디버깅
	
	// 전달의 마지막날을 구하기 위한 변수 lastMonthDate 생성
	int lastMonthDate = 0;
	Calendar PreMonth = Calendar.getInstance();
	PreMonth.set(Calendar.YEAR, targetYear);
	PreMonth.set(Calendar.MONTH, targetMonth-1);
	lastMonthDate = PreMonth.getActualMaximum(Calendar.DATE);
	System.out.println(lastMonthDate + " <--- lastMonthDate scheduleList 실행확인");	//디버깅
	
	// mariadb 드라이버 로딩
	Class.forName("org.mariadb.jdbc.Driver"); 	
	System.out.println("Driver실행확인" ); //디버깅
	// db연결 로그인
	java.sql.Connection conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");		
	System.out.println(conn + "<---scheduleList conn 실행확인");	 // 디버깅
	
	/* 쿼리문			// from 가져오는 곳 where 무엇을 가져온다? order by asc 순서대로 
		select schedule_no scheduleNo, substr(schedule_memo,1,5) scheduleMemo,schedule_color scheduleColor,day(schedule_date) scheduleDate 
		from schedule 
		where year(schedule_date)=? and month(schedule_date)=? order by month(schedule_date) asc
	*/
	String sql = "select schedule_no scheduleNo, substr(schedule_memo,1,5) scheduleMemo,schedule_color scheduleColor,day(schedule_date) scheduleDate from schedule where year(schedule_date)=? and month(schedule_date)=? order by month(schedule_date) asc";
														// 코드를 읽기 편하게 이름을 ArrayList에 배열과 동일하게 변경하여준다.
	PreparedStatement stmt = conn.prepareStatement("select schedule_no scheduleNo, day(schedule_date) scheduleDate, substr(schedule_memo, 1, 5) scheduleMemo, schedule_color scheduleColor from schedule where year(schedule_date) = ? and month(schedule_date) = ? order by month(schedule_date) asc");	// 문자열 모양의 쿼리를 변환 시켜준다
	
	stmt.setInt(1, targetYear);		// 첫번째 ? = 1을 startRow로 바꿈
	stmt.setInt(2, targetMonth+1);		// 두번째 ? + 2를 rowPerPage로 바꿈
	System.out.println(stmt + "<---scheduleList stmt 실행확인"); // 디버깅
	// 출력할 공지 데이터
	ResultSet rs = stmt.executeQuery();
	System.out.println(rs + "<--- scheduleList rs 실행확인" ); // 디버깅
	
	// ResultSet -> ArrayList<Schedule> 타입으로 사용할 수 있다.
	// ArrayList 사용할 객채를 생성해 담는다.
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();	// scheduleList라는 ArrayList객채를 생성
	while(rs.next()) {	// rs안에 있는 쿼리문에 값이 있을경우 다음행으로 넘어가며 값을 Schedule s라는 클래스 객체에 있는 변수들에 저장 
		Schedule s = new Schedule();		// new 연산자를  통해 rs의 갯수만큼 스케줄이 생성됬다.
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleDate = rs.getString("scheduleDate");	// 전체 날짜가아닌 day(일)값만 가져왔다 
		s.scheduleMemo = rs.getString("scheduleMemo");	// 전체값이 아닌 앞5글자만 가져왔다 
		s.scheduleColor = rs.getString("scheduleColor");
		scheduleList.add(s);	// scheduleList라는 ArrayList객체에 s라는 변수가 가르키고 있는 값을 scheduleList에 저장
	}

	// db data를 가져오는 알고리즘
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
	<div><!-- 메인메뉴 -->
		<a href="./home.jsp">홈</a>
		<a href="./noticeList.jsp">공지리스트</a>
		<a href="./scheduleList.jsp">일정리스트</a>
	</div>
	
	<h1 style=" text-align: center;"><%=targetYear%>년 <%=targetMonth+1%>월</h1>
	<div>
		<a class="btn btn-outline-dark" href ="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth-1%>">이전달</a>
		<a class="btn btn-outline-dark" href ="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth+1%>">다음달</a>
	</div>
	<table border="1" class="table table-striped">
		<tr>
				<th>일</th>
				<th>월</th>
				<th>화</th>
				<th>수</th>
				<th>목</th>
				<th>금</th>
				<th>토</th>		
		</tr>
		
		<tr>
			<%
				// 전체날짜에서 7로 나누어 떨어질때마다 행을 변경한다.
				for(int i=0; i<totalTD; i++) {	
					int num = i-startBlank+1;
					if(i != 0 && i%7==0) {
			%>
						</tr><tr>
			<% 		
					}
						// num이 0보다 크고 lastDate(현재달 마지막일)보다 작으면
					 String tdStyle = "";
		               if(num > 0 && num<=lastDate){
		                  
		                  if(today.get(Calendar.YEAR) == targetYear
		                        && today.get(Calendar.MONTH) == targetMonth
		                        && today.get(Calendar.DATE) == num){
		                        tdStyle = "background-color:orange;";
		                  }
		    %>
		                  <td style="<%=tdStyle%>">
		                  	<div> <!-- 날짜 가 나오는 숫자 그냥 날짜다 -->
		                     <a  style="color: black" href="./scheduleListByDate.jsp?y=<%=targetYear%>&m=<%=targetMonth%>&d=<%=num%>"><%=num%></a>
		                    </div>
			                 <div><!-- 일정 memo(5글자만) -->
	                        <%
	                           for(Schedule s : scheduleList){
	                              if(num == Integer.parseInt(s.scheduleDate)){
	                        %>
	                              <div style="color:<%=s.scheduleColor%>"><%=s.scheduleMemo %>></div>
	                        <%
	                              }
	                           }
	                        %>
	                     	</div>

		                  </td>
		                  
		    <%
		    
					}  else if (num < 1) {
			%>
						<td style="color:gray"><%=lastMonthDate + (num) %></td>
			<% 	
					} else {
			%>		
						<td style="color:gray"><%=i-(lastDate + startBlank)+1%></td>
			<% 		
					}
				}
			%>
		</tr>
	</table>
	</div>
</body>
</html>