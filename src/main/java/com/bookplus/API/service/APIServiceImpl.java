package com.bookplus.API.service;

import com.bookplus.API.weather.vo.APIweatherVO;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class APIServiceImpl implements APIService {

    @Override
    public List<APIweatherVO> getWeatherData(String type, String baseDate, String baseTime, int nx, int ny) {
        // Mock data for demonstration purposes
        List<APIweatherVO> weatherDataList = new ArrayList<>();

        // Example data based on input parameters
        APIweatherVO weather = new APIweatherVO();
        weather.setBaseDate(baseDate);
        weather.setBaseTime(baseTime);
        weather.setCategory(type);
        weather.setNx(nx);
        weather.setNy(ny);
        weather.setFcstDate(baseDate);
        weather.setFcstTime(baseTime);
        weather.setFcstValue("25.0"); // Example value

        weatherDataList.add(weather);
        return weatherDataList;
    }
}
