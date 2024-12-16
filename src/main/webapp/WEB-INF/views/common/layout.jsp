<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"
    isELIgnored="false" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<%
    request.setCharacterEncoding("utf-8");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width">
    <link href="${contextPath}/resources/css/main.css" rel="stylesheet" type="text/css" media="screen">
    <link href="${contextPath}/resources/css/basic-jquery-slider.css" rel="stylesheet" type="text/css" media="screen">
    <link href="${contextPath}/resources/css/mobile.css" rel="stylesheet" type="text/css">
    <script src="${contextPath}/resources/jquery/jquery-1.6.2.min.js" type="text/javascript"></script>
    <script src="${contextPath}/resources/jquery/jquery.easing.1.3.js" type="text/javascript"></script>
    <script src="${contextPath}/resources/jquery/stickysidebar.jquery.js" type="text/javascript"></script>
    <script src="${contextPath}/resources/jquery/basic-jquery-slider.js" type="text/javascript"></script>
    <script src="${contextPath}/resources/jquery/tabs.js" type="text/javascript"></script>
    <script src="${contextPath}/resources/jquery/carousel.js" type="text/javascript"></script>
    <script>
        // 슬라이드
        $(document).ready(function() {
            $('#ad_main_banner').bjqs({
                'width': 775,
                'height': 145,
                'showMarkers': true,
                'showControls': false,
                'centerMarkers': false
            });

            // 페이지 로딩 후 DB 갱신을 위한 AJAX 요청
            $.ajax({
                url: "${contextPath}/goods/updateDatabase",
                type: "POST",
                dataType: "json",
                success: function(response) {
                    console.log(response.message);
                },
                error: function(xhr, status, error) {
                    console.error("DB 갱신 실패:", error);
                }
            });
        });

        // 스티키
        $(function() {
            $("#sticky").stickySidebar({
                timer: 100,
                easing: "easeInBounce"
            });
        });
    </script>
    <title><tiles:insertAttribute name="title" /></title>
</head>
<body>
    <div id="outer_wrap">
        <div id="wrap">
            <header>
                <tiles:insertAttribute name="header" />
            </header>
            <div class="clear"></div>
            <aside>
                <tiles:insertAttribute name="side" />
            </aside>
            <article>
                <tiles:insertAttribute name="body" />
            </article>
            <div class="clear"></div>
            <footer>
                <tiles:insertAttribute name="footer" />
            </footer>
        </div>
        <tiles:insertAttribute name="quickMenu" />
    </div>

    <c:if test="${message=='cancel_order'}">
        <script>
            window.onload = function() {
                alert("주문을 취소했습니다.");
            }
        </script>
    </c:if>

    <script type="text/javascript">
        var loopSearch = true;

        // 사용자가 검색창에 검색키워드를 입력하면 Ajax기능을 이용해 해당 키워드가 포함된 목록을 조회해서 가져옵니다.
        // 그 후 id 속성값이 suggest인 <div> 태그를 선택해 차례대로 표시합니다.
        function keywordSearch() {
            if (!loopSearch) return;
            var value = document.frmSearch.searchWord.value;

            $.ajax({
                type: "get",
                async: true,
                url: "${contextPath}/goods/keywordSearch.do",
                data: { keyword: value },
                dataType: "json",
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
            if (count > 0) {
                var html = '';
                for (var i in jsonInfo.keyword) {
                    html += "<a href=\"javascript:select('" + jsonInfo.keyword[i] + "')\">" + jsonInfo.keyword[i] + "</a><br/>";
                }
                var listView = document.getElementById("suggestList");
                listView.innerHTML = html;
                show('suggest');
            } else {
                hide('suggest');
            }
        }

        function select(selectedKeyword) {
            document.frmSearch.searchWord.value = selectedKeyword;
            loopSearch = false;
            hide('suggest');
        }

        function show(elementId) {
            var element = document.getElementById(elementId);
            if (element) element.style.display = 'block';
        }

        function hide(elementId) {
            var element = document.getElementById(elementId);
            if (element) element.style.display = 'none';
        }

        function fn_cancel_order(order_id) {
            var answer = confirm("주문을 취소하시겠습니까?");
            if (answer == true) {
                var formObj = document.createElement("form");
                var i_order_id = document.createElement("input");
                i_order_id.name = "order_id";
                i_order_id.value = order_id;
                formObj.appendChild(i_order_id);
                document.body.appendChild(formObj);
                formObj.method = "post";
                formObj.action = "${contextPath}/mypage/cancelMyOrder.do";
                formObj.submit();
            }
        }
    </script>

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
