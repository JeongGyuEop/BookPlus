package com.bookplus.API.service;

import com.bookplus.API.DAO.APIDAO;
import com.bookplus.API.weather.vo.APIweatherVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.List;

@Service
public class APIServiceImpl implements APIService {

    @Autowired
    private APIDAO APIDAO;

    @Override
    public List<String> getRecommendBooks(String type, String baseDate, String baseTime, int nx, int ny) {
        // 1. 날씨 데이터 가져오기
        APIweatherVO weather = getWeatherData(type, baseDate, baseTime, nx, ny);

        // 2. 날씨 데이터에서 태그 생성
        String tag = mapWeatherToTag(weather);

        // 3. DAO를 통해 책 조회
        return APIDAO.getBooksByTag(tag);
    }

    private APIweatherVO getWeatherData(String type, String baseDate, String baseTime, int nx, int ny) {
        String url = "https://apihub.kma.go.kr/api/typ02/openApi/VilageFcstInfoService_2.0/"	+ type
        															+ "getFcstVersion?authKey="	+ "Ke2_jY0YQoetv42NGIKHDQ"
        															+ "&numOfRows="				+ "10"
        															+ "&pageNo="				+ "1"
        															+ "&base_date="				+ baseDate
        															+ "&base_time="				+ baseTime
        															+ "&nx="					+ nx
        															+ "&ny="					+ ny;

        // RestTemplate 호출
        RestTemplate restTemplate = new RestTemplate(); // here!!
        
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 기본값 반환
        APIweatherVO defaultWeather = new APIweatherVO();
        return defaultWeather;
    }

    private String mapWeatherToTag(APIweatherVO weather) {
        if ("SKY".equals(weather.getCategory())) {
            switch (weather.getFcstValue()) {
                case "1":
                    return "맑음";
                case "3":
                    return "구름많음";
                case "4":
                    return "흐림";
            }
        } else if ("PTY".equals(weather.getCategory())) {
            switch (weather.getFcstValue()) {
                case "1":
                    return "비";
                case "3":
                    return "눈";
            }
        }
        return "일반";
    }
}
