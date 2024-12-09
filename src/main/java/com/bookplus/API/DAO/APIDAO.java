package com.bookplus.API.DAO;

import com.bookplus.API.weather.vo.APIweatherVO;
import java.util.List;

public interface APIDAO {

    // Method to fetch weather data from the database or API
    List<APIweatherVO> fetchWeatherData(String type, String baseDate, String baseTime, int nx, int ny);
}
