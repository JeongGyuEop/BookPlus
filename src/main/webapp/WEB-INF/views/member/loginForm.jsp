<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	 isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.security.SecureRandom" %>
<%@ page import="java.math.BigInteger" %>

<%
    // CSRF 방지를 위한 state 값 생성
    SecureRandom secureRandom = new SecureRandom();
    String state = new BigInteger(130, secureRandom).toString(32);
    
    // 생성된 state 값을 세션에 저장
    request.setAttribute("state", state);
%>


<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<c:if test='${not empty message }'>
<script>
window.onload=function()
{
  result();
}

function result(){
	alert("아이디나  비밀번호가 틀립니다. 다시 로그인해주세요");
}
</script>
</c:if>
</head>
<body>
 
	<H3>회원 로그인 창</H3>
	<DIV id="detail_table"></DIV>
	<form action="${contextPath}/member/login.do" method="post">
		<TABLE>
			<TBODY>
				<TR class="dot_line">
					<TD class="fixed_join">아이디</TD>
					<TD><input name="member_id" type="text" size="20" /></TD>
				</TR>
				<TR class="solid_line">
					<TD class="fixed_join">비밀번호</TD>
					<TD><input name="member_pw" type="password" size="20" /></TD>
				</TR>
			</TBODY>
		</TABLE>
		<br><br>
		<INPUT	type="submit" value="로그인"> 
		<INPUT type="button" value="초기화">
		<br><br>
		
	<!-- 네이버 로그인 -->
		<a href="https://nid.naver.com/oauth2.0/authorize?&client_id=JyvgOzKzRCnvAIRqpVXo&response_type=code&redirect_uri=http://localhost:8090/BookPlus/member/naver/callback&state=<%= URLEncoder.encode(state, "UTF-8") %>">
			<img height="40" width="100" src="http://static.nid.naver.com/oauth/small_g_in.PNG"/>
		</a><br>
		
		<a href="https://kauth.kakao.com/oauth/authorize?
					client_id=f6d8eb0ebbe1cc122b97b3f7be2a2b1a&
					redirect_uri=http://localhost:8090/BookPlus/member/kakao/callback&
					response_type=code">
		    카카오 로그인
		</a>
		
		<Br><br>
		   <a href="#">아이디 찾기</a>  | 
		   <a href="#">비밀번호 찾기</a> | 
		   <a href="${contextPath}/member/addMember.do">회원가입</a>    | 
		   <a href="#">고객 센터</a>
					   
	</form>		
</body>
</html>