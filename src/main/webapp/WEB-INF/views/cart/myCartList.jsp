<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 

<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />

<c:set var="myCartList"  value="${sessionScope.cartMap.myCartList}"  />
<c:set var="myGoodsList"  value="${sessionScope.cartMap.myGoodsList}"  />
<c:set  var="totalGoodsNum" value="0" />  
<c:set  var="totalDeliveryPrice" value="0" />
<c:set  var="totalDiscountedPrice" value="0" /> 

<head>
<script type="text/javascript">
function calcGoodsPrice(bookPrice,obj){
	var totalPrice,final_total_price,totalNum;
	var goods_qty=document.getElementById("select_goods_qty");
	var p_totalNum=document.getElementById("p_totalNum");
	var p_totalPrice=document.getElementById("p_totalPrice");
	var p_final_totalPrice=document.getElementById("p_final_totalPrice");
	var h_totalNum=document.getElementById("h_totalNum");
	var h_totalPrice=document.getElementById("h_totalPrice");
	var h_totalDelivery=document.getElementById("h_totalDelivery");
	var h_final_totalPrice=document.getElementById("h_final_totalPrice");
	if(obj.checked==true){
		totalNum=Number(h_totalNum.value)+Number(goods_qty.value);
		totalPrice=Number(h_totalPrice.value)+Number(goods_qty.value*bookPrice);
		final_total_price=totalPrice+Number(h_totalDelivery.value);
	}else{
		totalNum=Number(h_totalNum.value)-Number(goods_qty.value);
		totalPrice=Number(h_totalPrice.value)-Number(goods_qty.value)*bookPrice;
		final_total_price=totalPrice-Number(h_totalDelivery.value);
	}
	
	h_totalNum.value=totalNum;
	h_totalPrice.value=totalPrice;
	h_final_totalPrice.value=final_total_price;
	
	p_totalNum.innerHTML=totalNum;
	p_totalPrice.innerHTML=totalPrice;
	p_final_totalPrice.innerHTML=final_total_price;
}

function modify_cart_qty(goods_isbn,bookPrice,index){
	var length=document.frm_order_all_cart.cart_goods_qty.length;
	var _cart_goods_qty=0;
	if(length>1){ 
		_cart_goods_qty=document.frm_order_all_cart.cart_goods_qty[index].value;		
	}else{
		_cart_goods_qty=document.frm_order_all_cart.cart_goods_qty.value;
	}
		
	var cart_goods_qty=Number(_cart_goods_qty);
	
	$.ajax({
		type : "post",
		async : false,
		url : "${contextPath}/cart/modifyCartQty.do",
		data : { 
			goods_isbn:goods_isbn,
			cart_goods_qty:cart_goods_qty
		},
		success : function(data, textStatus) {
			if(data.trim()=='modify_success'){
				alert("수량을 변경했습니다!!");	
				location.reload();
			}else{
				alert("다시 시도해 주세요!!");	
			}
		},
		error : function(data, textStatus) {
			alert("에러가 발생했습니다."+data);
		}
	});
}

function delete_cart_goods(cart_id){
	var cart_id=Number(cart_id);
	var formObj=document.createElement("form");
	var i_cart = document.createElement("input");
	i_cart.name="cart_id";
	i_cart.value=cart_id;
	
	formObj.appendChild(i_cart);
    document.body.appendChild(formObj); 
    formObj.method="post";
    formObj.action="${contextPath}/cart/removeCartGoods.do";
    formObj.submit();
}

