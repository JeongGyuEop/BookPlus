<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>오늘 날씨에 대한 추천 책</title>
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const button = document.getElementById("recommend-button");

            button.addEventListener("click", function () {
                // 현재 시간 정보 가져오기
                const now = new Date();
                const year = now.getFullYear();
                const month = String(now.getMonth() + 1).padStart(2, '0');
                const date = String(now.getDate()).padStart(2, '0');
                const hours = String(now.getHours()).padStart(2, '0');
                const baseDate = `${year}${month}${date}`;
                const baseTime = `${hours}`;
                
                // 고정된 서울 경복궁 좌표
                const nx = 37.579617; // 위도
                const ny = 126.977041; // 경도

                // JSON 요청 데이터
                const requestData = {
                    type: "getUltraSrtNcst", // API 유형
                    baseDate: baseDate, // 현재 날짜
                    baseTime: baseTime, // 현재 시간
                    nx: nx, // X 좌표 (위도)
                    ny: ny // Y 좌표 (경도)
                };

                // AJAX 요청
                fetch("/API/weather/recommendBooks", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify(requestData)
                })
                .then(response => response.json())
                .then(data => {
                    console.log("Response Data:", data);
                    // 서버 응답 데이터를 처리하는 로직 추가
                })
                .catch(error => console.error("Error:", error));
            });
        });
    </script>
</head>
<body>
    <h1>오늘 날씨에 대한 추천 책</h1>
    <button id="recommend-button">추천 책 보기</button>
</body>
</html>
