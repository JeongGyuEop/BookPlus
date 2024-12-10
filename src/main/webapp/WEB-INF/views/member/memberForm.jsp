<%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"
	isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath"  value="${pageContext.request.contextPath}"  />
<!DOCTYPE html >
<html>
<head>
<meta charset="utf-8">
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
function execDaumPostcode() {
	  new daum.Postcode({
	    oncomplete: function (data) {
	      // 팝업에서 검색결과 항목을 클릭했을 때 실행할 코드를 작성하는 부분.

	      var fullRoadAddr = data.roadAddress; // 도로명 주소 변수
	      var extraRoadAddr = ''; // 도로명 조합형 주소 변수

	      // 법정동명이 있을 경우 추가 (법정리는 제외)
	      if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
	        extraRoadAddr += data.bname;
	      }
	      // 건물명이 있고 공동주택일 경우 추가
	      if (data.buildingName !== '' && data.apartment === 'Y') {
	        extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
	      }
	      // 참고 항목이 있을 경우 추가
	      if (extraRoadAddr !== '') {
	        extraRoadAddr = ' (' + extraRoadAddr + ')';
	      }
	      
	      // 주소 정보를 해당 필드에 입력
	      document.getElementById('zipcode').value = data.zonecode;
	      document.getElementById('roadAddress').value = fullRoadAddr;
	      document.getElementById('jibunAddress').value = data.jibunAddress;
	      
	      if (fullRoadAddr !== '') {
	        fullRoadAddr += extraRoadAddr;
	      }

	      // 예상 주소 표시
	      var guideElement = document.getElementById('guide');

	      if (data.autoRoadAddress) {
	        var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
	        guideElement.innerHTML = '(예상 도로명 주소 : ' + expRoadAddr + ')';
	        guideElement.style.display = 'block';
	      } else if (data.autoJibunAddress) {
	        var expJibunAddr = data.autoJibunAddress;
	        guideElement.innerHTML = '(예상 지번 주소 : ' + expJibunAddr + ')';
	        guideElement.style.display = 'block';
	      } else {
	        guideElement.innerHTML = '';
	        guideElement.style.display = 'none';
	      }
	    }
	  }).open(); // 팝업 창 열기 (기본 동작으로 닫힘)
	}


//아이디 중복 확인
function fn_overlapped(){
	
    var _id=$("#_member_id").val();
    
    if(_id==''){
   	 alert("ID를 입력하세요");
   	 return;
    }
    
    $.ajax({
       type:"post",
       async:false,  
       url:"${contextPath}/member/overlapped.do", //회원가입 시  입력한 아이디가 DB에 저장되어 있는지 중복확인 요청!
       dataType:"text",
       data: {id:_id},
       success:function (data,textStatus){
          if(data=='false'){
       	    alert("사용할 수 있는 ID입니다.");
       	    $('#btnOverlapped').prop("disabled", true);
       	    $('#_member_id').prop("disabled", true);
       	    $('#member_id').val(_id);
          }else{
        	  alert("사용할 수 없는 ID입니다.");
          }
       },
       error:function(data,textStatus){
          alert("에러가 발생했습니다.");
       },
       complete:function(data,textStatus){
          //alert("작업을완료 했습니다");
       }
    });  //end ajax	 
 }	
 
 
// 이메일 선택한 option 값을 email2Input 필드에 넣는 함수
function updateEmailDomain() {
  // select 요소와 input 요소 가져오기
  var select = document.getElementById('email2Select');
  var emailInput = document.getElementById('email2Input');

  // 선택한 옵션 값을 input 요소에 설정
  emailInput.value = select.value;
}
 
// 선택 체크박스 미 클릭시 DB 등록 가능하게 설정  
	// 제출 전에 체크박스 값 설정
		function prepareFormData() {
			const smsCheckbox = document.getElementById('smsstsCheckbox');
			const emailCheckbox = document.getElementById('emailstsCheckbox');

			// SMS 수신 동의 여부
			if (smsCheckbox.checked) {
				document.getElementById('smsHidden').disabled = true; // hidden input 비활성화
			} else {
				document.getElementById('smsHidden').disabled = false; // hidden input 활성화
			} 

			// 이메일 수신 동의 여부
			if (emailCheckbox.checked) {
				document.getElementById('emailHidden').disabled = true; // hidden input 비활성화
			} else {
				document.getElementById('emailHidden').disabled = false; // hidden input 활성화
			}
		}

</script>
</head>
<body>

<%
    JSONObject userProfile = (JSONObject) request.getAttribute("userProfile");
