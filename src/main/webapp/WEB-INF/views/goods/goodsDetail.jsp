<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8" 	isELIgnored="false"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />

<c:set var="goods"  value="${goodsMap.goodsVO}"  />
<c:set var="imageList"  value="${goodsMap.imageList }"  />

<html>
<head>
<style>
#layer {
	z-index: 2;
	position: absolute;
	top: 0px;
	left: 0px;
	width: 100%;
}
#popup {
	z-index: 3;
	position: fixed;
	text-align: center;
	left: 50%;
	top: 45%;
	width: 300px;
	height: 200px;
	background-color: #ccffff;
	border: 3px solid #87cb42;
}
#close {
	z-index: 4;
	float: right;
}
</style>
<script type="text/javascript">
//장바구니에 추가
function add_cart(goods_isbn) {
	$.ajax({
		type : "post",
		async : false,
		url : "${contextPath}/cart/addGoodsInCart.do",
		data : { goods_isbn:goods_isbn },
		success : function(data, textStatus) {
			if(data.trim()=='add_success'){
				imagePopup('open', '.layer01');	
			}else if(data.trim()=='already_existed'){
				alert("이미 카트에 등록된 상품입니다.");	
			}
		},
		error : function(data, textStatus) {
			alert("에러가 발생했습니다."+data);
		},
		complete : function(data, textStatus) {
			//작업 완료
		}
	});
}

// 팝업창 열고 닫기
function imagePopup(type) {
	if (type == 'open') {
		$('#layer').attr('style', 'visibility:visible');
		$('#layer').height(jQuery(document).height());
	} else if (type == 'close') {
		$('#layer').attr('style', 'visibility:hidden');
	}
}

