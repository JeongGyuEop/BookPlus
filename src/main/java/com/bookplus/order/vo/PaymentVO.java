package com.bookplus.order.vo;

public class PaymentVO {
    // 기본 결제 정보
    private String impUid; // 아임포트 고유 ID
    private String merchantUid; // 상점 주문 고유 번호
    private int amount; // 결제 금액
    private String payMethod; // 결제 방식
    private String status; // 결제 상태

    // 주문 관련 정보
    private String orderId; // 주문 ID
    private Long goodsId; // 상품 ID
    private String goodsTitle; // 상품 제목
    private int orderGoodsQty; // 주문 수량

    // 배송 관련 정보
    private String receiverName; // 수령인 이름
    private String receiverHp1; // 수령인 전화번호 앞자리
    private String receiverHp2; // 수령인 전화번호 중간자리
    private String receiverHp3; // 수령인 전화번호 뒷자리
    private String deliveryAddress; // 배송지 주소

    // 추가 결제 정보
    private String deliveryMessage; // 배송 메시지
    private int finalTotalPrice; // 최종 결제 금액
	public String getImpUid() {
		return impUid;
	}
	public void setImpUid(String impUid) {
		this.impUid = impUid;
	}
	public String getMerchantUid() {
		return merchantUid;
	}
	public void setMerchantUid(String merchantUid) {
		this.merchantUid = merchantUid;
	}
	public int getAmount() {
		return amount;
	}
	public void setAmount(int amount) {
		this.amount = amount;
	}
	public String getPayMethod() {
		return payMethod;
	}
	public void setPayMethod(String payMethod) {
		this.payMethod = payMethod;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getOrderId() {
		return orderId;
	}
	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}
	public Long getGoodsId() {
		return goodsId;
	}
	public void setGoodsId(Long goodsId) {
		this.goodsId = goodsId;
	}
	public String getGoodsTitle() {
		return goodsTitle;
	}
	public void setGoodsTitle(String goodsTitle) {
		this.goodsTitle = goodsTitle;
	}
	public int getOrderGoodsQty() {
		return orderGoodsQty;
	}
	public void setOrderGoodsQty(int orderGoodsQty) {
		this.orderGoodsQty = orderGoodsQty;
	}
	public String getReceiverName() {
		return receiverName;
	}
	public void setReceiverName(String receiverName) {
		this.receiverName = receiverName;
	}
	public String getReceiverHp1() {
		return receiverHp1;
	}
	public void setReceiverHp1(String receiverHp1) {
		this.receiverHp1 = receiverHp1;
	}
	public String getReceiverHp2() {
		return receiverHp2;
	}
	public void setReceiverHp2(String receiverHp2) {
		this.receiverHp2 = receiverHp2;
	}
	public String getReceiverHp3() {
		return receiverHp3;
	}
	public void setReceiverHp3(String receiverHp3) {
		this.receiverHp3 = receiverHp3;
	}
	public String getDeliveryAddress() {
		return deliveryAddress;
	}
	public void setDeliveryAddress(String deliveryAddress) {
		this.deliveryAddress = deliveryAddress;
	}
	public String getDeliveryMessage() {
		return deliveryMessage;
	}
	public void setDeliveryMessage(String deliveryMessage) {
		this.deliveryMessage = deliveryMessage;
	}
	public int getFinalTotalPrice() {
		return finalTotalPrice;
	}
	public void setFinalTotalPrice(int finalTotalPrice) {
		this.finalTotalPrice = finalTotalPrice;
	}

}

