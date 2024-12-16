package com.bookplus.order.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.bookplus.common.base.BaseController;
import com.bookplus.goods.vo.GoodsVO;
import com.bookplus.member.vo.MemberVO;
import com.bookplus.order.service.OrderService;
import com.bookplus.order.vo.OrderVO;

/*
   변경 사항 요약:
   - GoodsVO 변경	:	goods_id → goods_isbn, 
   					goods_sales_price → goods_priceSales,
   					goods_fileName → goods_cover
   - 즉, GoodsVO의 key로 사용되던 goods_id가 이제 goods_isbn(String)으로 대체됨.
   - 문자열 비교를 사용해야 하므로 equals()를 활용.
*/

@Controller("orderController")
@RequestMapping(value="/order")
public class OrderControllerImpl extends BaseController implements OrderController {
	@Autowired
	private OrderService orderService;
	@Autowired
	private OrderVO orderVO;
	
	
	@RequestMapping(value="/orderEachGoods.do" ,method = RequestMethod.POST)
	public ModelAndView orderEachGoods(@ModelAttribute("orderVO") OrderVO _orderVO,
			                           HttpServletRequest request, 
			                           HttpServletResponse response)  throws Exception{
		
		request.setCharacterEncoding("utf-8");
		HttpSession session=request.getSession();
		session=request.getSession();
		
		Boolean isLogOn=(Boolean)session.getAttribute("isLogOn"); 
		String action=(String)session.getAttribute("action");
	
		if(isLogOn==null || isLogOn==false){
			session.setAttribute("orderInfo", _orderVO);
			session.setAttribute("action", "/order/orderEachGoods.do");
			return new ModelAndView("redirect:/member/loginForm.do");
		}else{
			 if(action!=null && action.equals("/order/orderEachGoods.do")){
				 orderVO=(OrderVO)session.getAttribute("orderInfo"); 
				 session.removeAttribute("action"); 
			 }else {
				 orderVO=_orderVO;
			 }
		 }
		
		String viewName=(String)request.getAttribute("viewName"); 
		ModelAndView mav = new ModelAndView(viewName);
		
		List myOrderList=new ArrayList<OrderVO>();
		myOrderList.add(orderVO);

		MemberVO memberInfo=(MemberVO)session.getAttribute("memberInfo");
		
		session.setAttribute("myOrderList", myOrderList); 
		session.setAttribute("orderer", memberInfo); 
		return mav;
	}
	
	
	@RequestMapping(value="/orderAllCartGoods.do" ,method = RequestMethod.POST)
	public ModelAndView orderAllCartGoods(@RequestParam("cart_goods_qty")  String[] cart_goods_qty,
										  HttpServletRequest request, HttpServletResponse response)  throws Exception{
		
		String viewName=(String)request.getAttribute("viewName"); 
		ModelAndView mav = new ModelAndView(viewName);
		
		HttpSession session=request.getSession();
		Map cartMap=(Map)session.getAttribute("cartMap");
		List<GoodsVO> myGoodsList=(List<GoodsVO>)cartMap.get("myGoodsList");
		
		List myOrderList=new ArrayList<OrderVO>();
				
		MemberVO memberVO=(MemberVO)session.getAttribute("memberInfo");
		
		for(int i=0; i<cart_goods_qty.length;i++){
			String[] cart_goods=cart_goods_qty[i].split(":");
			
			for(int j = 0; j< myGoodsList.size();j++) {
				GoodsVO goodsVO = myGoodsList.get(j);
				
				// 변경 전: int getGoods_id = goodsVO.getGoods_id();
				// 변경 후: String goods_isbn = goodsVO.getGoods_isbn();
				String goods_isbn = goodsVO.getGoods_isbn();

				// 변경 전 조건문:
				// if(goods_id==Integer.parseInt(cart_goods[0])) {
				//
				// 변경 후: goods_isbn과 cart_goods[0]을 문자열로 비교
				if(goods_isbn.equals(cart_goods[0])) {
					OrderVO _orderVO=new OrderVO();
					String goods_title=goodsVO.getGoods_title();
					
					// 변경 전: int goods_sales_price=goodsVO.getGoods_sales_price();
					// 변경 후: int goods_priceSales=goodsVO.getGoods_priceSales();
					int goods_priceSales=goodsVO.getGoods_priceSales();
					
					// 변경 전: String goods_fileName=goodsVO.getGoods_fileName();
					// 변경 후: String goods_cover=goodsVO.getGoods_cover();
					String goods_cover=goodsVO.getGoods_cover();
					
					// 변경 전: _orderVO.setGoods_id(goods_id);
					// 변경 후: _orderVO.setGoods_isbn(goods_isbn);
					_orderVO.setGoods_isbn(goods_isbn);
					_orderVO.setGoods_title(goods_title);
					
					// 변경 전: _orderVO.setGoods_sales_price(goods_sales_price);
					// 변경 후: _orderVO.setGoods_priceSales(goods_priceSales);
					_orderVO.setGoods_priceSales(goods_priceSales);
					
					// 변경 전: _orderVO.setGoods_fileName(goods_fileName);
					// 변경 후: _orderVO.setGoods_cover(goods_cover);
					_orderVO.setGoods_cover(goods_cover);
					
					_orderVO.setOrder_goods_qty(Integer.parseInt(cart_goods[1]));
					myOrderList.add(_orderVO);
					break;
				}
			}
		}
		
		session.setAttribute("myOrderList", myOrderList);
		session.setAttribute("orderer", memberVO);
		return mav;
	}	
	
	
	@RequestMapping(value="/payToOrderGoods.do" ,method = RequestMethod.POST)
	public ModelAndView payToOrderGoods(@RequestParam Map<String, String> receiverMap,
			                            HttpServletRequest request, HttpServletResponse response)  throws Exception{
		
		String viewName=(String)request.getAttribute("viewName");  
		ModelAndView mav = new ModelAndView(viewName);
		
		HttpSession session=request.getSession();
		MemberVO memberVO=(MemberVO)session.getAttribute("orderer");
		String member_id=memberVO.getMember_id();
		String orderer_name=memberVO.getMember_name();
		String orderer_hp = memberVO.getHp1()+"-"+memberVO.getHp2()+"-"+memberVO.getHp3();
		
		List<OrderVO> myOrderList=(List<OrderVO>)session.getAttribute("myOrderList");
		
		for(int i=0; i<myOrderList.size();i++){
			OrderVO orderVO=(OrderVO)myOrderList.get(i);
			orderVO.setMember_id(member_id);
			orderVO.setOrderer_name(orderer_name);
			orderVO.setReceiver_name(receiverMap.get("receiver_name"));
			
			orderVO.setReceiver_hp1(receiverMap.get("receiver_hp1"));
			orderVO.setReceiver_hp2(receiverMap.get("receiver_hp2"));
			orderVO.setReceiver_hp3(receiverMap.get("receiver_hp3"));
			orderVO.setReceiver_tel1(receiverMap.get("receiver_tel1"));
			orderVO.setReceiver_tel2(receiverMap.get("receiver_tel2"));
			orderVO.setReceiver_tel3(receiverMap.get("receiver_tel3"));
			
			orderVO.setDelivery_address(receiverMap.get("delivery_address"));
			orderVO.setDelivery_message(receiverMap.get("delivery_message"));
			orderVO.setDelivery_method(receiverMap.get("delivery_method"));
			orderVO.setGift_wrapping(receiverMap.get("gift_wrapping"));
			orderVO.setPay_method(receiverMap.get("pay_method"));
			orderVO.setCard_com_name(receiverMap.get("card_com_name"));
			orderVO.setCard_pay_month(receiverMap.get("card_pay_month"));
			orderVO.setPay_orderer_hp_num(receiverMap.get("pay_orderer_hp_num"));	
			orderVO.setOrderer_hp(orderer_hp);	
			myOrderList.set(i, orderVO);
		}
		
	    orderService.addNewOrder(myOrderList);
	    
		mav.addObject("myOrderInfo",receiverMap);
		mav.addObject("myOrderList", myOrderList);
		
		return mav;
	}
	
}

