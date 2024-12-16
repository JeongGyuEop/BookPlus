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
	public void insertGoods(GoodsVO goodsVO) throws DataAccessException, Exception;
	public void insertImageFile(GoodsVO goodsVO) throws DataAccessException, Exception;
	// 1. 인터페이스 만들어주고
}
