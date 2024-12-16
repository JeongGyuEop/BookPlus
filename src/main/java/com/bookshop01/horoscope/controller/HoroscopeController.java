package com.bookshop01.horoscope.controller;

import org.springframework.beans.factory.annotation.Autowired;  // 스프링에서 의존성 주입(DI)을 사용할 때 사용하는 어노테이션입니다.
import org.springframework.stereotype.Controller;  // 이 클래스가 웹 요청을 처리하는 컨트롤러임을 나타내는 어노테이션입니다.
import org.springframework.web.bind.annotation.GetMapping;  // HTTP GET 요청을 처리하는 메서드를 정의하는 어노테이션입니다.
import org.springframework.web.bind.annotation.RequestMapping;  // 해당 클래스 또는 메서드가 처리할 요청 URL을 매핑하는 어노테이션입니다.
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


import com.bookshop01.horoscope.service.HoroscopeService;  // URL 쿼리 파라미터를 메서드 파라미터로 바인딩하는 어노테이션입니다.

  // HoroscopeService 클래스를 사용하여 실제 운세 데이터를 가져오는 서비스 클래스입니다.

	@Controller  // 이 클래스가 웹 요청을 처리하는 컨트롤러임을 나타냅니다.
	@RequestMapping("/horoscope")  // "/horoscope" 경로로 들어오는 요청을 이 컨트롤러가 처리하도록 지정합니다.
	public class HoroscopeController { 

	    @Autowired  // 스프링이 HoroscopeService 객체를 자동으로 주입해주도록 합니다.
	    private HoroscopeService horoscopeService;  // HoroscopeService 객체를 선언합니다. 이 객체는 실제 운세 데이터를 가져오는 역할을 합니다.

	    
	    @GetMapping("/view.do")
	    @ResponseBody  // 응답 데이터를 직접 반환 (뷰 이름이 아닌 데이터만 반환)
	    public String viewHoroscope(@RequestParam String sign) {
	        try {
	            // 서비스에서 운세 데이터를 가져오기
	            String horoscope = horoscopeService.getDailyHoroscope(sign);
	            
	            // 가져온 운세 데이터를 반환
	            return horoscope;
	        } catch (Exception e) {
	            // 오류 발생 시 에러 메시지 반환
	            return "운세를 가져오는 중 오류가 발생했습니다.";
	        }
	    }
}