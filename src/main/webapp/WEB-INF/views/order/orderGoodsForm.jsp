<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!-- 주문자 휴대폰 번호 -->
<c:set var="orderer_hp" value="" />
<!-- 최종 결제 금액 -->
<c:set var="final_total_order_price" value="0" />
<!-- 총주문 금액 -->
<c:set var="total_order_price" value="0" />
<!-- 총 상품수 -->
<c:set var="total_order_goods_qty" value="0" />
<!-- 총할인금액 -->
<c:set var="total_discount_price" value="0" />
<!-- 총 배송비 -->
<c:set var="total_delivery_price" value="0" />

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>주문 확인 및 결제</title>
	<style>
		#layer {
			z-index: 2;
			position: absolute;
			top: 0px;
			left: 0px;
			width: 100%;
			/* 	background-color:rgba(0,0,0,0.8);  */
		}
		
		#popup_order_detail {
			z-index: 3;
			position: fixed;
			text-align: center;
			left: 10%;
			top: 0%;
			width: 60%;
			height: 100%;
			background-color: #ccff99; /* 팝업창의 배경색 설정*/
			border: 2px solid #0000ff;
		}
		
		#close {
			z-index: 4;
			float: right;
		}
	</style>


	<!-- jQuery -->
	<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
	<!-- iamport.payment.js -->
	<script src="https://cdn.iamport.kr/v1/iamport.js"></script>
	<script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>

	<script>
	    var IMP = window.IMP;
	    IMP.init("imp63260822"); // 아임포트 초기화
	    
		//==========
		// 페이지 로드될 때 호출되는 함수
		window.onload = function() {
			init();
		}
	
		function requestPay() {
		    var buyerName = document.getElementById("order_name").value;
		    var buyerEmail = document.getElementById("order_email").value;
		    var buyerTel = document.getElementById("order_phone").value;
		    var buyerAddr = document.getElementById("roadAddress").value + " " +
		                    document.getElementById("jibunAddress").value + " " +
		                    document.getElementById("namujiAddress").value;
		    var buyerPostcode = document.getElementById("zipcode").value;
		    var merchantUid = "ORD_" + document.getElementById("h_goods_id").value + "_" + new Date().getTime();
		    var amount = document.getElementById("h_final_total_Price").value;
		    var goodsName = document.getElementById("h_goods_title").value;

		    IMP.request_pay({
		        pg: "html5_inicis",
		        pay_method: "card",
		        merchant_uid: merchantUid,
		        name: goodsName,
		        amount: amount,
		        buyer_email: buyerEmail,
		        buyer_name: buyerName,
		        buyer_tel: buyerTel,
		        buyer_addr: buyerAddr,
		        buyer_postcode: buyerPostcode
		    }, function(rsp) {
		        if (rsp.success) {
		            alert("결제가 성공적으로 완료되었습니다.");
		            
		            $.ajax({
		                type: "POST",
		                url: "/order/paySuccess", // 서버의 결제 성공 처리 API
		                contentType: "application/json",
		                data: JSON.stringify({
		                	 // 기본 결제 정보
		                    imp_uid: rsp.imp_uid, // 아임포트에서 생성한 결제 고유 ID
		                    merchant_uid: rsp.merchant_uid, // 상점에서 생성한 고유 주문 번호
		                    amount: rsp.paid_amount, // 실제 결제된 금액
		                    pay_method: rsp.pay_method, // 결제 방식 (예: "card", "trans", "vbank" 등)
		                    status: rsp.status, // 결제 상태 ("paid": 결제 성공, "failed": 결제 실패)

		                    // 주문 관련 정보
		                    order_id: rsp.merchant_uid, // 주문 고유 번호 (merchant_uid와 동일)
		                    goods_id: document.getElementById("h_goods_id").value, // 상품 ID
		                    goods_title: document.getElementById("h_goods_title").value, // 상품 제목
		                    order_goods_qty: document.getElementById("h_order_goods_qty").value, // 주문 수량

		                    // 배송 관련 정보
		                    receiver_name: document.getElementById("receiver_name").value, // 수령인 이름
		                    receiver_hp1: document.getElementById("hp1").value, // 수령인 전화번호 앞자리 (예: "010")
		                    receiver_hp2: document.getElementById("hp2").value, // 수령인 전화번호 중간자리
		                    receiver_hp3: document.getElementById("hp3").value, // 수령인 전화번호 뒷자리
		                    delivery_address: document.getElementById("roadAddress").value + " " +
		                                      document.getElementById("jibunAddress").value + " " +
		                                      document.getElementById("namujiAddress").value, // 배송지 주소 (도로명 주소 + 지번 주소 + 나머지 주소)

		                    // 추가 결제 정보
		                    delivery_message: document.getElementById("delivery_message").value, // 배송 메시지 (예: "부재 시 경비실에 맡겨주세요.")
		                    final_total_price: document.getElementById("h_final_total_Price").value // 최종 결제 금액 (총 상품 금액 + 배송비 - 할인 금액)
		                
		                }),
		                success: function(response) {
		                    if (response.success) {
		                        alert("결제 정보가 성공적으로 저장되었습니다.");
		                        window.location.href = "/order/complete"; // 주문 완료 페이지로 이동
		                    } else {
		                        alert("결제 정보 저장에 실패했습니다. 관리자에게 문의하세요.");
		                    }
		                },
		                error: function(xhr, status, error) {
		                    console.error("결제 정보 전송 중 오류 발생:", error);
		                    alert("서버와 통신 중 오류가 발생했습니다. 관리자에게 문의하세요.");
		                }
		            });

		        } else {
		            alert("결제 실패: " + rsp.error_msg);
		        }
		    });
		}

		
		//===========
		// 우편번호 검색
		function execDaumPostcode() {
			new daum.Postcode(
				{
					oncomplete : function(data) {
						// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.
	
						// 도로명 주소의 노출 규칙에 따라 주소를 조합한다.
						// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
						var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
						var extraRoadAddr = ''; // 도로명 조합형 주소 변수
	
						// 법정동명이 있을 경우 추가한다. (법정리는 제외)
						// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
						if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
							extraRoadAddr += data.bname;
						}
						// 건물명이 있고, 공동주택일 경우 추가한다.
						if (data.buildingName !== '' && data.apartment === 'Y') {
							extraRoadAddr += (extraRoadAddr !== '' ? ', '
									+ data.buildingName : data.buildingName);
						}
						// 도로명, 지번 조합형 주소가 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
						if (extraRoadAddr !== '') {
							extraRoadAddr = ' (' + extraRoadAddr + ')';
						}
						// 도로명, 지번 주소의 유무에 따라 해당 조합형 주소를 추가한다.
						if (fullRoadAddr !== '') {
							fullRoadAddr += extraRoadAddr;
						}
	
						// 우편번호와 주소 정보를 해당 필드에 넣는다.
						document.getElementById('zipcode').value = data.zonecode; //5자리 새우편번호 사용
						document.getElementById('roadAddress').value = fullRoadAddr;
						document.getElementById('jibunAddress').value = data.jibunAddress;
	
						// 사용자가 '선택 안함'을 클릭한 경우, 예상 주소라는 표시를 해준다.
						if (data.autoRoadAddress) {
							//예상되는 도로명 주소에 조합형 주소를 추가한다.
							var expRoadAddr = data.autoRoadAddress
									+ extraRoadAddr;
							document.getElementById('guide').innerHTML = '(예상 도로명 주소 : '
									+ expRoadAddr + ')';
	
						} else if (data.autoJibunAddress) {
							var expJibunAddr = data.autoJibunAddress;
							document.getElementById('guide').innerHTML = '(예상 지번 주소 : '
									+ expJibunAddr + ')';
	
						} else {
							document.getElementById('guide').innerHTML = '';
						}
					}
				}).open();
		}
	
		
		//==========
		// 초기화 하기 위한 함수
		function init() {
	
			//<form  name="form_order"> ...... </form>
			var form_order = document.form_order;
	
			//로그인 한 주문자의 유선전화번호 중 지역번호를 option태그가 선택되도록 설정 하는 부분  	
			//<input type="hidden" id="h_tel1" name="h_tel1" value="${sessionScope.orderer.tel1 }" />
			var h_tel1 = form_order.h_tel1;
			// 로그인한 회원(상품 주문하는 사람) 유선 전화번호 051 , 02  등등 중에 하나 얻기 
			var tel1 = h_tel1.value;
			// <select id="tel1" name="tel1">....</select>  유선전화번호     
			select_tel1.value = tel1; //유선전화 번호 중  지역번호  051 , 02, 031 등등  ... 중에 하나 로 설정됨  (DB의 테이블에 저장되어 있는 값과 동일)
	
			//로그인 한 주문자의 휴대폰번호 중  앞 010, 011, 017, 018 중  option태그가 선택되도록 설정 하는 부분     (DB의 테이블에 저장되어 있는 값과 동일)
			var h_hp1 = form_order.h_hp1;
			var hp1 = h_hp1.value;
			var select_hp1 = form_order.hp1;
			select_hp1.value = hp1;
	
		}
		
		//=========
		// 배송지 선택에서 새로 입력을 선택했을 경우 입력 활성화
		function setAddressEditable(editable) {
		    const fields = [
		        "receiver_name",
		        "hp1",
		        "hp2",
		        "hp3",
		        "zipcode",
		        "roadAddress",
		        "jibunAddress",
		        "namujiAddress",
		    ];
	
		    fields.forEach((id) => {
		        const field = document.getElementById(id);
		        if (field) {
		            field.readOnly = !editable; // 읽기 전용 여부 설정
		            field.disabled = !editable; // 활성화/비활성화 설정
		            field.style.color = editable ? "" : "gray"; // 색상 설정
		        }
		    });
	
		    // 주소 검색 버튼 활성화/비활성화
		    const addressButton = document.getElementById("searchAddressButton");
		    if (addressButton) {
		        addressButton.style.display = editable ? "inline" : "none";
		    }
	
		    // 새로 입력 선택 시 필드 초기화
		    const selectedDeliveryPlace = document.querySelector(
		        'input[name="delivery_place"]:checked'
		    ).value;
	
		    if (editable && selectedDeliveryPlace === "새로입력") {
		        fields.forEach((id) => {
		            const field = document.getElementById(id);
		            if (field) {
		                if (field.tagName === "SELECT") {
		                    field.selectedIndex = 0; // 첫 번째 옵션 선택
		                } else {
		                    field.value = ""; // 텍스트 초기화
		                }
		            }
		        });
		    } else if (!editable) {
		        restore_all(); // 기본 배송지 값 복원
		    }
		}
	
		//==========
		// 배송지 선택에서 기본 배송지를 선택했을 때 기존 값 세팅
		function restore_all() {
		    const mapping = {
		        receiver_name: "h_receiver_name",
		        hp1: "h_hp1",
		        hp2: "h_hp2",
		        hp3: "h_hp3",
		        zipcode: "h_zipcode",
		        roadAddress: "h_roadAddress",
		        jibunAddress: "h_jibunAddress",
		        namujiAddress: "h_namujiAddress",
		    };
	
		    Object.entries(mapping).forEach(([fieldId, hiddenFieldId]) => {
		        const field = document.getElementById(fieldId);
		        const hiddenField = document.getElementById(hiddenFieldId);
	
		        if (field && hiddenField) {
		            field.value = hiddenField.value; // 히든 필드의 값 복원
		        }
		    });
	
		    // 모든 필드를 읽기 전용 및 비활성화 상태로 설정
		    const fields = Object.keys(mapping);
		    fields.forEach((id) => {
		        const field = document.getElementById(id);
		        if (field) {
		            field.readOnly = true;
		            field.disabled = true;
		            field.style.color = "gray";
		        }
		    });
	
		    // 주소 검색 버튼 숨기기
		    const addressButton = document.getElementById("searchAddressButton");
		    if (addressButton) {
		        addressButton.style.display = "none";
		    }
		}
	</script>
