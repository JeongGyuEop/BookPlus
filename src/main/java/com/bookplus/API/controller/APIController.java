package com.bookplus.API.controller;

import com.bookplus.API.service.APIService;
import com.bookplus.API.weather.vo.APIweatherVO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/API/weather")
public class APIController {

    @Autowired
    private APIService APIService;

    @RequestMapping("/recommendBooks")
    public String recommendBooks(@RequestBody APIweatherVO APIweatherVO, Model model) {
    	// WeatherRequest는 요청 데이터를 매핑할 VO 클래스입니다.
        String type = APIweatherVO.getType();
        String baseDate = APIweatherVO.getBaseDate();
        String baseTime = APIweatherVO.getBaseTime();
        int nx = APIweatherVO.getNx();
        int ny = APIweatherVO.getNy();
        // 서비스에서 책 리스트 가져오기
        List<String> recommendedBooks = APIService.getRecommendBooks(type, baseDate, baseTime, nx, ny);

        // JSP에 전달할 데이터를 Model 객체에 추가
        model.addAttribute("bookList", recommendedBooks);

        // 결과를 보여줄 JSP 파일 이름 반환
        return "weatherResult";
    }
}
