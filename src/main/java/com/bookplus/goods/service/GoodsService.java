package com.bookplus.goods.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.bookplus.goods.vo.GoodsVO;
import com.bookplus.goods.vo.ImageFileVO;

public interface GoodsService {
	
	//상품 상세정보를 조회하는 메서드로, _goods_id를 인자로 받아 Map 형태로 반환합니다.
	public Map goodsDetail(String goods_id) throws Exception;
	
	//키워드로 상품을 검색하는 메서드로, keyword를 인자로 받아 List<String> 형태로 반환합니다.
	public List<String> keywordSearch(String keyword) throws Exception;
	
	//검색어로 상품을 검색하는 메서드로, searchWord를 인자로 받아 List<GoodsVO> 형태로 반환합니다.
	public List<GoodsVO> searchGoods(String searchWord) throws Exception;

	public String saveGoods(GoodsVO goodsVO) throws Exception;
	public  void saveImageFiles(List<ImageFileVO> imageFiles, int goodsId) throws Exception;
	
	public List<GoodsVO> getAllGoods(int limit, int offset) throws Exception;

}
