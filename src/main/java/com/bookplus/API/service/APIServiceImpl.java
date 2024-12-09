package com.bookplus.API.service;

import com.bookplus.API.DAO.APIDAO;
import com.bookplus.API.weather.vo.APIweatherVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.List;

@Service
public class APIServiceImpl implements APIService {

    @Autowired
    private APIDAO APIDAO;

    @Override
    public List<String> getRecommendedBooks(String type, String baseDate, String baseTime, int nx, int ny) {
        // Step 1: 날씨 데이터 가져오기
        APIweatherVO weather = getWeatherData(type, baseDate, baseTime, nx, ny);

        // Step 2: 날씨 데이터에서 태그 생성
        String tag = mapWeatherToTag(weather);

        // Step 3: DAO를 통해 책 조회
        return APIDAO.getBooksByTag(tag);
    }

    private APIweatherVO getWeatherData(String type, String baseDate, String baseTime, int nx, int ny) {
        String url = String.format(
            "https://apihub.kma.go.kr/api/typ02/openApi/VilageFcstInfoService_2.0/%s?authKey=%s&numOfRows=10&pageNo=1&base_date=%s&base_time=%s&nx=%d&ny=%d",
            type, "YOUR_API_KEY", baseDate, baseTime, nx, ny
        );

        RestTemplate restTemplate = new RestTemplate();
        // JSON/XML 데이터 파싱 로직 추가
        APIweatherVO weather = new APIweatherVO();
        weather.setCategory("SKY");  // Mock 데이터
        weather.setFcstValue("1");   // Mock 데이터
        return weather;
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
