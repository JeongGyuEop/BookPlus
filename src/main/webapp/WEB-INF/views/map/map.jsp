<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>simpleMap</title>
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script src="https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=3yUCZPlQLSXrUVYnaBC07pB2LIkjQD43OUfAR85i"></script>
<script type="text/javascript">
    var map;
    var totalMarkerArr = [];

    function initTmap() {
        // 현위치 받아오기
        navigator.geolocation.getCurrentPosition(
            function (position) {
                var userLat = position.coords.latitude; // 사용자 위도
                var userLng = position.coords.longitude; // 사용자 경도
    	
        // 지도 띄우기
        map = new Tmapv2.Map("map_div", {
            center: new Tmapv2.LatLng(userLat, userLng), // 초기 중심 좌표
            width: "100%",
            height: "400px",
            zoom: 18,
            zoomControl: true,
            scrollwheel: true
        });

    

                // 사용자 현위치 마커 추가
                var marker_s = new Tmapv2.Marker({
                    position: new Tmapv2.LatLng(userLat, userLng), // 현재 위치
                    icon: "https://maps.google.com/mapfiles/ms/icons/green-dot.png",
                    iconSize: new Tmapv2.Size(24, 38),
                    map: map
                });

                // 지도 중심을 사용자 위치로 이동
                map.setCenter(new Tmapv2.LatLng(userLat, userLng));

                // 검색 버튼 클릭 이벤트에 현위치 좌표 전달
                $("#searchButton").data("lat", userLat);
                $("#searchButton").data("lng", userLng);
            },
            function (error) {
                console.error("현위치를 가져올 수 없습니다.", error);
                alert("현위치를 가져오는 데 실패했습니다. 위치 서비스를 활성화하세요.");
            }
        );
    }

    // Kakao REST API를 사용한 주소 검색
    function searchAddress() {
        var query = $("#keyword").val(); // 입력된 키워드 가져오기
        var userLat = $("#searchButton").data("lat"); // 현위치 위도
        var userLng = $("#searchButton").data("lng"); // 현위치 경도

        if (!query) {
            alert("검색어를 입력하세요!");
            return;
        }

        if (!userLat || !userLng) {
            alert("현위치를 가져오지 못했습니다. 위치 서비스를 확인하세요.");
            return;
        }

        $.ajax({
            method: "GET",
            url: "https://dapi.kakao.com/v2/local/search/keyword.json",
            headers: {
                Authorization: "KakaoAK c0560692570618117086f9a23465fb75" // REST API 키
            },
            data: {
                query: query,
                x: userLng, // 현위치 경도
                y: userLat, // 현위치 위도
                radius: 5000 // 검색 반경 (미터, 최대 20,000)
            },
            success: function (response) {
                // 필요한 데이터만 저장할 배열 선언
                var filteredResults = [];

                // documents 배열을 반복하면서 필요한 데이터만 추출
                response.documents.forEach(function (item) {
                    filteredResults.push({
                        place_name: item.place_name,            // 장소 이름
                        place_url: item.place_url,              // 장소 상세 URL
                        road_address_name: item.road_address_name, // 도로명 주소
                        x: item.x,                              // 경도
                        y: item.y                               // 위도
                    });
                });

                // 저장된 결과를 확인 (Console 출력)
                console.log("필터링된 결과:", filteredResults);

                // 이후 필요한 로직에 사용 가능
                displaySearchResults(filteredResults);
            },
            error: function (error) {
                console.error("Kakao API 요청 실패", error);
                alert("주소 검색에 실패했습니다.");
            }
        });
    }

    // 검색 결과를 지도에 표시
    function displaySearchResults(results) {
        // 기존 마커 초기화
        totalMarkerArr.forEach(function (marker) {
            marker.setMap(null);
        });
        totalMarkerArr = [];

        results.forEach(function (result, index) {
            // 검색 결과 마커 추가
            var marker = new Tmapv2.Marker({
                position: new Tmapv2.LatLng(result.y, result.x), // 검색 결과의 위도와 경도
                icon: "https://cdn-icons-png.flaticon.com/512/684/684908.png",
                iconSize: new Tmapv2.Size(24, 38),
                map: map
            });

            totalMarkerArr.push(marker);

            // 마커 클릭 시 선택 처리
            marker.addListener("click", function () {
                // 선택한 위치 정보 input 태그에 표시
                $("#selectedPlace").val(result.place_name + " (" + result.road_address_name + ")");

                // 선택된 장소 데이터를 저장
                selectedPlaceData = {
                    place_name: result.place_name,
                    road_address_name: result.road_address_name,
                    place_url: result.place_url,
                    x: result.x,
                    y: result.y
                    	
                };
           		});
                totalMarkerArr = [marker];

                // 지도 중심 이동
                map.setCenter(new Tmapv2.LatLng(result.y, result.x));
       		 });
       

        if (results.length === 0) {
            alert("검색 결과가 없습니다.");
        }
    }
        // 팝업 닫기 버튼 클릭 시
        function closePopup() {
            if (selectedPlaceData && window.opener) {
                // 선택된 장소 정보를 메인 페이지로 전달
                window.opener.document.getElementById("selectedPlaceInput").value =
                    selectedPlaceData.place_name + " (" + selectedPlaceData.road_address_name + ")";
                window.opener.setPlaceData(
                        selectedPlaceData.place_name,
                        selectedPlaceData.road_address_name,
                        selectedPlaceData.place_url,
                        selectedPlaceData.x,
                        selectedPlaceData.y
                    );
            }
            // 팝업 창 닫기
            window.close();
        }
        
</script>
</head>
<body onload="initTmap();">

    <div id="map_wrap" class="map_wrap3">
        <div id="map_div"></div>
    </div>
    <p id="result"></p>
    <br />

    <!-- 키워드 입력 및 검색 -->
    <input type="text" id="keyword" placeholder="검색할 주소나 장소 입력">
    <button id="searchButton" onclick="searchAddress()">검색</button>
    <br><br>

    <!-- 선택된 장소 표시 -->
    <label for="selectedPlace">약속 장소:</label>
    <input type="text" id="selectedPlace" readonly style="width: 300px;">
       <!-- 팝업 닫기 버튼 -->
    <button onclick="closePopup()">확인 후 닫기</button>
</body>
</html>
