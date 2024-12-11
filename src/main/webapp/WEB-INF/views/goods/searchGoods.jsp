<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"
    isELIgnored="false"
    %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<%
     //치환 변수 선언합니다.
      pageContext.setAttribute("crcn", "\r\n"); //Space, Enter
      pageContext.setAttribute("br", "<br/>"); //br 태그
%> 
<head>
 <title>검색 도서 목록 페이지</title>
</head>
<body>
	<hgroup>
		<h1>컴퓨터와 인터넷</h1>
		<h2>오늘의 책</h2>
	</hgroup>
	<section id="new_book">
		<h3>새로나온 책</h3>
		<div id="left_scroll">
			<a href='javascript:slide("left");'><img src="${contextPath}/resources/image/left.gif"></a>
		</div>
		<div id="carousel_inner">
			<ul id="carousel_ul">
			<c:choose>
			   <c:when test="${ empty goodsList  }" >
			        <li>
					<div id="book">
						<a><h1>제품이없습니다.</h1></a>
					  </div>
				</li> 
			   </c:when>
			   <c:otherwise>
			    <c:forEach var="item" items="${goodsList }" >
			     <li>
					<div id="book">
						<a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id}">
						<img width="75" alt="" src="${contextPath}/thumbnails.do?goods_id=${item.goods_id}&fileName=${item.goods_fileName}">
						</a>
						<div class="sort">[컴퓨터 인터넷]</div>
						<div class="title">
							<a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id }">
							  ${item.goods_title}
							</a>
						</div>
						<div class="writer">${item.goods_writer} | ${item.goods_publisher}</div>
						<div class="price">
							<span>
							  <fmt:formatNumber  value="${item.goods_price}" type="number" var="goods_price" />
		                         ${goods_price}원
							</span> <br>
							 <fmt:formatNumber  value="${item.goods_price*0.9}" type="number" var="discounted_price" />
				               ${discounted_price}원(10%할인)
						</div>
					</div>
				</li>
				</c:forEach> 
				<li>
				</li> 
			   </c:otherwise>
			 </c:choose>
			 
			</ul>
		</div>
		<div id="right_scroll">
			<a href='javascript:slide("right");'><img  src="${contextPath}/resources/image/right.gif"></a>
		</div>
		<input id="hidden_auto_slide_seconds" type="hidden" value="0">

		<div class="clear"></div>
	</section>
	<div class="clear"></div>
	<div id="sorting">
		<ul>
			<li><a class="active" href="#">베스트 셀러</a></li>
			<li><a href="#">최신 출간</a></li>
			<li><a style="border: currentColor; border-image: none;" href="#">최근 등록</a></li>
		</ul>
	</div>
	<table id="list_view">
		<tbody>
		  <c:forEach var="item" items="${goodsList }"> 
			<tr>
					<td class="goods_image">
						<a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id}">
							   <img width="75" alt="" src="${contextPath}/thumbnails.do?goods_id=${item.goods_id}&fileName=${item.goods_fileName}">
						</a>
					</td>
					<td class="goods_description">
						<h2>
							<a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id }">${item.goods_title }</a>
						</h2>
						<c:set var="goods_pub_date" value="${item.goods_published_date }" />
					   <c:set var="arr" value="${fn:split(goods_pub_date,' ')}" />
						<div class="writer_press"  >${item.goods_writer }저
							|${item.goods_publisher }|<c:out value="${arr[0]}" />
						</div>
					</td>
					<td class="price"><span>${item.goods_price }원</span><br>
						<strong>
						 <fmt:formatNumber  value="${item.goods_price*0.9}" type="number" var="discounted_price" />
				               ${discounted_price}원
						</strong><br>(10% 할인)
					</td>
					<td><input type="checkbox" value=""></td>
					<td class="buy_btns">
						<UL>
							<li><a href="#">장바구니</a></li>
							<li><a href="#">구매하기</a></li>
							<li><a href="#">비교하기</a></li>
						</UL>
					</td>
			</tr>
			</c:forEach>
		</tbody>
	</table>
	<div class="clear"></div>
	<div id="page_wrap">
		<ul id="page_control">
			<li><a class="no_border" href="#">Prev</a></li>
			<c:set var="page_num" value="0" />
			<c:forEach var="count" begin="1" end="10" step="1">
				<c:choose>
					<c:when test="${count==1 }">
						<li><a class="page_contrl_active" href="#">${count+page_num*10 }</a></li>
					</c:when>
					<c:otherwise>
						<li><a href="#">${count+page_num*10 }</a></li>
					</c:otherwise>
				</c:choose>
			</c:forEach>
			<li><a class="no_border" href="#">Next</a></li>
		</ul>
		
	</div>
	
	
	
	
	
	<!--카카오 도서 실시간 검색 api를 이용한 기능 추가   -->
	
	<div class="search" style="text-align: center; margin: 20px;">
		<h1
			style="font-size: 24px; color: #444; margin-bottom: 20px; border-bottom: 1px solid #ccc; padding-bottom: 10px;">
			도서 현황 <span style="color: #FF5733;">실시간 빠른 검색</span>
		</h1>
		<div
			style="display: flex; justify-content: center; align-items: center; gap: 10px; margin-top: 20px;">
			<input type="text" id="searchQuery"
				placeholder="실시간 도서정보 확인가능"
				style="width: 60%; padding: 10px; font-size: 16px; border: 2px solid #ccc; 
				border-radius: 5px; box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);">

			<button id="searchButton"
				style="padding: 10px 20px; font-size: 16px; background-color: #FF5733; color: white; 
				border: none; border-radius: 5px; cursor: pointer; 
				box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);">
				검색
			</button>
		</div>
	</div>

	<p id="result"
		style="display: flex; flex-wrap: wrap; gap: 10px; justify-content: space-between; padding: 10px;"></p>

	<script src="https://code.jquery.com/jquery-3.7.1.js"
		integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" 
		crossorigin="anonymous">
	</script>

	<script>
		// 검색 버튼 클릭 이벤트
		$("#searchButton").on("click", function() {
			var query = $("#searchQuery").val(); // 입력 필드 값 가져오기

			// 검색어가 비어 있는지 확인
			if (!query) {
				alert("검색어를 입력해주세요.");
				return;
			}

			$.ajax({
				method: "GET",
				url: "https://dapi.kakao.com/v3/search/book?target=title",
				data: { query: query, size: 12 },
				headers: { Authorization: "KakaoAK 3ce47450eb78c196dbc94c071c4d5168" } //카카오 도서 실시간 검색 api 사용
			})
			.done(function(msg) {
				// 결과 초기화
				$("#result").empty();

				// 결과가 없는 경우
				if (msg.documents.length === 0) {
					$("#result").append("<strong>결과가 없습니다.</strong>");
					return;
				}

				// 결과 출력
				for (var i = 0; i < msg.documents.length; i++) {
					var title = msg.documents[i].title;
					var thumbnail = msg.documents[i].thumbnail;
					var authors = msg.documents[i].authors;
					var status = msg.documents[i].status;
					var price = msg.documents[i].price;
					var sale_price = msg.documents[i].sale_price;
					var contents = msg.documents[i].contents
					var publisher = msg.documents[i].publisher;
					var translators = msg.documents[i].translators

					//책들이 나열되는 영역
	                var card = $("<div></div>").css({
	                    "width": "20%", 
	                    "box-shadow": "0px 4px 6px rgba(0,0,0,0.1)",
	                    "border-radius": "8px",
	                    "padding": "10px",
	                    "text-align": "center",
	                    "background-color": "#fff",
	                    "cursor": "pointer", 
	                    "position": "relative",
	                    "margin-bottom": "20px"
	                });
					
	                card.append("<strong style='font-size:14px;'>" + title + "</strong><br>");
	                
	                if (thumbnail) {
	                    card.append("<img src='" + thumbnail + "' alt='책 표지' style='width:100px; margin-top: 10px; margin-bottom: 10px;'><br>");
	                } else {
	                    card.append("<span style='display:block; width:100px; height:100px; margin-top:10px; background-color:#f0f0f0; line-height:100px; text-align:center; border:1px solid #ddd;'>이미지 없음</span><br>");
	                }
	               
	                card.append("<span style='font-size:12px; color:gray;'>저자: " + authors + "</span><br>"); 
	                
	                card.append("<span style='font-size:12px; color:gray;'>출판사: " + publisher + "</span><br>");  
	                
	                if (translators && translators.length > 0) {
	                    card.append("<span style='font-size:12px; color:gray;'>번역: " + translators + "</span><br>");
	                } //만약 번역가의 데이터가 없다면 해당 값은 없는 값으로 보고 다음의 데이터를 받아옴
	              
	                card.append("<span style='font-size:12px; color:gray;'>정상판매가: " + price + "원</span><br>");
	                
	                if (sale_price === -1) { //sale_price의 -1값이 나온다면 0원으로 본다.
	                    card.append("<span style='font-size:12px; color:gray;'>할인판매가: 0원</span><br>");
	                } else {
	                    card.append("<span style='font-size:12px; color:gray;'>할인판매가: " + sale_price + "원</span><br>");
	                }
	                if (status) {
	                    card.append("<span style='font-size:12px; color:gray;'>" + status + "중</span><br>");
	                } else {
	                    card.append("<span style='font-size:12px; color:gray;'>재고 없음</span><br>");
	                }
	                
				    if (!contents || contents.trim() === "") {
				        contents = "책 소개가 없습니다";
				    }
				 // 숨겨진 컨텐츠 영역 추가
	                var contentDiv = $("<div></div>").css({
	                    "display": "none",
	                    "margin-top": "10px",
	                    "font-size": "12px",
	                    "color": "#333",
	                    "border-top": "1px solid #ccc",
	                    "padding-top": "10px"
	                }).text(contents);

	                card.append(contentDiv);
	                
	                card.on("click", function () {
	                    var contentElement = $(this).find("div"); // 숨겨진 컨텐츠 영역 선택
	                    if (contentElement.css("display") === "none") {
	                        contentElement.slideDown(); // 컨텐츠 표시
	                    } else {
	                        contentElement.slideUp(); // 컨텐츠 숨김
	                    }
	                });
	                
	                $("#result").append(card);
	            }
	        })
	        .fail(function () {
	            alert("API 요청 중 오류가 발생했습니다.");
	        });
	    });
	</script>