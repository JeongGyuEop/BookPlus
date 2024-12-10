package com.bookplus.API.controller;

import com.bookplus.API.service.APIService;
import com.bookplus.API.weather.vo.APIweatherVO;

import org.springframework.beans.factory.annotation.Autowired;
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
    public List<String> recommendBooks(@RequestBody APIweatherVO APIweatherVO) {
        // 요청 데이터를 Service 레이어로 전달
        return APIService.getRecommendBooks(
        		APIweatherVO.getType(),
        		APIweatherVO.getBaseDate(),
        		APIweatherVO.getBaseTime(),
        		APIweatherVO.getNx(),
        		APIweatherVO.getNy()
        );
    }
}
