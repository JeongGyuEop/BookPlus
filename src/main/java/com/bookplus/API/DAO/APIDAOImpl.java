package com.bookplus.API.DAO;

import com.bookplus.API.weather.vo.APIweatherVO;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;

@Repository
public class APIDAOImpl implements APIDAO {

    @Override
    public List<APIweatherVO> fetchWeatherData(String type, String baseDate, String baseTime, int nx, int ny) {
        // Mock implementation for demonstration purposes
        List<APIweatherVO> weatherDataList = new ArrayList<>();

        // Example data creation
        APIweatherVO weather = new APIweatherVO();
        weather.setBaseDate(baseDate);
        weather.setBaseTime(baseTime);
        weather.setCategory(type);
        weather.setNx(nx);
        weather.setNy(ny);
        weather.setFcstDate(baseDate);
        weather.setFcstTime(baseTime);
        weather.setFcstValue("24.5"); // Example value

        weatherDataList.add(weather);
        return weatherDataList;
    }
}
