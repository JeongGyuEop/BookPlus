<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"
    isELIgnored="false"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
</head>
<body>
	<h1>1. 주문 상세정보</h1>
	<table class="list_view">
		<tbody align=center>
			<tr style="background: #33ff00">
			     <td>주문번호 </td>
			      <td>주문일자 </td>
				<td colspan=2 class="fixed">주문상품명</td>
				<td>수량</td>
				<td>주문금액</td>
				<td>배송비</td>
				<td>주문금액합계</td>
			</tr>
			<c:forEach var="item" items="${myOrderList }">
			<tr>
				    <td> ${item.orderId}</td>
				     <td> ${item.orderDate}</td>
					<td class="goods_image">
					  <%-- <a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id }">
					    <IMG width="75" alt=""  src="${contextPath}/thumbnails.do?goods_id=${item.goods_id}&fileName=${item.goods_fileName}">
					  </a> --%>
					 <img width="75" alt=""  src="${contextPath}/thumbnails.do?goods_id=${item.goodsId}<%--&fileName=${item.goods_fileName} --%>">
					  
					</td>
					<td>
					  <%-- <h2>
					     <a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id }">${item.goods_title }</a>
					  </h2> --%>
					  <h3>${item.goodsTitle }</h3>
					</td>
					<td>
					  <h2>${item.orderGoodsQty }개</h2>
					</td>
					<td><h2><%-- ${item.orderGoodsQty *item.goods_sales_price} --%>원 </h2></td>
					<td><h2>0원</h2></td>
					<td>
					  <h2>${totalPrice}원</h2>
					</td>
			</tr>
		</c:forEach>
	</tbody>
</table>
<div class="clear"></div>
<form name="form_order">
	<br><br>
	<h1>2.배송지 정보</h1>
	<div class="detail_table">
		<table>
			<tbody>
				<tr class="dot_line">
					<td class="fixed_join">배송방법</td>
					<td>
					   ${myOrderList[0].deliveryMethod }
				    </td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">받으실 분</td>
					<td>
					${myOrderList[0].receiverName }
					</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">휴대폰번호</td>
					<td>
					  ${myOrderList[0].receiverHp1}-${myOrderList[0].receiverHp2}-${myOrderList[0].receiverHp3}</td>
				  </tr>
				<tr class="dot_line">
					<td class="fixed_join">주소</td>
					<td>
					   ${myOrderList[0].deliveryAddress}
					</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">배송 메시지</td>
					<td>
						<c:choose>
				            <c:when test="${not empty myOrderList[0].deliveryMessage}">
				                ${myOrderList[0].deliveryMessage}
				            </c:when>
				            <c:otherwise>
				                없음
				            </c:otherwise>
				        </c:choose>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
	<div>
		<br><br>
		<h2>주문고객</h2>
		<table>
			<tbody>
				<tr class="dot_line">
					<td><h2>이름</h2></td>
					<td><input type="text" value="${orderer.member_name}" size="15" disabled /></td>
				</tr>
				<tr class="dot_line">
					<td><h2>핸드폰</h2></td>
					<td><input type="text" value="${orderer.hp1}-${orderer.hp2}-${orderer.hp3}" size="15" disabled /></td>
				</tr>
				<tr class="dot_line">
					<td><h2>이메일</h2></td>
					<td><input type="text" value="${orderer.email1}@${orderer.email2}" size="15" disabled /></td>
				</tr>
			</tbody>
		</table>
	</div>
	<div class="clear"></div>
	<br><br><br>
	<h1>3.결제정보</h1>
	<div class="detail_table">
		<table>
			<tbody>
				<tr class="dot_line">
					<td class="fixed_join">결제방법</td>
					<td>
					   <%-- ${myOrderList[0].pay_method } --%>
				    </td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">결제카드</td>
					<td>
					   <%-- ${myOrderList[0].card_com_name} --%>
				    </td>
				</tr>
			</tbody>
		</table>
	</div>
</form>
<div class="clear"></div>
<br><br><br><br><br>
<a href="${contextPath}/main/main.do">
	<img width="75" alt="" src="${contextPath}/resources/image/btn_shoping_continue.jpg">
</a>
<div class="clear"></div>
</body>
</html>
