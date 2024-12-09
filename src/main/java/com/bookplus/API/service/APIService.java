package com.bookplus.API.service;

import java.util.List;

public interface APIService {
    List<String> getRecommendedBooks(String type, String baseDate, String baseTime, int nx, int ny);
}
