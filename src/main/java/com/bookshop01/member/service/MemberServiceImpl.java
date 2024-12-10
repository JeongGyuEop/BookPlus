package com.bookshop01.member.service;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import com.bookshop01.api.vo.APILoginVO;
import com.bookshop01.member.dao.MemberDAO;
import com.bookshop01.member.vo.MemberVO;
import com.google.gson.Gson;
import com.google.gson.JsonObject;


@Service("memberService")
@Transactional(propagation=Propagation.REQUIRED)
public class MemberServiceImpl implements MemberService {
	

	private static final String KAKAO_TOKEN_URL = "https://kauth.kakao.com/oauth/token";
	private static final String KAKAO_USER_INFO_URL = "https://kapi.kakao.com/v2/user/me";
	private static final String CLIENT_ID = "f6d8eb0ebbe1cc122b97b3f7be2a2b1a"; // 카카오 개발자 센터에서 발급받은 REST API 키
	private static final String REDIRECT_URI = "http://localhost:8090/BookPlus/member/kakao/callback"; // 설정한 리디렉션 URL
	
	@Autowired
	private MemberDAO memberDAO;
	
	@Override
	public MemberVO login(Map<String, String> loginMap) throws Exception{
		return memberDAO.login(loginMap);
	}
	
	@Override
	public MemberVO addMember(MemberVO memberVO) throws Exception{
		memberDAO.insertNewMember(memberVO);
		// 회원 가입 후 로그인 처리
        Map<String, String> loginMap = new HashMap<>();
        loginMap.put("member_id", memberVO.getMember_id());
        loginMap.put("member_pw", memberVO.getMember_pw());

        return memberDAO.login(loginMap); // 로그인 처리
	}
	
	@Override
	public String overlapped(String id) throws Exception{
		return memberDAO.selectOverlappedID(id);
	}
	
	private void setupSession(HttpServletRequest request, MemberVO memberVO) {
	    HttpSession session = request.getSession();
	    session.setAttribute("isLogOn", true);
	    session.setAttribute("memberInfo", memberVO);
	}

	
	@Override
    public String handleKakaoLogin(String code, HttpServletRequest request) {
        // 1. 액세스 토큰 요청
        String accessToken = getAccessToken(code);

        // 2. 사용자 정보 가져오기
        APILoginVO kakaoUser = getUserInfo(accessToken);

        // 필수 필드 검증
        validateKakaoUser(kakaoUser);

        // 3. 사용자 존재 여부 확인
        MemberVO memberVO = checkKakaoUser(kakaoUser.getId());

        if (memberVO != null) {
            // 기존 사용자: 로그인 처리
            setupSession(request, memberVO);
            return "redirect:/main/main.do";
        } else {
            // 신규 사용자: 회원가입 세션 저장 및 리다이렉트 URL 반환
            prepareSignupSession(kakaoUser, request);
            return "/member/memberForm"; // 회원가입 폼으로 리다이렉트

        }
    }

	public String getAccessToken(String code) {
	    RestTemplate restTemplate = new RestTemplate();

	    // 요청 헤더 설정
	    HttpHeaders headers = new HttpHeaders();
	    headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

	    // 요청 파라미터 설정
	    MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
	    params.add("grant_type", "authorization_code");
	    params.add("client_id", CLIENT_ID);
	    params.add("redirect_uri", REDIRECT_URI);
	    params.add("code", code);
	    params.add("scope", "account_email,gender,birthday,birthyear,phone_number");

	    // 요청 엔티티 생성
	    HttpEntity<MultiValueMap<String, String>> requestEntity = new HttpEntity<>(params, headers);

	    try {
	        // POST 요청으로 액세스 토큰 가져오기
	        ResponseEntity<String> response = restTemplate.exchange(
	                KAKAO_TOKEN_URL, HttpMethod.POST, requestEntity, String.class);

	        // JSON 응답 파싱
	        Gson gson = new Gson();
	        JsonObject jsonResponse = gson.fromJson(response.getBody(), JsonObject.class);

	        // 액세스 토큰 반환
	        return jsonResponse.get("access_token").getAsString();

	    } catch (HttpClientErrorException e) {
	        System.err.println("Request failed: " + e.getResponseBodyAsString());
	        throw new RuntimeException("Failed to fetch access token", e);
	    } catch (Exception e) {
	        throw new RuntimeException("Unexpected error while fetching access token", e);
	    }
	}
	
