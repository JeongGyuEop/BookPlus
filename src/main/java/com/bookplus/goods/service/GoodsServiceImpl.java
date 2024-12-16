package com.bookplus.goods.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Date;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.bookplus.goods.dao.GoodsDAO;
import com.bookplus.goods.vo.GoodsVO;

@Service("goodsService")
@Transactional(propagation = Propagation.REQUIRED)
public class GoodsServiceImpl implements GoodsService {

	@Autowired
	private GoodsDAO goodsDAO;

	public Map<String, List<GoodsVO>> listGoods() throws Exception {

		Map<String, List<GoodsVO>> goodsMap = new HashMap<String, List<GoodsVO>>();

		List<GoodsVO> goodsList = goodsDAO.selectGoodsList("bestseller");
		goodsMap.put("bestseller", goodsList);

		goodsList = goodsDAO.selectGoodsList("newbook");
		goodsMap.put("newbook", goodsList);

		goodsList = goodsDAO.selectGoodsList("steadyseller");
		goodsMap.put("steadyseller", goodsList);

		return goodsMap;
	}

	public Map goodsDetail(String _goods_id) throws Exception {

		Map goodsMap = new HashMap();

		GoodsVO goodsVO = goodsDAO.selectGoodsDetail(_goods_id);

		goodsMap.put("goodsVO", goodsVO);

		List<GoodsVO> imageList = goodsDAO.selectGoodsDetailImage(_goods_id);

		goodsMap.put("imageList", imageList);

		return goodsMap;
	}

	public List<String> keywordSearch(String keyword) throws Exception {

		List<String> list = goodsDAO.selectKeywordSearch(keyword);
		return list;
	}

	public List<GoodsVO> searchGoods(String searchWord) throws Exception {
		List goodsList = goodsDAO.selectGoodsBySearchWord(searchWord);
		return goodsList;
	}

	/*
	 * @Override
	 * 
	 * @Transactional public int saveGoods(GoodsVO goodsVO) throws Exception {
	 * goodsDAO.insertGoods(goodsVO);
	 * 
	 * return goodsVO.getGoods_isbn(); }
	 * 책 id return 하는 메서드
	 */

	/*
	 * @Override public void saveImageFiles(List<ImageFileVO> imageFiles, int
	 * goodsId) throws Exception { for (GoodsVO goodsImage : goodsImages) {
	 * GoodsVO.setGoods_id(goodsId); goodsDAO.insertImageFile(GoodsVO); } }
	 * 이미지 파일 저장하기
	 */

	private String fetchApiData(String apiUrl) throws IOException {
		URL url = new URL(apiUrl);
		HttpURLConnection connection = (HttpURLConnection) url.openConnection();
		connection.setRequestMethod("GET");

		BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
		StringBuilder response = new StringBuilder();
		String line;

		while ((line = reader.readLine()) != null) {
			response.append(line);
		}

		reader.close();
		return response.toString();
	}

	private List<GoodsVO> parseJsonData(String jsonData) {
		List<GoodsVO> goodsList = new ArrayList<>();
		JSONObject jsonObject = new JSONObject(jsonData);
		JSONArray items = jsonObject.getJSONArray("item");

		for (int i = 0; i < items.length(); i++) {
			JSONObject item = items.getJSONObject(i);
			GoodsVO goodsVO = new GoodsVO();

			goodsVO.setGoods_title(item.getString("goods_title"));
			goodsVO.setGoods_author(item.getString("goods_author"));
			goodsVO.setGoods_pubDate(java.sql.Date.valueOf(item.getString("goods_pubDate")));
			goodsVO.setGoods_isbn(item.getString("goods_isbn"));
			goodsVO.setGoods_priceStandard(item.optInt("goods_priceStandard", 0));
			goodsVO.setGoods_priceSales(item.getInt("goods_priceSales"));
			goodsVO.setGoods_categoryName(item.getString("goods_categoryName"));
			goodsVO.setGoods_publisher(item.getString("goods_publisher"));

			goodsList.add(goodsVO);
		}

		return goodsList;
	}

	private List<GoodsVO> createImageFiles(String fileName) {
		List<GoodsVO> imageFiles = new ArrayList<>();

		GoodsVO imageFileVO = new GoodsVO();
		imageFileVO.setGoods_cover(fileName);

		imageFiles.add(imageFileVO);

		return imageFiles;
	}

	@Override
	public List<GoodsVO> fetchBookDetails() {
		List<GoodsVO> goodsList = new ArrayList<GoodsVO>();
		// 작업 공간
		// 1. API 주소 요청
		// 2. 받아온 xml을 파싱
		// 3. 파싱 정보를 vo에 저장
		return goodsList;
	}

	@Override
	public boolean updateDatabase(List<GoodsVO> fetchBookDetails) {
		// 작업 공간
		// 1. List에 담겨서 온 vo정보를 dao에 넘김
		return false;
	}

}
