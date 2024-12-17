<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"
    isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script type="text/javascript">
	var loopSearch = true;
	
	function keywordSearch() {
		if(!loopSearch) return;
		var value = document.frmSearch.searchWord.value;
		$.ajax({
			type: "get",
			async: true,
			url: "${contextPath}/goods/keywordSearch.do",
			dataType: "json",
			data: { keyword: value },
			success: function(data, textStatus) {
				displayResult(data);
			},
			error: function(data, textStatus) {
				alert("에러가 발생했습니다." + data);
			}
		});
	}
	
	function displayResult(jsonInfo) {
		var count = jsonInfo.keyword.length;
		if(count > 0) {
			var html = '';
			for(var i in jsonInfo.keyword) {
				html += "<a href=\"javascript:select('"+jsonInfo.keyword[i]+"')\">"+jsonInfo.keyword[i]+"</a><br/>";
			}
			var listView = document.getElementById("suggestList");
			listView.innerHTML = html;
			show('suggest');
		} else {
			hide('suggest');
		} 
	}
	
	function select(selectedKeyword) {
		document.frmSearch.searchWord.value=selectedKeyword;
		loopSearch = false;
		hide('suggest');
	}
		
	function show(elementId) {
		var element = document.getElementById(elementId);
		if(element) element.style.display = 'block';
	}
	
	function hide(elementId) {
		var element = document.getElementById(elementId);
		if(element) element.style.display = 'none';
	}
</script>

<c:if test="${sessionScope.isLogOn==true and not empty sessionScope.memberInfo }">
</c:if>
<c:if test="${message=='cancel_order'}">
<script>
window.onload = function() {
	alert("주문을 취소했습니다.");
}
</script>
</c:if>
</head>
<body>
<div id="logo">
	<a href="${contextPath}/main/main.do">
		<img width="176" height="80" alt="booktopia" src="${contextPath}/resources/image/Booktopia_Logo.jpg">
	</a>
</div>
<div id="head_link">
	<ul>
		<c:choose>
			<c:when test="${sessionScope.isLogOn==true and not empty sessionScope.memberInfo}">
				<li><a href="${contextPath}/member/logout.do">로그아웃</a></li>
				<li><a href="${contextPath}/mypage/myPageMain.do">마이페이지</a></li>
				<li><a href="${contextPath}/cart/myCartList.do">장바구니</a></li>
				<li><a href="#">주문배송</a></li>
			</c:when>
			<c:otherwise>
				<li><a href="${contextPath}/member/loginForm.do">로그인</a></li>
				<li><a href="${contextPath}/member/memberForm.do">회원가입</a></li> 
			</c:otherwise>
		</c:choose>
		<li><a href="${contextPath}/board/boardList.do">고객센터</a></li>
		<c:if test="${sessionScope.isLogOn==true and sessionScope.memberInfo.member_id =='admin'}">
			<li class="no_line"><a href="${contextPath}/admin/goods/adminGoodsMain.do">관리자</a></li>
		</c:if>
	</ul>
</div>
<br>
<div id="search">
	<form name="frmSearch" action="${contextPath}/goods/searchGoods.do">
		<input name="searchWord" class="main_input" type="text" value="" onKeyUp="keywordSearch()">
		<input type="submit" name="search" class="btn1" value="검 색">
	</form>
	<a href="${contextPath}/API/weather/weather">오늘 날씨에 꼭 맞는 책은?</a>
</div>
<div id="suggest">
	<div id="suggestList"></div>
</div>
</body>
</html>
