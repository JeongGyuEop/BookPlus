<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>책 추천</title>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            // 날씨 조회 및 책 리스트 요청
            fetch("/API/weather/recommend?type=getUltraSrtNcst&baseDate=20211201&baseTime=0600&nx=55&ny=127")
                .then(response => response.json())
                .then(data => {
                    if (data.recommendations) {
                        const bookList = document.getElementById("book-list");
                        bookList.innerHTML = ""; // 기존 내용 초기화
                        data.recommendations.forEach(book => {
                            const li = document.createElement("li");
                            li.textContent = book;
                            bookList.appendChild(li);
                        });
                    } else {
                        console.error("No recommendations available");
                    }
                })
                .catch(error => console.error("Error fetching data:", error));
        });
    </script>
</head>
<body>
    <h1>현재 날씨와 어울리는 책 추천</h1>
    <ul id="book-list">
        <!-- 책 리스트가 여기 표시됩니다 -->
    </ul>
</body>
</html>
