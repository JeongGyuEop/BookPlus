package com.bookplus.goods.dao;

import java.util.List;

import org.springframework.dao.DataAccessException;

import com.bookplus.goods.vo.GoodsVO;

public interface GoodsDAO {
	public List<GoodsVO> selectGoodsList(String goodsStatus ) throws DataAccessException;
	public List<String> selectKeywordSearch(String keyword) throws DataAccessException;
	public GoodsVO selectGoodsDetail(String goods_id) throws DataAccessException;
	public List<GoodsVO> selectGoodsDetailImage(String goods_id) throws DataAccessException;
	public List<GoodsVO> selectGoodsBySearchWord(String searchWord) throws DataAccessException;
	GoodsVO selectGoodsByISBN(String isbn); // ISBN으로 책 조회
    int updateGoods(GoodsVO goodsVO); // 책 정보 업데이트
    int insertGoods(GoodsVO goodsVO); // 새 책 정보 삽입
}
