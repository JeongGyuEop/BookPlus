package com.bookplus.API.controller;

import com.bookplus.API.service.APIService;
import com.bookplus.API.weather.vo.APIweatherVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/API/weather")
public class APIController {

    private final APIService apiService;

    @Autowired
    public APIController(APIService apiService) {
        this.apiService = apiService;
    }

    @RequestMapping("/getWeatherData")
    public List<APIweatherVO> getWeatherData(@RequestParam("type") String type,
                                             @RequestParam("baseDate") String baseDate,
                                             @RequestParam("baseTime") String baseTime,
                                             @RequestParam("nx") int nx,
                                             @RequestParam("ny") int ny) {
        return apiService.getWeatherData(type, baseDate, baseTime, nx, ny);
    }
}