//구매하기
function fn_order_each_goods(goods_isbn,goods_title,goods_priceSales,goods_cover){
	var _isLogOn=document.getElementById("isLogOn");
	var isLogOn=_isLogOn.value;
	
	if(isLogOn == "false" || isLogOn == '' ){
		alert("로그인 후 주문이 가능합니다!!!");
		return;
	}
	
	var order_goods_qty=document.getElementById("order_goods_qty");
	var formObj=document.createElement("form");
	
	var i_goods_isbn = document.createElement("input"); 
    i_goods_isbn.name="goods_isbn";
    i_goods_isbn.value=goods_isbn;
    
    var i_goods_title = document.createElement("input");
    i_goods_title.name="goods_title";
    i_goods_title.value=goods_title;
    
    var i_goods_priceSales=document.createElement("input");
    i_goods_priceSales.name="goods_priceSales";
    i_goods_priceSales.value=goods_priceSales;
    
    var i_goods_cover=document.createElement("input");
    i_goods_cover.name="goods_cover";
    i_goods_cover.value=goods_cover;
    
    var i_order_goods_qty=document.createElement("input");
    i_order_goods_qty.name="order_goods_qty";
    i_order_goods_qty.value = order_goods_qty.value;
  
    formObj.appendChild(i_goods_isbn);
    formObj.appendChild(i_goods_title);
    formObj.appendChild(i_goods_priceSales);
    formObj.appendChild(i_goods_cover);
    formObj.appendChild(i_order_goods_qty);

    document.body.appendChild(formObj); 
    formObj.method="post";
    formObj.action="${contextPath}/order/orderEachGoods.do";
    formObj.submit();
}
</script>
</head>
<body>
	<hgroup>
		<h1>컴퓨터와 인터넷</h1>
		<h2>국내외 도서 &gt; 컴퓨터와 인터넷 &gt; 웹 개발</h2>
		<h3>${goods.goods_title }</h3>
		<h4>${goods.goods_author} &nbsp; 저| ${goods.goods_publisher}</h4>
	</hgroup>
	<div id="goods_image">
		<figure>
			<img alt="${goods.goods_title}"
				src="${contextPath}/thumbnails.do?goods_isbn=${goods.goods_isbn}&fileName=${goods.goods_cover}">
		</figure>
	</div>
	<div id="detail_table">
		<table>
			<tbody>
				<tr>
					<td class="fixed">정가</td>
					<td class="active"><span>
					   <fmt:formatNumber  value="${goods.goods_priceStandard}" type="number" var="goods_priceStandard" />
				         ${goods_priceStandard}원
					</span></td>
				</tr>
				<tr class="dot_line">
					<td class="fixed">판매가</td>
					<td class="active"><span >
					   <fmt:formatNumber  value="${goods.goods_priceSales}" type="number" var="discounted_price" />
				         ${discounted_price}원
					</span>(할인가)</td>
				</tr>
				<tr>
					<td class="fixed">포인트적립</td>
					<td class="active">${goods.goods_point}P(10%적립)</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed">포인트 추가적립</td>
					<td class="fixed">만원이상 구매시 1,000P, 5만원이상 구매시 2,000P추가적립 편의점 배송 이용시 300P 추가적립</td>
				</tr>
				<tr>
					<td class="fixed">발행일</td>
					<td class="fixed">
					   <c:set var="pub_date" value="${goods.goods_pubDate}" />
					   <c:set var="arr" value="${fn:split(pub_date,' ')}" />
					   <c:out value="${arr[0]}" />
					</td>
				</tr>
				<tr>
					<td class="fixed">페이지 수</td>
					<td class="fixed">${goods.goods_total_page}쪽</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed">ISBN</td>
					<td class="fixed">${goods.goods_isbn}</td>
				</tr>
				<tr>
					<td class="fixed">배송료</td>
					<td class="fixed"><strong>무료</strong></td>
				</tr>
				<tr>
					<td class="fixed">배송안내</td>
					<td class="fixed">
						<strong>[당일배송]</strong> 당일배송 서비스 시작!<br> 
						<strong>[휴일배송]</strong>
						휴일에도 배송받는 Bookshop
					</td>
				</tr>
				<tr>
					<td class="fixed">도착예정일</td>
					<td class="fixed">지금 주문 시 내일 도착 예정</td>
				</tr>
				<tr>
					<td class="fixed">수량</td>
					<td class="fixed">
					      <select style="width: 60px;" id="order_goods_qty">
				      		<option>1</option>
							<option>2</option>
							<option>3</option>
							<option>4</option>
							<option>5</option>
					     </select>
					 </td>
				</tr>
			</tbody>
		</table>
		<ul>
			<li><a class="buy" href="javascript:fn_order_each_goods('${goods.goods_isbn }','${goods.goods_title }','${goods.goods_priceSales}','${goods.goods_cover}');">구매하기</a></li>
			<li><a class="cart" href="javascript:add_cart('${goods.goods_isbn }')">장바구니</a></li>
			<li><a class="wish" href="#">위시리스트</a></li>
		</ul>
	</div>
	<div class="clear"></div>
	<div id="container">
		<ul class="tabs">
			<li><a href="#tab1">책소개</a></li>
			<li><a href="#tab2">저자소개</a></li>
			<li><a href="#tab3">책목차</a></li>
			<li><a href="#tab4">출판사서평</a></li>
			<li><a href="#tab5">추천사</a></li>
			<li><a href="#tab6">리뷰</a></li>
		</ul>
		<div class="tab_container">
			<div class="tab_content" id="tab1">
				<h4>책소개</h4>
				<p>${fn:replace(goods.goods_intro,crcn,br)}</p>
				<c:forEach var="image" items="${imageList }">
					<img src="${contextPath}/download.do?goods_isbn=${goods.goods_isbn}&fileName=${image.goods_cover}">
				</c:forEach>
			</div>
			<div class="tab_content" id="tab2">
				<h4>저자소개</h4>
				<p>
				<div class="writer">저자 : ${goods.goods_author}</div>
				 <p>${fn:replace(goods.goods_author_intro,crcn,br) }</p> 
			</div>
			<div class="tab_content" id="tab3">
				<h4>책목차</h4>
				<p>${fn:replace(goods.goods_contents_order,crcn,br)}</p> 
			</div>
			<div class="tab_content" id="tab4">
				<h4>출판사서평</h4>
				<p>${fn:replace(goods.goods_publisher_comment ,crcn,br)}</p> 
			</div>
			<div class="tab_content" id="tab5">
				<h4>추천사</h4>
				<p>${fn:replace(goods.goods_recommendation,crcn,br)}</p>
			</div>
			<div class="tab_content" id="tab6">
				<h4>리뷰</h4>
			</div>
		</div>
	</div>
	<div class="clear"></div>
	<div id="layer" style="visibility: hidden">
		<div id="popup">
			<a href="javascript:" onClick="javascript:imagePopup('close', '.layer01');"> 
				<img src="${contextPath}/resources/image/close.png" id="close" />
			</a> 
			<br /> 
			<font size="12" id="contents">장바구니에 담았습니다.</font>
			<br>
			<form action='${contextPath}/cart/myCartList.do'  >				
				<input type="submit" value="장바구니 보기">
			</form>			
		</div>
	</div>		
</body>
</html>
<input type="hidden" name="isLogOn" id="isLogOn" value="${isLogOn}"/>
