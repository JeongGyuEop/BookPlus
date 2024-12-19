<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<script type="text/javascript">
	function fn_delete_member(member_id, del_yn) {
		var frm_mod_member = document.frm_mod_member;
		var i_member_id = document.createElement("input");
		var i_del_yn = document.createElement("input");

		i_member_id.name = "member_id";
		i_del_yn.name = "del_yn";
		i_member_id.type = "hidden";
		i_del_yn.type = "hidden";
		i_member_id.value = member_id;
		i_del_yn.value = del_yn;

		frm_mod_member.appendChild(i_member_id);
		frm_mod_member.appendChild(i_del_yn);
		frm_mod_member.method = "post";
		frm_mod_member.action = "${contextPath}/admin/member/deleteInfo.do";
		frm_mod_member.submit();
	}
</script>
</head>
<body>
	<div>
		<form name="frm_mod_member">
			<h1>정말로 회원 탈퇴를 하시겠습니까?</h1>
			<button onClick="fn_delete_member('${memberInfo.member_id}','Y')">탈퇴하기</button>
			<a href="${contextPath}/mypage/myPageMain.do">취소</a>
		</form>
	</div>
</body>
</html>