<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8" isELIgnored="false" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!-- Google 번역기 API 사용하기 위한 추가1. 세계 언어 선택 메타 태그 추가 -->
<meta name="google-translate-customization" content="6f1073ba568f1202-9c8990a4b3025b3e-ga74e3ea243d3f01d-14"></meta>
<!-- 추가1. 세계 언어 선택 메타 태그 추가 close -->

<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<link rel="stylesheet" type="text/css" href="<c:url value='/resources/css/horoscope.css' />">
<nav>
    <ul>
        <c:choose>
            <c:when test="${sessionScope.side_menu=='admin_mode'}">
                <li>
                    <h3>주요기능</h3>
                    <ul>
                        <li><a href="${contextPath}/admin/goods/adminGoodsMain.do">상품관리</a></li>
                        <li><a href="${contextPath}/admin/order/adminOrderMain.do">주문관리</a></li>
                        <li><a href="${contextPath}/admin/member/adminMemberMain.do">회원관리</a></li>
                        <li><a href="#">배송관리</a></li>
                        <li><a href="${contextPath}/board/boardList.do?member_id=${member_id}">공지사항관리</a></li>
                    </ul>
                </li>
            </c:when>
            <c:when test="${sessionScope.side_menu=='my_page'}">
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
            <c:otherwise>
                <li>
                    <h3>국내외 도서</h3>
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
                    <h3>음반</h3>
                    <ul>
                        <li><a href="#">가요</a></li>
                        <li><a href="#">록</a></li>
                        <li><a href="#">클래식</a></li>
                        <li><a href="#">뉴에이지</a></li>
                        <li><a href="#">재즈</a></li>
                        <li><a href="#">기타</a></li>
                    </ul>
                </li>
            </c:otherwise>
        </c:choose>
    </ul>
</nav>
<div class="clear"></div>
<div id="banner">
    <a href="#"><img width="190" height="163" src="${contextPath}/resources/image/n-pay.jpg"></a>
</div>
<div id="notice">
    <h2><a href="${contextPath}/board/boardList.do">공지사항</a></h2>
    <c:if test="${empty latestNotices}">
        <br><p>최신 공지사항이 없습니다.</p>
    </c:if>
    <ul>
        <c:forEach var="notice" items="${latestNotices}" varStatus="status">
            <li>
                <a href="${contextPath}/board/view.do?id=${notice.id}">${notice.subject}</a>
            </li>
        </c:forEach>
    </ul>
</div>
<div class="horoscope-container">
    <h3>오늘의 별자리 운세</h3>
    <form action="${contextPath}/horoscope/view.do" method="get">
        <select id="sign" name="sign" required>
            <option value="">------ 별자리 선택 ------</option>
            <option value="aries">양자리 (3월21일~4월19일)</option>
            <option value="taurus">황소자리(4월20일~5월20일)</option>
            <option value="gemini">쌍둥이자리(5월21일~6월21일)</option>
            <option value="cancer">게자리(6월22일~7월22일)</option>
            <option value="leo">사자자리(7월23일~8월22일)</option>
            <option value="virgo">처녀자리(8월23일~9월22일)</option>
            <option value="libra">천칭자리(9월23일~10월22일)</option>
            <option value="scorpio">전갈자리(10월23일~11월22일)</option>
            <option value="sagittarius">궁수자리(11월23일~12월21일)</option>
            <option value="capricorn">염소자리(12월22일~1월19일)</option>
            <option value="aquarius">물병자리(1월20일~2월18일)</option>
            <option value="pisces">물고기자리(2월19일~3월20일)</option>
        </select>
        <button type="button" id="checkHoroscopeBtn">운세 보기</button>
    </form>
    <div id="google_translate_element"></div>
    
    <div class="horoscope-description" id="horoscopeDescription"></div>
</div>

<div id="banner">
    <a href="#"><img width="190" height="104" src="${contextPath}/resources/image/call_center_logo.jpg"></a>
