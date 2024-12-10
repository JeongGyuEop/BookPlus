package com.bookshop01.member.dao;

import java.util.Map;

import org.springframework.dao.DataAccessException;

import com.bookshop01.api.vo.APILoginVO;
import com.bookshop01.member.vo.MemberVO;

public interface MemberDAO {
	public MemberVO login(Map<String, String> loginMap) throws DataAccessException;
	public void insertNewMember(MemberVO memberVO) throws DataAccessException;
	public String selectOverlappedID(String id) throws DataAccessException;
	MemberVO selectKakaoUser(String kakaoId) throws DataAccessException;
	void insertKakaoUser(APILoginVO kakaoUser) throws DataAccessException;
}
