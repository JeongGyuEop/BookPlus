package com.bookplus.API.service;

import java.util.List;

public interface APIService {
    List<String> getRecommendBooks(String type, String baseDate, String baseTime, int nx, int ny);
}
