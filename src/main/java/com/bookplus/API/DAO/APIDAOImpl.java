package com.bookplus.API.DAO;

import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;

@Repository
public class APIDAOImpl implements APIDAO {

    @Override
    public List<String> getBooksByTag(String tag) {
        // Mock 데이터베이스 조회
        List<String> books = new ArrayList<>();
        switch (tag) {
            case "맑음":
                books.add("여행 에세이");
                books.add("긍정적인 소설");
                break;
            case "구름많음":
                books.add("심리학 책");
                books.add("자기계발서");
                break;
            case "흐림":
                books.add("미스터리");
                books.add("추리소설");
                break;
            case "비":
                books.add("감성적인 소설");
                books.add("우울한 감정 탐구");
                break;
            case "눈":
                books.add("겨울 테마 도서");
                books.add("눈 내리는 이야기");
                break;
            default:
                books.add("일반 추천 도서");
        }
        return books;
    }
}
