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

    // 파라미터 및 내부 _goods_id → _goods_isbn으로 변경
    public Map goodsDetail(String _goods_isbn) throws Exception {
        Map goodsMap = new HashMap();
        
        // goodsDAO 호출 시에도 _goods_isbn을 사용
        GoodsVO goodsVO = goodsDAO.selectGoodsDetail(_goods_isbn);
        goodsMap.put("goodsVO", goodsVO);

        List<GoodsVO> imageList = goodsDAO.selectGoodsDetailImage(_goods_isbn);
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
            
            // 썸네일(cover) 정보가 있다면 가져오는 로직 추가 가능
            // if(item.has("goods_cover")){
            //     goodsVO.setGoods_cover(item.getString("goods_cover"));
            // }

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
	public List<GoodsVO> fetchBookDetails() throws Exception {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public boolean updateDatabase(List<GoodsVO> fetchBookDetails) throws Exception {
		// TODO Auto-generated method stub
		return false;
	}

}