</div>
<div id="banner">
    <a href="#"><img width="190" height="69" src="${contextPath}/resources/image/QnA_logo.jpg"></a>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script type="text/javascript">
    function googleTranslateElementInit() {
        new google.translate.TranslateElement({
            pageLanguage: 'en',
            includedLanguages: 'ko,en', // 번역할 언어 목록
            layout: google.translate.TranslateElement.InlineLayout.VERTICAL
        }, 'google_translate_element');
    }
    /* VERTICAL 드롭다운(*Google 번역에서 제공* 수직으로 출력), HORIZONTAL 드롭다운(*Google 번역에서 제공* 수평으로 출력) */
</script>
<script type="text/javascript" src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>

<script type="text/javascript">
    // 별자리 운세
    $(document).ready(function() {
        $('#checkHoroscopeBtn').click(function() {
            var sign = $('#sign').val(); // 선택된 별자리 값을 가져옴

            // 별자리가 선택되지 않은 경우
            if (sign === "") {
                alert("별자리를 선택해주세요.");
                return;
            }

            // AJAX 요청 보내기
            $.ajax({
                url: 'https://horoscope-astrology.p.rapidapi.com/horoscope', // RapidAPI 엔드포인트 URL
                type: 'GET',
                data: {
                    day: 'today', // 오늘의 운세를 가져옵니다
                    sunsign: sign // 선택된 별자리 정보 전달
                },
                headers: {
                    'x-rapidapi-host': 'horoscope-astrology.p.rapidapi.com', // RapidAPI 호스트
                    'x-rapidapi-key': '9c5819e8a9msh27cec47277983a8p15ee97jsn0f8fb0fd3a60' // 본인의 RapidAPI 키로 교체
                },
                success: function(response) {
                    // 운세가 정상적으로 반환되었으면 운세 내용 표시
                    if (response) {
                        $('#horoscopeDescription').html(response.horoscope); // 응답에서 운세 내용 가져오기
                    } else {
                        $('#horoscopeDescription').html("운세를 가져올 수 없습니다.");
                    }
                },
                error: function() {
                    $('#horoscopeDescription').html("운세를 가져오는 중 오류가 발생했습니다.");
                }
            });
        });
    });

    // "quickMenu.jsp" 페이지에서 최근 본 도서상품을 표시하는 자바스크립트 코드
    var array_index = 0; // 현재 표시 중인 상품의 배열 인덱스 위치
    var SERVER_URL = "${contextPath}/thumbnails.do"; // 썸네일 이미지를 가져오기 위한 URL

    // 다음 버튼 클릭 시 호출되는 함수
    function fn_show_next_goods() {
        var img_sticky = document.getElementById("img_sticky");
        var cur_goods_num = document.getElementById("cur_goods_num");
        var _h_goods_id = document.frm_sticky.h_goods_id;
        var _h_goods_fileName = document.frm_sticky.h_goods_fileName;

        console.log("array_index : " + array_index);
        console.log(_h_goods_id.length - 1);

        if (array_index < _h_goods_id.length - 1) {
            array_index++; // 인덱스 증가
        }

        console.log("array_index : " + array_index);
        console.log(_h_goods_id.length - 1);

        var goods_id = _h_goods_id[array_index].value;
        var fileName = _h_goods_fileName[array_index].value;

        img_sticky.src = SERVER_URL + "?goods_id=" + goods_id + "&fileName=" + fileName;
        cur_goods_num.innerHTML = array_index + 1;

        console.log(cur_goods_num);
    }

    // 이전 버튼 클릭 시 호출되는 함수
    function fn_show_previous_goods() {
        var img_sticky = document.getElementById("img_sticky");
        var cur_goods_num = document.getElementById("cur_goods_num");
        var _h_goods_id = document.frm_sticky.h_goods_id;
        var _h_goods_fileName = document.frm_sticky.h_goods_fileName;

        if (array_index > 0) array_index--;

        var goods_id = _h_goods_id[array_index].value;
        var fileName = _h_goods_fileName[array_index].value;

        img_sticky.src = SERVER_URL + "?goods_id=" + goods_id + "&fileName=" + fileName;
        cur_goods_num.innerHTML = array_index + 1;
    }

    // 최근 본 상품 이미지 클릭 시 상세 페이지로 이동
    function goodsDetail() {
        var cur_goods_num = document.getElementById("cur_goods_num");
        var arrIdx = cur_goods_num.innerHTML - 1;
        var img_sticky = document.getElementById("img_sticky");
        var h_goods_id = document.frm_sticky.h_goods_id;
        var len = h_goods_id.length;

        var goods_id = (len > 1) ? h_goods_id[arrIdx].value : h_goods_id.value;
        console.log("len > 1 : " + goods_id);

        var formObj = document.createElement("form");
        var i_goods_id = document.createElement("input");
        i_goods_id.name = "goods_id";
        i_goods_id.value = goods_id;

        formObj.appendChild(i_goods_id);
        document.body.appendChild(formObj);
        formObj.method = "get";
        formObj.action = "${contextPath}/goods/goodsDetail.do";
        formObj.submit();
    }

    // 주문 취소 함수
    function fn_cancel_order(order_id) {
        var answer = confirm("주문을 취소하시겠습니까?");
        if (answer) {
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

    // show/hide 함수
    function show(elementId) {
        var element = document.getElementById(elementId);
        if (element) element.style.display = 'block';
    }

    function hide(elementId) {
        var element = document.getElementById(elementId);
        if (element) element.style.display = 'none';
    }
</script>
<body>
    <div id="sticky">
        <ul>
            <li>
                <a href="#">
                    <img width="24" height="24" src="${contextPath}/resources/image/facebook_icon.png"> 페이스북
                </a>
            </li>
            <li>
                <a href="#">
                    <img width="24" height="24" src="${contextPath}/resources/image/twitter_icon.png"> 트위터
                </a>
            </li>
            <li>
                <a href="#">
                    <img width="24" height="24" src="${contextPath}/resources/image/rss_icon.png"> RSS 피드
                </a>
            </li>
        </ul>
        <div class="recent">
            <h3>최근 본 상품</h3>
            <ul>
                <c:choose>
                    <c:when test="${empty sessionScope.quickGoodsList}">
                        <strong>최근본 상품이 없습니다.</strong>
                    </c:when>
                    <c:otherwise>
                        <form name="frm_sticky">
                            <c:forEach var="item" items="${sessionScope.quickGoodsList}" varStatus="itemNum">
                                <c:choose>
                                    <c:when test="${itemNum.count == 1}">
                                        <a href="javascript:goodsDetail();">
                                            <img width="75" height="95" id="img_sticky" src="${contextPath}/thumbnails.do?goods_id=${item.goods_id}&fileName=${item.goods_fileName}">
                                        </a>
                                        <input type="hidden" name="h_goods_id" value="${item.goods_id}" />
                                        <input type="hidden" name="h_goods_fileName" value="${item.goods_fileName}" /><br>
                                    </c:when>
                                    <c:otherwise>
                                        <input type="hidden" name="h_goods_id" value="${item.goods_id}" />
                                        <input type="hidden" name="h_goods_fileName" value="${item.goods_fileName}" />
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </form>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
        <div>
            <c:choose>
                <c:when test="${empty sessionScope.quickGoodsList}">
                    <h5>0/0</h5>
                </c:when>
                <c:otherwise>
                    <h5>
                        <a href='javascript:fn_show_previous_goods();'>이전</a> &nbsp;
                        <span id="cur_goods_num">1</span>/${sessionScope.quickGoodsListNum} &nbsp;
                        <a href='javascript:fn_show_next_goods();'>다음</a>
                    </h5>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