</head>
<body>
	<H1>1.주문확인</H1>
	<form name="form_order">
		<table class="list_view">
			<tbody align=center>
				<tr style="background: #33ff00">
					<td colspan=2 class="fixed">주문상품</td>
					<td>수량</td>
					<td>정가</td>
					<td>주문금액</td>
					<td>배송비</td>
					<!-- <td>예상적립금</td> -->
					<td>주문금액합계</td>
				</tr>

				<%-- 			${ fn:length(sessionScope.myOrderList) } <br><br><br> --%>

				<%-- session영역에   (OrderVO객체(주문 정보)가 저장된  ArrayList배열) 크기 만큼 반복 !!
	   	   참고. 장바구니에 상품을 담지 않고 로그인 후 바로 구매하기를 누르면 ArrayList배열에 저장된  OrderVO객체(주문상품정보)는 1개 이다.
	    --%>
				<c:forEach var="item" items="${sessionScope.myOrderList}">
					<tr>
						<td class="goods_image" colspan="2">
							<%-- 주문 상품 이미지를 클릭하면 주문하는 상품 번호를 전달하여  상세화면을 요청 합니다.  --%> <a
							href="${contextPath}/goods/goodsDetail.do?goods_id=${item.goods_id }">

								<%--주문 상품 이미지 표시--%> 
								<img width="75" alt="" src="${contextPath}/thumbnails.do?goods_id=${item.goods_id}&fileName=${item.goods_fileName}">

								<%-- 나중에  결제하기를 눌렀을때 요청하는 값들 (주문 한 상품 번호 , 주문 한 상품 이미지명, 주문 상품명, 주문 수량, 주문금액 합계)  --%>
								<input type="hidden" id="h_goods_id" name="h_goods_id" value="${item.goods_id }" /> 
								<input type="hidden" id="h_goods_fileName" name="h_goods_fileName" value="${item.goods_fileName }" /> 
								<input type="hidden" id="h_goods_title" name="h_goods_title" value="${item.goods_title }" /> 
								<input type="hidden" id="h_order_goods_qty" name="h_order_goods_qty" value="${item.order_goods_qty}" /> 
								<input type="hidden" id="h_each_goods_price" name="h_each_goods_price" value="${item.goods_sales_price * item.order_goods_qty}" />
						</a>

						</td>
						<%-- 수량  --%>
						<td>
							<h2>${item.order_goods_qty }개<h2>
							<%-- <input type="hidden" id="h_order_goods_qty" name="h_order_goods_qty" value="${item.order_goods_qty}" /> --%>
						</td>

						<%-- 정가 --%>
						<td class="price"><span>${item.goods_price}원</span></td>
						
						<%-- 주문금액 --%>
						<td><h2>${item.goods_sales_price}원(10% 할인)</h2></td>

						<%-- 배송비 --%>
						<td><h2>0원</h2></td>

						<%-- 예상적립금 --%>
						<%-- <td><h2>${1500 *item.order_goods_qty}원</h2></td> --%>

						<%-- 주문금액 합계 --%>
						<td>
							<h2>${item.goods_sales_price * item.order_goods_qty}원</h2> 
							<%-- <input  type="hidden" id="h_each_goods_price"  name="h_each_goods_price" value="${item.goods_sales_price * item.order_goods_qty}" /> --%>
						</td>
					</tr>
					<%-- 최종 결제 금액 ( 주문 금액 합계 금액을 누적) --%>
					<c:set var="final_total_order_price"
						value="${final_total_order_price+ item.goods_sales_price* item.order_goods_qty}" />

					<%-- 총주문 금액 ( 주문 수량 누적 ) --%>
					<c:set var="total_order_price"
						value="${total_order_price+ item.goods_sales_price* item.order_goods_qty}" />

					<%--  총 상품 수 ( 주문 수 누적 )--%>
					<c:set var="total_order_goods_qty"
						value="${total_order_goods_qty+item.order_goods_qty }" />
				</c:forEach>
			</tbody>
		</table>
		<div class="clear"></div>

		<br> <br>
		<H1>2.배송지 정보</H1>
		<DIV class="detail_table">

			<table>
				<tbody>
					<tr class="dot_line">
					    <td class="fixed_join">배송방법</td>
					    <td>
					        <input type="radio" id="delivery_method" name="delivery_method" value="일반택배" checked>일반택배 &nbsp;&nbsp;&nbsp;
					        <!--
					        <input type="radio" id="delivery_method" name="delivery_method" value="편의점택배">편의점택배 &nbsp;&nbsp;&nbsp;
					        <input type="radio" id="delivery_method" name="delivery_method" value="해외배송">해외배송 &nbsp;&nbsp;&nbsp;
					        -->
					    </td>
					</tr>
					<tr class="dot_line">
					    <td class="fixed_join">배송지 선택</td>
					    <td>
					        <input type="radio" name="delivery_place" onClick="setAddressEditable(false)" value="기본배송지" checked>기본배송지 &nbsp;&nbsp;&nbsp; 
					        <input type="radio" name="delivery_place" onClick="setAddressEditable(true)" value="새로입력">새로입력 &nbsp;&nbsp;&nbsp; 
					        <!-- <input type="radio" name="delivery_place" onClick="setAddressEditable(true)" value="최근배송지">최근배송지 &nbsp;&nbsp;&nbsp; -->
					    </td>
					</tr>
					<tr class="dot_line">
					    <td class="fixed_join">받으실 분</td>
					    <td>
					        <input id="receiver_name" name="receiver_name" type="text" size="40" value="${orderer.member_name }" readonly style="color: gray;"> 
					        <input type="hidden" id="h_orderer_name" name="h_orderer_name" value="${orderer.member_name }" /> 
					        <input type="hidden" id="h_receiver_name" name="h_receiver_name" value="${orderer.member_name }" />
					    </td>
					</tr>
					<tr class="dot_line">
					    <td class="fixed_join">휴대폰번호</td>
					    <td>
					        <select id="hp1" name="hp1" disabled style="color: gray;">
					            <option>없음</option>
					            <option value="010" selected>010</option>
					            <option value="011">011</option>
					            <option value="016">016</option>
					            <option value="017">017</option>
					            <option value="018">018</option>
					            <option value="019">019</option>
					        </select> 
					        - <input size="10px" type="text" id="hp2" name="hp2" value="${orderer.hp2 }" readonly style="color: gray;"> 
					        - <input size="10px" type="text" id="hp3" name="hp3" value="${orderer.hp3 }" readonly style="color: gray;"> 
					        
					        <input size="10px" type="hidden" id="h_hp1" name="h_hp1" value="${orderer.hp1 }" > 
					        <input size="10px" type="hidden" id="h_hp2" name="h_hp2" value="${orderer.hp2 }" >
					        <input size="10px" type="hidden" id="h_hp3" name="h_hp3" value="${orderer.hp3 }" >
					    </td>
					</tr>
					<tr class="dot_line">
					    <td class="fixed_join">주소</td>
					    <td>
					        <input type="text" id="zipcode" name="zipcode" size="10" value="${orderer.zipcode }" readonly style="color: gray;">
					        <a href="javascript:execDaumPostcode()" style="display:none;" id="searchAddressButton">우편번호검색</a> 
					        <br>
					        <p>
					            지번 주소:<br> 
					            <input type="text" id="roadAddress" name="roadAddress" size="50" value="${orderer.roadAddress }" readonly style="color: gray;"><br>
					            <br> 도로명 주소: 
					            <input type="text" id="jibunAddress" name="jibunAddress" size="50" value="${orderer.jibunAddress }" readonly style="color: gray;"><br>
					            <br> 나머지 주소: 
					            <input type="text" id="namujiAddress" name="namujiAddress" size="50" value="${orderer.namujiAddress }" readonly style="color: gray;">
					            
					            
							     <input type="hidden" id="h_zipcode" name="h_zipcode" value="${orderer.zipcode }" >
							     <input type="hidden" id="h_roadAddress" name="h_roadAddress" value="${orderer.roadAddress }" >
							     <input type="hidden" id="h_jibunAddress" name="h_jibunAddress" value="${orderer.jibunAddress }" >
							     <input type="hidden" id="h_namujiAddress" name="h_namujiAddress" value="${orderer.namujiAddress }" >
					        </p>
					    </td>
					    
					</tr>

					<tr class="dot_line">
						<td class="fixed_join">배송 메시지</td>
						<td>
							<input id="delivery_message" name="delivery_message" type="text" size="50" placeholder="택배 기사님께 전달할 메시지를 남겨주세요." />
						</td>
					</tr>
					<tr class="dot_line">
						<td class="fixed_join">선물 포장</td>
						<td>
							<input type="radio" id="gift_wrapping" name="gift_wrapping" value="yes">예 &nbsp;&nbsp;&nbsp; 
							<input type="radio" id="gift_wrapping" name="gift_wrapping" checked value="no">아니요
						</td>
					</tr>
				</tboby>
			</table>
		</div>
		<div>
			<br>
			<br>
			<h2>주문고객</h2>
			<table>
				<tbody>
					<tr class="dot_line">
						<td><h2>이름</h2></td>
						<td><input type="text" id="order_name" value="${orderer.member_name}" size="15" /></td>
					</tr>
					<tr class="dot_line">
						<td><h2>핸드폰</h2></td>
						<td><input type="text" id="order_phone" value="${orderer.hp1}-${orderer.hp2}-${orderer.hp3}" size="15" />
						</td>
					</tr>
					<tr class="dot_line">
						<td><h2>이메일</h2></td>
						<td><input type="text" id="order_email" value="${orderer.email1}@${orderer.email2}" size="15" /></td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="clear"></div>
		<br>
		
		<table width=80% class="list_view" style="background: #ccffff">
			<tbody>
				<tr align=center class="fixed">
					<td class="fixed">총 상품수</td>
					<td>총 상품금액</td>
					<td></td>
					<td>총 배송비</td>
					<td></td>
					<td>총 할인 금액</td>
					<td></td>
					<td>최종 결제금액</td>
				</tr>
				<tr cellpadding=40 align=center>
					<td id="">
						<p id="p_totalNum">${total_order_goods_qty}개</p> 
						<input id="h_total_order_goods_qty" type="hidden" value="${total_order_goods_qty}" />
					</td>
					<td>
						<p id="p_totalPrice">${total_order_price}원</p> 
						<input id="h_totalPrice" type="hidden" value="${total_order_price}" />
					</td>
					<td>
						<img width="25" alt="" src="${pageContext.request.contextPath}/resources/image/plus.jpg"></td>
					<td>
						<p id="p_totalDelivery">${goods_delivery_price }원</p> 
						<input id="h_totalDelivery" type="hidden" value="${goods_delivery_price}" />
					</td>
					<td>
						<img width="25" alt="" src="${pageContext.request.contextPath}/resources/image/minus.jpg"></td>
					<td>
						<p id="p_totalSalesPrice">${total_discount_price }원</p> 
						<input id="h_total_sales_price" type="hidden" value="${total_discount_price}" />
					</td>
					<td>
						<img width="25" alt="" src="${pageContext.request.contextPath}/resources/image/equal.jpg"></td>
					<td>
						<p id="p_final_totalPrice">
							<font size="12">${final_total_order_price}원 </font>
						</p> 
						<input id="h_final_total_Price" type="hidden" value="${final_total_order_price}" />
					</td>
				</tr>
			</tbody>
		</table>
		<div class="clear"></div>
		<br> <br> <br>
	</form>
		<%-- 결제하기  --%>
		<button onclick="requestPay()">결제하기</button>

		<%-- 쇼핑 계속 하기 --%>
		<a href="${contextPath}/main/main.do"> <img width="75" alt="" src="${contextPath}/resources/image/btn_shoping_continue.jpg"></a>
		
</body>
</html>
		
