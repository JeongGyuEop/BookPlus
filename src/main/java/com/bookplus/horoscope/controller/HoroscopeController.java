package com.bookplus.horoscope.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bookplus.horoscope.service.HoroscopeService;

@Controller
@RequestMapping("/horoscope")  // "/horoscope" 경로로 들어오는 요청을 이 컨트롤러가 처리하도록 지정합니다.
public class HoroscopeController {

    @Autowired
    private HoroscopeService horoscopeService;

    @RequestMapping(value = "/view.do", method = RequestMethod.GET)
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
