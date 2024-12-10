package com.bookshop01.member.service;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bookshop01.api.vo.APILoginVO;
import com.bookshop01.member.vo.MemberVO;

public interface MemberService {
	public MemberVO login(Map<String, String>  loginMap) throws Exception;
	public MemberVO addMember(MemberVO memberVO) throws Exception;
	public String overlapped(String id) throws Exception;
	
	MemberVO checkKakaoUser(String kakaoId);
	String handleKakaoLogin(String code, HttpServletRequest request);
}