function fn_order_each_goods(goods_isbn,goods_title,goods_priceSales,goods_cover){
	var cart_goods_qty=document.getElementById("cart_goods_qty");
	var _order_goods_qty=cart_goods_qty.value;
	var formObj=document.createElement("form");
	var i_goods_isbn = document.createElement("input"); 
    var i_goods_title = document.createElement("input");
    var i_goods_priceSales=document.createElement("input");
    var i_goods_cover=document.createElement("input");
    var i_order_goods_qty=document.createElement("input");
    
    i_goods_isbn.name="goods_isbn";
    i_goods_title.name="goods_title";
    i_goods_priceSales.name="goods_priceSales";
    i_goods_cover.name="goods_cover";
    i_order_goods_qty.name="order_goods_qty";
    
    i_goods_isbn.value=goods_isbn;
    i_order_goods_qty.value=_order_goods_qty;
    i_goods_title.value=goods_title;
    i_goods_priceSales.value=goods_priceSales;
    i_goods_cover.value=goods_cover;
    
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

function fn_order_all_cart_goods(){
	var objForm=document.frm_order_all_cart;
	var cart_goods_qty=objForm.cart_goods_qty;
	var checked_goods=objForm.checked_goods;  
	var length=checked_goods.length;
	
	if(length>1){
		for(var i=0; i<length;i++){
			if(checked_goods[i].checked==true){
				order_goods_id=checked_goods[i].value;
				order_goods_qty=cart_goods_qty[i].value;
				cart_goods_qty[i].value=order_goods_id+":"+order_goods_qty;
			}
		}
	}else{
		order_goods_id=checked_goods.value;
		order_goods_qty=cart_goods_qty.value;
		cart_goods_qty.value=order_goods_id+":"+order_goods_qty;
	}
		
 	objForm.method="post";
 	objForm.action="${contextPath}/order/orderAllCartGoods.do"; 
 	objForm.submit();
}
</script>
</head>
<body>
	<table class="list_view">
		<tbody align=center >
			<tr style="background:#33ff00" >
				<td class="fixed" >구분</td>
				<td colspan=2 class="fixed">상품명</td>
				<td>정가</td>
				<td>판매가</td>
				<td>수량</td>
				<td>합계</td>
				<td>주문</td>
			</tr>
			
<c:choose>
  <c:when test="${ empty myCartList }">
    <tr>
       <td colspan=8 class="fixed">
         <strong>장바구니에 상품이 없습니다.</strong>
       </td>
    </tr>
  </c:when>
  <c:otherwise>
    <form name="frm_order_all_cart" method="post" action="${contextPath}/order/orderAllCartGoods.do">	   
      <c:forEach var="item" items="${myGoodsList }" varStatus="cnt">
          <c:set var="cart_goods_qty" value="${myCartList[cnt.count-1].cart_goods_qty}" />
          <c:set var="cart_id" value="${myCartList[cnt.count-1].cart_id}" />

			<tr>       
				<td>
					<input type="checkbox" 
					       name="checked_goods"  
					       value="${item.goods_isbn}"  
					       checked="checked"
					       onClick="calcGoodsPrice(${item.goods_priceSales*0.9},this)">
				</td>
				<td class="goods_image">
					<a href="${contextPath}/goods/goodsDetail.do?goods_isbn=${item.goods_isbn}">
						<img width="75" alt="" src="${contextPath}/thumbnails.do?goods_isbn=${item.goods_isbn}&fileName=${item.goods_cover}"  />
					</a>
				</td>
				<td>
					<h2>
						<a href="${contextPath}/goods/goodsDetail.do?goods_isbn=${item.goods_isbn}">${item.goods_title }</a>
					</h2>
				</td>
				<td class="price"><span>${item.goods_priceStandard }원</span></td>
				<td>
				   <strong>
				      <fmt:formatNumber value="${item.goods_priceSales*0.9}" type="number" var="discounted_price" />
			          ${discounted_price}원(10%할인)
			       </strong>
				</td>
				<td>
				   <input type="text" id="cart_goods_qty" name="cart_goods_qty" size=3 value="${cart_goods_qty}"><br>
					<a href="javascript:modify_cart_qty(${item.goods_isbn},${item.goods_priceSales*0.9},${cnt.count-1});" >
					    <img width=25 alt="" src="${contextPath}/resources/image/btn_modify_qty.jpg">
					</a>
				</td>
				<td>
				   <strong id="total_sales_price">
				    <fmt:formatNumber value="${item.goods_priceSales*0.9*cart_goods_qty}" type="number" var="total_sales_price" />
			        ${total_sales_price}원
				   </strong> 
				</td>
				<td>
				    <a href="javascript:fn_order_each_goods('${item.goods_isbn}','${item.goods_title}','${item.goods_priceSales}','${item.goods_cover}');">
				       <img width="75" alt="" src="${contextPath}/resources/image/btn_order.jpg">
					</a><br>
				 	<a href="#"> 
				 	   <img width="75" alt="" src="${contextPath}/resources/image/btn_order_later.jpg">
					</a><br> 
					<a href="#"> 
					   <img width="75" alt="" src="${contextPath}/resources/image/btn_add_list.jpg">
					</a><br> 
					<a href="javascript:delete_cart_goods('${cart_id}');"> 
					   <img width="75" alt="" src="${contextPath}/resources/image/btn_delete.jpg">
				   </a>
				</td>
			</tr>
			<c:set var="totalGoodsPrice" value="${totalGoodsPrice+(item.goods_priceSales*0.9*cart_goods_qty)}" />
			<c:set var="totalGoodsNum" value="${totalGoodsNum+1 }" /> 
	    </c:forEach>
		
		</tbody>
	</table>
	
	<div class="clear"></div>
 </c:otherwise>
</c:choose> 
	<br>
	<br>
	
	<table width=80% class="list_view" style="background:#cacaff">
	<tbody>
	     <tr align=center class="fixed">
	       <td class="fixed">총 상품수 </td>
	       <td>구매 할 상품수</td>
	       <td>총 상품금액</td>
	       <td></td>
	       <td>총 배송비</td>
	       <td></td>
	       <td>총 할인 금액 </td>
	       <td></td>
	       <td>최종 결제금액</td>
	     </tr>
		<tr cellpadding=40 align=center>
			<td>
			  <p id="p_totalGoodsNum">${totalGoodsNum}개 </p>
			  <input id="h_totalGoodsNum" type="hidden" value="${totalGoodsNum}" />
			</td>
			<td>
			  <p id="p_buyGoods">${totalGoodsNum}개 </p>
			  <input id="h_totalGoodsNum" type="hidden" value="${totalGoodsNum}" />
			</td>
			
	       <td>
	          <p id="p_totalGoodsPrice">
	          <fmt:formatNumber value="${totalGoodsPrice}" type="number" var="total_goods_price" />
	          ${total_goods_price}원
	          </p>
	          <input id="h_totalGoodsPrice" type="hidden" value="${totalGoodsPrice}" />
	       </td>
	       <td><img width="25" alt="" src="${contextPath}/resources/image/plus.jpg"></td>
	       <td>
	         <p id="p_totalDeliveryPrice">${totalDeliveryPrice }원</p>
	         <input id="h_totalDeliveryPrice" type="hidden" value="${totalDeliveryPrice}" />
	       </td>
	       <td><img width="25" alt="" src="${contextPath}/resources/image/minus.jpg"></td>
	       <td>
	         <p id="p_totalSalesPrice">${totalDiscountedPrice}원</p>
	         <input id="h_totalSalesPrice" type="hidden" value="${totalSalesPrice}" />
	       </td>
	       <td><img width="25" alt="" src="${contextPath}/resources/image/equal.jpg"></td>
	       <td>
	          <p id="p_final_totalPrice">
	          <fmt:formatNumber value="${totalGoodsPrice+totalDeliveryPrice-totalDiscountedPrice}" type="number" var="total_price" />
	          ${total_price}원
	          </p>
	          <input id="h_final_totalPrice" type="hidden" value="${totalGoodsPrice+totalDeliveryPrice-totalDiscountedPrice}" />
	       </td>
		</tr>
	</tbody>
	</table>
	<center>
    <br><br>
		 <a href="javascript:fn_order_all_cart_goods()">
		 	<img width="75" alt="" src="${contextPath}/resources/image/btn_order_final.jpg">  <!-- 주문하기 -->
		 </a>
		 <a href="#">
		 	<img width="75" alt="" src="${contextPath}/resources/image/btn_shoping_continue.jpg"> <!-- 쇼핑 계속하기 -->
		 </a>
	</center>
</form>	
</body>
