<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />

<c:set var="myCartList" value="${sessionScope.cartMap.myCartList}" />
<c:set var="myGoodsList" value="${sessionScope.cartMap.myGoodsList}" />


<%-- 장바구니테이블에 추가된 상품의 총 개수를 저장할 변수 선언  --%>
<c:set var="totalGoodsNum" value="0" />
<%-- 장바구니테이블에 추가된 상품의 총 배송비를 저장할 변수 선언 --%>
<c:set var="totalDeliveryPrice" value="0" />
<%-- 장바구니테이블에 추가된 상품의 총 할인 금액을 저장할 변수 선언 --%>
<c:set var="totalDiscountedPrice" value="0" />
<%-- 장바구니테이블에 추가된 상품의 총 주문 금액을 저장할 변수 선언 --%>
<c:set var="totalGoodsPrice" value="0" />

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

//수량 입력후 [변경] 버튼을 클릭했을때 호출되는 함수 
//상품번호, 상품가격, 장바구니 목록에서 체크한 상품의 행 위치 index
function modify_cart_qty(goods_id,bookPrice,index){
	 
   //주문 수량을 입력하는 <input>태그들이 cart_goods_qty배열에 저장되어 있으므로 개수 알아내오기 
   var length=document.frm_order_all_cart.cart_goods_qty.length;
   var _cart_goods_qty=0;
   
   //장바구니 목록에 주문할 상품이 여러개 인경우 (주문 수량을 입력하는 <input>태그가 여러개인 경우)
	if(length>1){ 
		_cart_goods_qty=document.frm_order_all_cart.cart_goods_qty[index].value;		
	}else{
		_cart_goods_qty=document.frm_order_all_cart.cart_goods_qty.value;
	}
		
	var cart_goods_qty=Number(_cart_goods_qty);
	
   if(cart_goods_qty >= 1){

	   //입력한 주문 수량 정보를 DB에 수정 하기 위해 요청!
		$.ajax({
			type : "post",
			async : false, //false인 경우 동기식으로 처리한다.
			url : "${contextPath}/cart/modifyCartQty.do",
			data : { 
				//상품 번호 
				goods_id:goods_id,
				//상품번호에 해당하는 상품의 수량 
				cart_goods_qty:cart_goods_qty
			},
			
			success : function(data, textStatus) {
				//alert(data);
				if(data.trim()=='modify_success'){
					alert("수량을 변경했습니다!!");	
					location.reload();
				}else{
					alert("다시 시도해 주세요!!");	
				}
			},
			error : function(data, textStatus) {
				alert("수량을 변경하는 도중 에러가 발생했습니다."+data);
			}
		}); //end ajax	
   } else {
	   alert("수량은 1개 이상이어야 합니다. 다시 입력해 주세요.");
   }

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

function fn_order_each_goods(goods_id) {
    // 로그인 여부 확인
    var isLogOn = document.getElementById("isLogOn").value; 
    if (isLogOn === "false" || isLogOn === '') {
        alert("로그인 후 주문이 가능합니다!!!");
    }

    // 선택된 수량 확인
    var order_goods_qty = document.getElementById("order_goods_qty").value;

    // 폼 생성 및 데이터 추가
    var formObj = document.createElement("form");
    formObj.method = "post";
    formObj.action = "${contextPath}/order/orderEachGoods.do";

    // 폼 데이터 배열
    var formData = [
        { name: "goodsId", value: goods_id },
        { name: "orderGoodsQty", value: order_goods_qty }
    ];

    console.log(goods_id);
    console.log(order_goods_qty);
    
    // 폼에 데이터 추가
    formData.forEach(function(item) {
        var input = document.createElement("input");
        input.type = "hidden";
        input.name = item.name;
        input.value = item.value;
        formObj.appendChild(input);
    });

    // 폼 제출
    document.body.appendChild(formObj);
    formObj.submit();
    document.body.removeChild(formObj);
}

//장바구니 목록 화면의 주문하기 이미지를 클릭했을때.... 호출되는 함수
function fn_order_all_cart_goods(){
	var objForm=document.frm_order_all_cart;
	var cart_goods_qty=objForm.cart_goods_qty;
	var checked_goods=objForm.checked_goods;  
	var length=checked_goods.length;
	var h_order_each_goods_qty=objForm.h_order_each_goods_qty;
	
/* 	
	<input type="checkbox" 
        name="checked_goods"  
        value="${item.goods_id }"  
        checked="checked"
        onClick="calcGoodsPrice(${item.goods_sales_price },this)">
     
        <input type="checkbox" 
	           name="checked_goods"  
	           value="${item.goods_id }"  
	           checked="checked"
	           onClick="calcGoodsPrice(${item.goods_sales_price },this)">   
    
	           
	장바구니에 저장된 상품이 2개라면?  checked_goods배열에 위 <input type="checkbox">태그가 2개 저장되어 있고
	checked_goods배열을     checked_goods변수에 저장   		   
 */	var checked_goods=objForm.checked_goods;  //요약 : 상품 주문 여부를 체크하는 체크박스 들을 checked_goods 배열에 담아  checked_goods배열을 선택해 옵니다. 
 

	var length=checked_goods.length; //요약 : 주문용으로 선택한(체크한) 총 상품 개수를 가져옵니다. 
	
	//요약 : 여러 상품을 주문할 경우  하나의 상품에 대해 '상품번호:주문수량' 문자열로 만든 후 전체 상품 정보를 배열로 전송합니다. 
	//장바구니 목록화면에서 구매할 상품을 체크하는  <input type="checkbox">태그가  여러개 라면?
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
		<tbody align=center>
			<tr style="background: #33ff00">
				<td class="fixed">구분</td>
				<td colspan=2 class="fixed">상품명</td>
				<td>정가</td>
				<td>판매가</td>
				<td>수량</td>
				<td>배송비</td>
				<td>합계</td>
				<td>주문</td>
			</tr>
			<c:choose>
			    <c:when test="${empty myCartList}">
			        <tr>
			            <td colspan=8 class="fixed"><strong>장바구니에 상품이 없습니다.</strong></td>
			        </tr>
			    </c:when>
			    <c:otherwise>
			        <form name="frm_order_all_cart" method="post" action="${contextPath}/order/orderAllCartGoods.do">
			            <c:forEach var="item" items="${myGoodsList}" varStatus="cnt">
			                <tr>
			                    <c:set var="cart_goods_qty" value="${myCartList[cnt.count-1].cart_goods_qty}" />
			                    <c:set var="cart_id" value="${myCartList[cnt.count-1].cart_id}" />
			                    
			                    <td>
			                        <input type="checkbox" name="checked_goods" value="${item.goods_id}" checked="checked" 
			                               onClick="calcGoodsPrice(${item.goods_sales_price}, this)">
			                    </td>
			                    <td class="goods_image">
			                        <a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id}">
			                            <img width="75" alt="" src="${item.goods_fileName}" />
			                        </a>
			                    </td>
			                    <td>
			                        <h2>
			                            <a href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id}">${item.goods_title}</a>
			                        </h2>
			                    </td>
			                    <td class="price"><span>${item.goods_price}원</span></td>
			                    <td>
			                        <strong>
			                            <fmt:formatNumber value="${item.goods_price * (100 - item.goods_sales_price) / 100}" 
			                                              type="number" var="discounted_price" />
			                            ${discounted_price}원(${item.goods_sales_price}% 할인)
			                        </strong>
			                    </td>
			                    <td>
			                        <input type="text" id="cart_goods_qty" name="cart_goods_qty" size="3" value="${cart_goods_qty}">
			                        <a href="javascript:modify_cart_qty(${item.goods_id}, ${item.goods_sales_price}, ${cnt.count-1});">
			                            <img width="25" alt="" src="${contextPath}/resources/image/btn_modify_qty.jpg">
			                        </a>
			                    </td>
			                    <td><strong>${item.goods_delivery_price}원</strong></td>
			                    <td>
			                        <strong id="total_sales_price">
			                            <fmt:formatNumber value="${((item.goods_price * (100 - item.goods_sales_price) / 100) * cart_goods_qty) + item.goods_delivery_price}" 
			                                              type="number" var="total_sales_price" />
			                            ${total_sales_price}원
			                        </strong>
			                    </td>
			                    <td>
			                        <a href="javascript:fn_order_each_goods('${item.goods_id}');">
			                            <img width="75" alt="" src="${contextPath}/resources/image/btn_order.jpg">
			                        </a>
			                        <br>
			                        <a href="javascript:delete_cart_goods('${cart_id}');">
			                            <img width="75" alt="" src="${contextPath}/resources/image/btn_delete.jpg">
			                        </a>
			                    </td>
			                </tr>
			                <!-- 누적 합산 -->
			                <c:set var="totalGoodsNum" value="${totalGoodsNum + 1}" />
			                <c:set var="totalGoodsPrice" value="${totalGoodsPrice + (item.goods_price * cart_goods_qty)}" />
			                <c:set var="totalDiscountedPrice" value="${totalDiscountedPrice + ((item.goods_price - (item.goods_price * (100 - item.goods_sales_price) / 100)) * cart_goods_qty)}" />
			                <c:set var="totalDeliveryPrice" value="${totalDeliveryPrice + item.goods_delivery_price}" />
			            </c:forEach>
			        </form>
			    </c:otherwise>
			</c:choose>
		</tbody>
	</table>

	<br><br>

	<table width=80% class="list_view" style="background: #cacaff">
		<tbody>
			<tr align=center class="fixed">
				<td class="fixed">상품명</td>
				<td>구매 할 상품수</td>
				<td>총 상품금액</td>
				<td></td>
				<td>총 배송비</td>
				<td></td>
				<td>총 할인 금액</td>
				<td></td>
				<td>최종 결제금액</td>
			</tr>
			<tr cellpadding=40 align=center>
				<td>
					<p id="p_totalGoodsNum">${totalGoodsNum}개</p> <input
					id="h_totalGoodsNum" type="hidden" value="${totalGoodsNum}" />
				</td>
				<td id="">
					<p id="p_buyGoods">${cart_goods_qty}개</p> <input
					id="h_totalGoodsNum" type="hidden" value="${cart_goods_qty}" />
				</td>

				<td>
					<p id="p_totalGoodsPrice">
						<fmt:formatNumber value="${totalGoodsPrice}" type="number"
							var="total_goods_price" />
						${total_goods_price}원
					</p> <input id="h_totalGoodsPrice" type="hidden"
					value="${totalGoodsPrice}" />
				</td>
				<td><img width="25" alt=""
					src="${contextPath}/resources/image/plus.jpg"></td>
				<td>
					<p id="p_totalDeliveryPrice">${totalDeliveryPrice }원</p> <input
					id="h_totalDeliveryPrice" type="hidden"
					value="${totalDeliveryPrice}" />
				</td>
				<td><img width="25" alt=""
					src="${contextPath}/resources/image/minus.jpg"></td>
				<td><fmt:formatNumber value="${totalDiscountedPrice}"
						type="number" var="totalDiscountedPrice2" />
					<p id="p_totalSalesPrice">${totalDiscountedPrice2}원</p> <input
					id="h_totalSalesPrice" type="hidden" value="${totalSalesPrice2}" />
				</td>
				<td><img width="25" alt=""
					src="${contextPath}/resources/image/equal.jpg"></td>
				<td>
					<p id="p_final_totalPrice">
						<fmt:formatNumber value="${totalGoodsPrice+totalDeliveryPrice-totalDiscountedPrice}" type="number" var="total_price" />
						${total_price}원
					</p> 
					<input id="h_final_totalPrice" type="hidden" value="${totalGoodsPrice+totalDeliveryPrice}" />
				</td>
			</tr>
		</tbody>
	</table>
	<br><br> 
		<a href="javascript:fn_order_all_cart_goods()"> 
		<img width="75" alt="" src="${contextPath}/resources/image/btn_order_final.jpg"> <!-- 주문하기 -->
		</a> <a href="${contextPath}/main/main.do"> <img width="75" alt="" src="${contextPath}/resources/image/btn_shoping_continue.jpg">
			<!-- 쇼핑 계속하기 -->
		</a>
		
</body>
