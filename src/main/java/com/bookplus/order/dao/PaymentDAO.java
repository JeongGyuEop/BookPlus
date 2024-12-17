package com.bookplus.order.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.bookplus.order.vo.PaymentVO;

import org.apache.ibatis.session.SqlSession;

@Repository
public class PaymentDAO {
	
	@Autowired
    private SqlSession sqlSession;

    public void insertPayment(PaymentVO paymentVO) {
        sqlSession.insert("mapper.payment.insertPayment", paymentVO);
    }

}