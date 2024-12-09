package com.bookplus.API.service;

import com.bookplus.API.weather.vo.APIweatherVO;
import java.util.List;

public interface APIService {

    // Method to fetch weather data
    List<APIweatherVO> getWeatherData(String type, String baseDate, String baseTime, int nx, int ny);
}