%>
	<h3>필수입력사항</h3>
	<form action="${contextPath}/member/addMember.do" method="post" onsubmit="prepareFormData()">
		
	<div id="detail_table">
		<table>
			<tbody>
				<tr class="dot_line">
					<td class="fixed_join">아이디</td>
					<td>
					  <input type="text" name="_member_id"  id="_member_id"  size="20" />
					  <input type="hidden" name="member_id"  id="member_id" value=""/>
					  
					  <input type="button"  id="btnOverlapped" value="중복체크" onClick="fn_overlapped()" />
					</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">비밀번호</td>
					<td><input name="member_pw" type="password" size="20" /></td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">이름</td>
					<td><input name="member_name" type="text" size="20"  /></td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">성별</td>
					<td><input type="radio" name="member_gender" value="102" />
						여성<span style="padding-left:120px"></span>
						 <input type="radio" name="member_gender" value="101" checked />남성
					</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">법정생년월일</td>
					<td>
					<select name="member_birth_y">
					 
					     <c:forEach var="year" begin="1" end="104">
					       <c:choose>
					         <c:when test="${year==80}">
							   <option value="${ 1920+year}" selected>${ 1920+year} </option>
							</c:when>
							<c:otherwise>
							  <option value="${ 1920+year}" >${ 1920+year} </option>
							</c:otherwise>
							</c:choose>
					   	</c:forEach> 
							
					</select>년 
					 <select name="member_birth_m" >
					   <c:forEach var="month" begin="1" end="12">
					       <c:choose>
					         <c:when test="${month==5 }">
							   <option value="${month }" selected>${month }</option>
							</c:when>
							<c:otherwise>
							  <option value="${month }">${month}</option>
							</c:otherwise>
							</c:choose>
					   	</c:forEach>
					</select>월  
					<select name="member_birth_d">
							<c:forEach var="day" begin="1" end="31">
					       <c:choose>
					         <c:when test="${day==10 }">
							   <option value="${day}" selected>${day}</option>
							</c:when>
							<c:otherwise>
							  <option value="${day}">${day}</option>
							</c:otherwise>
							</c:choose>
					   	</c:forEach>
					</select>일 <span style="padding-left:50px"></span>
					  <input type="radio" name="member_birth_gn" value="2" checked />양력
						 <span style="padding-left:50px"></span>
						<input type="radio"  name="member_birth_gn" value="1" />음력
				  </td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">전화번호</td>
					<td><select  name="tel1">
							<option>없음</option>
							<option value="010">010</option>
							<option value="02">02</option>
							<option value="031">031</option>
							<option value="032">032</option>
							<option value="033">033</option>
							<option value="041">041</option>
							<option value="042">042</option>
							<option value="043">043</option>
							<option value="044">044</option>
							<option value="051">051</option>
							<option value="052">052</option>
							<option value="053">053</option>
							<option value="054">054</option>
							<option value="055">055</option>
							<option value="061">061</option>
							<option value="062">062</option>
							<option value="063">063</option>
							<option value="064">064</option>
							<option value="0502">0502</option>
							<option value="0503">0503</option>
							<option value="0505">0505</option>
							<option value="0506">0506</option>
							<option value="0507">0507</option>
							<option value="0508">0508</option>
							<option value="070">070</option>
					   </select> - <input  size="10px" type="text" name="tel2"> - <input size="10px"  type="text" name="tel3">
					</td>
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">휴대폰번호</td>
					<td><select  name="hp1">
							<option>없음</option>
							<option selected value="010">010</option>
							<option value="011">011</option>
							<option value="016">016</option>
							<option value="017">017</option>
							<option value="018">018</option>
							<option value="019">019</option>
					</select> - <input size="10px"  type="text" name="hp2"> - <input size="10px"  type="text"name="hp3"><br> <br> 
					  <input type="checkbox" id="smsstsCheckbox" name="smssts_yn" value="Y"  checked />
					    쇼핑몰에서 발송하는 SMS 소식을 수신합니다.
					 <input type="hidden" id="smsHidden" name="smssts_yn" value="N" />
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">이메일<br>(e-mail)</td>
					<td><input size="10px"   type="text" name="email1"/> @ 
						<input size="10px" type="text" name="email2" id="email2Input"/>
						 <select id="email2Select" name="email2Select" onChange="updateEmailDomain()" title="직접입력">
									<option value="">직접입력</option>
									<option value="hanmail.net">hanmail.net</option>
									<option value="naver.com">naver.com</option>
									<option value="yahoo.co.kr">yahoo.co.kr</option>
									<option value="hotmail.com">hotmail.com</option>
									<option value="paran.com">paran.com</option>
									<option value="nate.com">nate.com</option>
									<option value="google.com">google.com</option>
									<option value="gmail.com">gmail.com</option>
									<option value="empal.com">empal.com</option>
									<option value="korea.com">korea.com</option>
									<option value="freechal.com">freechal.com</option>
							</select><br> <br> 
							 <input type="checkbox" id="emailstsCheckbox" name="emailsts_yn" value="Y" checked />
							   쇼핑몰에서 발송하는 e-mail을 수신합니다.
							 <input type="hidden" id="emailHidden" name="emailsts_yn" value="N" />
				</tr>
				<tr class="dot_line">
					<td class="fixed_join">주소</td>
					<td>
					   <input type="text" id="zipcode" name="zipcode" size="10" > <a href="javascript:execDaumPostcode()">우편번호검색</a>
					  <br>
					  <p> 
					  도로명 주소:<br><input type="text" id="roadAddress"  name="roadAddress" size="50"><br><br>
					  지번 주소: <input type="text" id="jibunAddress" name="jibunAddress" size="50"><br><br>
					  나머지 주소: <input type="text"  id="namujiAddress" name="namujiAddress" size="50" />
					  <span id="guide" style="color:#999;display:none"></span>
					   </p>
					</td>
				</tr>
			</tbody>
		</table>
		</div>
		<div class="clear">
		<br><br>
		<table align=center>
		<tr >
			<td >
				<input type="submit"  value="회원 가입">
				<input  type="reset"  value="다시입력">
			</td>
		</tr>
	</table>
	</div>
</form>	
</body>
</html>