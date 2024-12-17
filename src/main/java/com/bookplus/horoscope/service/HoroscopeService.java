package com.bookplus.horoscope.service;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.Map;

@Service
public class HoroscopeService {

    // API URL 및 API 키 설정
    private final String API_URL = "https://horoscope-astrology.p.rapidapi.com/daily"; // 운세 API의 URL
    private final String API_KEY = "9c5819e8a9msh27cec47277983a8p15ee97jsn0f8fb0fd3a60"; // RapidAPI에서 제공받은 API 키

    // 주어진 별자리에 대한 일일 운세 정보를 가져오는 메서드
    public String getDailyHoroscope(String sign) {
        
        RestTemplate restTemplate = new RestTemplate();  // RestTemplate 객체 생성 (API 요청을 보내는 데 사용)

        // API 요청 헤더 설정
        HttpHeaders headers = new HttpHeaders();  // HTTP 요청에 포함할 헤더를 설정할 객체 생성
        headers.set("X-RapidAPI-Key", API_KEY);  // RapidAPI에서 제공된 API 키를 헤더에 설정
        headers.set("X-RapidAPI-Host", "horoscope-astrology.p.rapidapi.com" );  // API 요청을 보낼 호스트를 설정

        // 헤더를 포함한 요청 엔티티 생성
        HttpEntity<Void> entity = new HttpEntity<>(headers);  // 헤더만 포함된 빈 요청 엔티티 생성

        try {
            // API 요청을 보내는 코드
            ResponseEntity<Map> response = restTemplate.exchange(
                    API_URL + "?sign=" + sign.toLowerCase(), // URL에 별자리 파라미터를 추가하여 요청
                    HttpMethod.GET,  // GET 메서드를 사용하여 요청
                    entity,  // 위에서 설정한 헤더를 포함한 엔티티를 요청에 사용
                    Map.class  // 응답을 받을 객체 타입으로 Map을 지정 (JSON 응답을 Map으로 변환)
            );

            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {  
                Map<String, Object> body = response.getBody();  
                return (String) body.get("horoscope");  // "horoscope" 키로 운세 데이터 반환
            } else {  
                return "운세를 가져오는 데 실패했습니다. 응답 코드: " + response.getStatusCode();  
            }  
        } catch (Exception e) {  
            return "운세를 가져오는 중 오류가 발생했습니다: " + e.getMessage();  
        }  
    }
    
}