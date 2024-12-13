<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"
    isELIgnored="false"
    %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<c:set var="member_id"  value="${sessionScope.memberInfo.member_id}"  />	
<nav>
<ul>
<c:choose>
	<%-- admin계정으로 로그인 했을 경우 메인화면의 왼쪽 사이드 영역 !! 관리자 메뉴 디자인 표시  --%>
	<c:when test="${sessionScope.side_menu=='admin_mode' }">
	   <li>
			<H3>주요기능</H3>
			<ul>
				<li><a href="${contextPath}/admin/goods/adminGoodsMain.do">상품관리</a></li>
				<li><a href="${contextPath}/admin/order/adminOrderMain.do">주문관리</a></li>
				<li><a href="${contextPath}/admin/member/adminMemberMain.do">회원관리</a></li>
				<li><a href="${contextPath}/news/newsList.do?member_id=${member_id}">게시판관리</a></li> 
				<li><a href="#">배송관리</a></li>
				<li><a href="#">게시판관리</a></li>
			</ul>
		</li>
	</c:when>
	<%-- 일반 계정으로 로그인 했을 경우 메인화면의 왼쪽 사이드 영역!! 일반 사용자를 위한 메뉴 항목 표시 --%>
	<c:when test="${sessionScope.side_menu=='my_page' }">
		<li>
			<h3>주문내역</h3>
			<ul>
				<li><a href="${contextPath}/mypage/listMyOrderHistory.do">주문내역/배송 조회</a></li>
				<li><a href="#">반품/교환 신청 및 조회</a></li>
				<li><a href="#">취소 주문 내역</a></li>
				<li><a href="#">세금 계산서</a></li>
			</ul>
		</li>
		<li>
			<h3>정보내역</h3>
			<ul>
				<li><a href="${contextPath}/mypage/myDetailInfo.do">회원정보관리</a></li>
				<li><a href="#">나의 주소록</a></li>
				<li><a href="#">개인정보 동의내역</a></li>
				<li><a href="#">회원탈퇴</a></li>
			</ul>
		</li>
	</c:when>
	
	<%-- 그외 사용자 메뉴 표시 --%>	
	<c:otherwise>
		<li>
			<h3>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;국내외 도서</h3>
			<ul>
				<li><a href="${contextPath}/goods/goodsList.do">IT/인터넷</a></li>
				<li><a href="#">경제/경영</a></li>
				<li><a href="#">대학교재</a></li>
				<li><a href="#">자기계발</a></li>
				<li><a href="#">자연과학/공학</a></li>
				<li><a href="#">역사/인문학</a></li>
			</ul>
		</li>
		<li>
			<h3>커뮤니티</h3>
			<ul>
				<li><a href="${contextPath}/board/boardList.do">자유게시판</a></li>
				<li><a href="#">도서 검색</a></li>
				<li><a href="#">날씨별 추천</a></li>
				<li><a href="#">오늘의 운세</a></li>
			</ul>
		</li>


	 </c:otherwise>
</c:choose>	
</ul>
</nav>
<div class="clear"></div>

<div id="notice">
    <h2>게시판</h2>
    <ul>
        <c:forEach var="notice" items="${noticeList}">
            <li><a href="${contextPath}/board/view.do?id=${notice.id}">${notice.subject}</a></li>
        </c:forEach>
    </ul>
</div>

</html>