package com.bookplus.API.service;

import com.bookplus.API.DAO.APIDAO;
import com.bookplus.API.weather.vo.APIweatherVO;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.springframework.beans.factory.annotation.Autowired;
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
        String goods_title = mapWeatherToTag(weather);

        // 3. DAO를 통해 책 조회
        return APIDAO.getBooksByTag(goods_title);
    }

    private APIweatherVO getWeatherData(String type, String baseDate, String baseTime, int nx, int ny) {
        String url = String.format(
            "https://apihub.kma.go.kr/api/typ02/openApi/VilageFcstInfoService_2.0/%s?authKey=%s&numOfRows=%s&pageNo=%s&base_date=%s&base_time=%s&nx=%d&ny=%d",
            type,
            "Ke2_jY0YQoetv42NGIKHDQ",
            "10",
            "1",
            baseDate,
            baseTime,
            nx,
            ny
        );

        RestTemplate restTemplate = new RestTemplate();
        try {
            // GET 요청을 보내고 응답 데이터 수신
            ResponseEntity<String> response = restTemplate.getForEntity(url, String.class);

            if (response.getStatusCode().is2xxSuccessful()) {
                // 응답 본문에서 JSON 데이터 파싱
                String responseBody = response.getBody();
                ObjectMapper objectMapper = new ObjectMapper();
                JsonNode rootNode = objectMapper.readTree(responseBody);

                // JSON 데이터에서 필요한 정보를 추출
                JsonNode itemsNode = rootNode.path("response").path("body").path("items").path("item");
                APIweatherVO weather = new APIweatherVO();

                for (JsonNode item : itemsNode) {
                    if ("SKY".equals(item.path("category").asText())) {
                        weather.setCategory(item.path("category").asText());
                        weather.setFcstValue(item.path("fcstValue").asText());
                        break;
                    }
                }
                return weather;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 기본값 반환
        APIweatherVO defaultWeather = new APIweatherVO();
        defaultWeather.setCategory("UNKNOWN");
        defaultWeather.setFcstValue("N/A");
        return defaultWeather;
    }


    private String mapWeatherToTag(APIweatherVO weather) {
        if ("SKY".equals(weather.getCategory())) {
            switch (weather.getFcstValue()) {
                case "1":	//맑음
                    return "희망";
                case "3":	//구름많음
                    return "회색";
                case "4":	//흐림
                    return "정체";
            }
        } else if ("PTY".equals(weather.getCategory())) {
            switch (weather.getFcstValue()) {
                case "1":	//비
                    return "추억";
                case "3":	//눈
                    return "고요";
            }
        }
        //일반
        return "일반";
    }
}
