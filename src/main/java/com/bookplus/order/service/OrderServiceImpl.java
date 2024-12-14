package com.bookplus.order.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.annotation.Propagation;
import com.bookplus.order.dao.OrderDAO;
import com.bookplus.order.dao.PaymentDAO;
import com.bookplus.order.vo.OrderVO;
import com.bookplus.order.vo.PaymentVO;


@Service("orderService")
@Transactional(propagation=Propagation.REQUIRED)
public class OrderServiceImpl implements OrderService {
	@Autowired
	private OrderDAO orderDAO;
	
	@Autowired
	private PaymentDAO paymentDAO;
	
	public List<OrderVO> listMyOrderGoods(OrderVO orderVO) throws Exception{
		List<OrderVO> orderGoodsList;
		orderGoodsList=orderDAO.listMyOrderGoods(orderVO);
		return orderGoodsList;
	}
	//주문정보가 저장되어 있는 ArrayList배열을 매개변수로 전달 받아 
	//DB의 주문 테이블에 추가 명령 하는 메소드! 그리고 장바구니테이블에 담긴 도서상품을 주문한 경우 해당 상품을 구매후 장바구니 테이블에서 삭제 합니다. 
	public void addNewOrder(List<OrderVO> myOrderList) throws Exception{
		
		//주문상품목록을 주문테이블에 추가합니다.
		orderDAO.insertNewOrder(myOrderList);
		
		//장바구니테이블에 상품을 추가하고 주문 했을 경우  주문한 상품을 삭제 합니다. 
		orderDAO.removeGoodsFromCart(myOrderList);
	}	
	
	public OrderVO findMyOrder(String order_id) throws Exception{
		return orderDAO.findMyOrder(order_id);
	}

	@Transactional
    @Override
    public boolean processOrderAndPayment(Map<String, Object> requestData) {
        try {
            // 주문 정보 생성
            OrderVO orderVO = new OrderVO();
            orderVO.setOrderId(Integer.parseInt(requestData.get("order_id").toString()));
            orderVO.setGoodsId(Integer.parseInt(requestData.get("goods_id").toString()));
            orderVO.setGoodsTitle((String) requestData.get("goods_title"));
            orderVO.setOrderGoodsQty(Integer.parseInt(requestData.get("order_goods_qty").toString()));
            orderVO.setReceiverName((String) requestData.get("receiver_name"));
            orderVO.setReceiverHp1((String) requestData.get("receiver_hp1"));
            orderVO.setReceiverHp2((String) requestData.get("receiver_hp2"));
            orderVO.setReceiverHp3((String) requestData.get("receiver_hp3"));
            orderVO.setDeliveryAddress((String) requestData.get("delivery_address"));
            orderVO.setDeliveryMessage((String) requestData.get("delivery_message"));
            orderVO.setTotalPrice(Integer.parseInt(requestData.get("amount").toString()));
            orderVO.setPayMethod((String) requestData.get("pay_method"));
            orderVO.setPaymentStatus((String) requestData.get("status"));

            // 결제 정보 생성
            PaymentVO paymentVO = new PaymentVO();
            paymentVO.setImpUid((String) requestData.get("imp_uid"));
            paymentVO.setMerchantUid((String) requestData.get("merchant_uid"));
            paymentVO.setAmount(Integer.parseInt(requestData.get("amount").toString()));
            paymentVO.setPayMethod((String) requestData.get("pay_method"));
            paymentVO.setPaymentStatus((String) requestData.get("status"));
            paymentVO.setOrderId(orderVO.getOrderId());

            // 주문 및 결제 처리
            orderDAO.insertOrder(orderVO);
            paymentDAO.insertPayment(paymentVO);

            return true;
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("주문 및 결제 처리 중 오류 발생: " + e.getMessage());
        }
    }
	
}
