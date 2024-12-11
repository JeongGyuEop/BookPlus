<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>오늘 날씨에 대한 추천 책</title>
<script>
    document.addEventListener("DOMContentLoaded", function () {
        const button = document.getElementById("recommend-button");
        const resultContainer = document.getElementById("result-container");

        button.addEventListener("click", function () {
            // 현재 시간 정보 가져오기
            const now = new Date();
            const year = now.getFullYear();
            const month = String(now.getMonth() + 1).padStart(2, '0');
            const date = String(now.getDate()).padStart(2, '0');
            let hours = now.getHours();
            const minutes = now.getMinutes();

            // baseDate와 baseTime 생성
            let baseDate = parseInt(year + month + date); // 정수 값으로 생성
            let adjustedHours = hours;

            if (minutes <= 10) {
                adjustedHours -= 1;
                if (adjustedHours < 0) {
                    const previousDate = new Date(now);
                    previousDate.setDate(previousDate.getDate() - 1);
                    const prevYear = previousDate.getFullYear();
                    const prevMonth = String(previousDate.getMonth() + 1).padStart(2, '0');
                    const prevDate = String(previousDate.getDate()).padStart(2, '0');
                    baseDate = parseInt(prevYear + prevMonth + prevDate); // 정수 값으로 재계산
                    adjustedHours = 23;
                }
            }

            const baseTime = parseInt(String(adjustedHours).padStart(2, '0') + "00"); // 정수 값으로 생성

            // JSON 요청 데이터
            const requestData = {
                type: "getUltraSrtFcst", // API 유형
                dataType: "JSON",
                baseDate: baseDate, // 정수 형태의 날짜
                baseTime: baseTime, // 정수 형태의 시간
                nx: 60, // X 좌표
                ny: 127 // Y 좌표
            };

            // AJAX 요청
            fetch("recommendBooks", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(requestData)
            })
            .then(function(response) {
                return response.json();
            })
            .then(function(data) {
                const bookListDiv = document.getElementById("bookList");
                bookListDiv.innerHTML = ""; // 기존 내용을 초기화

                if (data.error) {
                    alert(data.error);
                } else if (data.message) {
                    bookListDiv.innerHTML = "<p>" + data.message + "</p>";
                } else if (data.books) {
                    let booksHtml = "";
                    data.books.forEach(function(book) {
                        booksHtml += "<li>" + book + "</li>";
                    });
                    bookListDiv.innerHTML = "<ul>" + booksHtml + "</ul>";
                }
            })
            .catch(function(error) {
                alert("데이터 요청 중 문제가 발생했습니다. 잠시 후 다시 시도하세요.");
            });
        });
    });
</script>
</head>
<body>
    <h1>오늘 날씨와 꼭 맞는 책 추천</h1>
    <button id="recommend-button">추천 책 보기</button>
    <div id="result-container" style="margin-top: 20px; color: red;"></div>
    <div id="bookList" style="margin-top: 20px;"></div>
</body>
</html>
