<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>추천 책 결과</title>
</head>
<body>
    <h1>오늘 날씨에 따른 추천 책</h1>
    <ul>
        <!-- bookList를 반복하여 출력 -->
        <c:forEach var="book" items="${bookList}">
            <li>${book}</li>
        </c:forEach>
    </ul>
    <a href="weatherInput.jsp">다시 추천받기</a>
</body>
</html>