	public APILoginVO getUserInfo(String accessToken) {
	    RestTemplate restTemplate = new RestTemplate();

	    // Authorization 헤더 설정
	    HttpHeaders headers = new HttpHeaders();
	    headers.set("Authorization", "Bearer " + accessToken);

	    // HTTP 요청 엔티티 생성
	    HttpEntity<Void> requestEntity = new HttpEntity<>(headers);

	    try {
	        // 사용자 정보 요청 (GET)
	        ResponseEntity<String> response = restTemplate.exchange(
	            KAKAO_USER_INFO_URL, HttpMethod.GET, requestEntity, String.class
	        );

	        // 응답 확인
	        if (response == null || response.getBody() == null) {
	            throw new RuntimeException("Kakao API response is null");
	        }

	        // JSON 응답 파싱
	        Gson gson = new Gson();
	        JsonObject jsonResponse = gson.fromJson(response.getBody(), JsonObject.class);

	        // id 확인
	        if (!jsonResponse.has("id")) {
	            throw new RuntimeException("ID field is missing in Kakao API response");
	        }
	        String id = jsonResponse.get("id").getAsString();

	        // kakao_account 확인
	        JsonObject kakaoAccount = jsonResponse.has("kakao_account") ? jsonResponse.getAsJsonObject("kakao_account") : null;

	        if (kakaoAccount == null) {
	            throw new RuntimeException("Kakao account is missing in response");
	        }

	        // 필요한 데이터 추출
	        String email = kakaoAccount.has("email") ? kakaoAccount.get("email").getAsString() : null;
	        String gender = kakaoAccount.has("gender") ? kakaoAccount.get("gender").getAsString() : null;
	        String birthday = kakaoAccount.has("birthday") ? kakaoAccount.get("birthday").getAsString() : null;
	        String birthyear = kakaoAccount.has("birthyear") ? kakaoAccount.get("birthyear").getAsString() : null;
	        String phoneNumber = kakaoAccount.has("phone_number") ? kakaoAccount.get("phone_number").getAsString() : null;

	        // KakaoVO 객체 생성
	        APILoginVO kakaoUser = new APILoginVO();
	        kakaoUser.setId(id);
	        kakaoUser.setAccountEmail(email);
	        kakaoUser.setGender(gender);
	        kakaoUser.setBirthday(birthday);
	        kakaoUser.setBirthyear(birthyear);
	        kakaoUser.setPhoneNumber(phoneNumber);
	        kakaoUser.setSocialProvider("kakao");
	        

	        return kakaoUser;

	    } catch (Exception e) {
	        throw new RuntimeException("Error while fetching user info from Kakao API", e);
	    }
	}

	
	private void validateKakaoUser(APILoginVO apiUser) {
        if (apiUser.getAccountEmail() == null || 
        	apiUser.getGender() == null || apiUser.getBirthday() == null || 
        	apiUser.getBirthyear() == null || apiUser.getPhoneNumber() == null) {
            throw new RuntimeException("필수 동의 항목이 누락되었습니다.");
        }
    }


	private void prepareSignupSession(APILoginVO apiUser, HttpServletRequest request) {

        String accountEmail = apiUser.getAccountEmail();
        String email1 = "";
        String email2 = "";
        if (accountEmail != null && accountEmail.contains("@")) {
            String[] emailParts = accountEmail.split("@");
            email1 = emailParts[0];
            email2 = emailParts[1];
        }
        
        String phoneNumber = apiUser.getPhoneNumber().replace("+82 ", "0");
        String phone1 = "";
        String phone2 = "";
        String phone3 = "";
        if (phoneNumber != null && phoneNumber.contains("-")) {
            String[] phoneParts = phoneNumber.split("-");
            phone1 = phoneParts[0];
            phone2 = phoneParts[1];
            phone3 = phoneParts[2];
        }

        request.setAttribute("id", apiUser.getId());
        request.setAttribute("email1", email1);
        request.setAttribute("email2", email2);
        request.setAttribute("gender", apiUser.getGender());
        request.setAttribute("birthday", apiUser.getBirthday());
        request.setAttribute("birthyear", apiUser.getBirthyear());
        request.setAttribute("phone1", phone1);
        request.setAttribute("phone2", phone2);
        request.setAttribute("phone3", phone3);        
        request.setAttribute("socialProvider", apiUser.getSocialProvider());
    }
	
	@Override
	public MemberVO checkKakaoUser(String apiId) {
	    // DAO 호출: Kakao ID로 사용자 존재 여부 확인
	    return memberDAO.selectKakaoUser(apiId);
	}
	
}

















