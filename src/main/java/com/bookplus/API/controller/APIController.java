package com.bookplus.API.controller;

import com.bookplus.API.service.APIService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping("/API/weather")
public class APIController {

    @Autowired
    private APIService APIService;

    @RequestMapping("/recommend")
    @ResponseBody
    public List<String> recommendBooks(@RequestParam String type,
                                       @RequestParam String baseDate,
                                       @RequestParam String baseTime,
                                       @RequestParam int nx,
                                       @RequestParam int ny) {
        return APIService.getRecommendedBooks(type, baseDate, baseTime, nx, ny);
    }
}
