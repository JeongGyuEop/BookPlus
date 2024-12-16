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
import com.bookplus.goods.vo.ImageFileVO;

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

        List<ImageFileVO> imageList = goodsDAO.selectGoodsDetailImage(_goods_id);

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

    @Override
    @Transactional
    public int saveGoods(GoodsVO goodsVO) throws Exception {
        goodsDAO.insertGoods(goodsVO);

        return goodsVO.getGoods_id();
    }

    @Override
    public void saveImageFiles(List<ImageFileVO> imageFiles, int goodsId) throws Exception {
        for (ImageFileVO imageFileVO : imageFiles) {
            imageFileVO.setGoods_id(goodsId);
            goodsDAO.insertImageFile(imageFileVO);
        }
    }

    // @GetMapping("/fetchAndSave") 대신 사용
    @RequestMapping(value = "/fetchAndSave", method = RequestMethod.GET)
    @ResponseBody
    public String fetchAndSaveGoods() {

        String apiUrl = "https://www.aladin.co.kr/ttb/api/ItemSearch.aspx?ttbkey=ttbsmilesna171505001&Query=IT&SearchTarget=Book&Output=js";

        try {
            String jsonResponse = fetchApiData(apiUrl);

            List<GoodsVO> goodsList = parseJsonData(jsonResponse);
            JSONArray items = new JSONObject(jsonResponse).getJSONArray("item");

            for (int i = 0; i < goodsList.size(); i++) {
                GoodsVO goodsVO = goodsList.get(i);

                saveGoods(goodsVO);

                int goodsId = goodsVO.getGoods_id();

                if (goodsId == 0) {
                    throw new Exception("상품 저장 실패: goods_id가 생성되지 않았습니다.");
                }

                // 이미지 처리 관련 주석된 부분
            }

            return "데이터 저장 성공";
        } catch (Exception e) {
            e.printStackTrace();
            return "데이터 저장 실패: " + e.getMessage();
        }
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

            goodsVO.setGoods_sort(item.getString("categoryName"));
            goodsVO.setGoods_title(item.getString("title"));
            goodsVO.setGoods_writer(item.getString("author"));
            goodsVO.setGoods_publisher(item.getString("publisher"));
            goodsVO.setGoods_price(item.optInt("priceStandard", 0));
            goodsVO.setGoods_sales_price(item.getInt("priceSales"));
            goodsVO.setGoods_published_date(java.sql.Date.valueOf(item.getString("pubDate")));
            goodsVO.setGoods_isbn(item.getString("isbn13"));
            goodsVO.setGoods_delivery_price(item.getInt("mileage"));

            goodsList.add(goodsVO);
        }

        return goodsList;
    }

    private List<ImageFileVO> createImageFiles(String fileName) {
        List<ImageFileVO> imageFiles = new ArrayList<>();

        ImageFileVO imageFileVO = new ImageFileVO();
        imageFileVO.setFileName(fileName);
        imageFileVO.setReg_id("admin");
        imageFileVO.setFileType("main");

        imageFiles.add(imageFileVO);

        return imageFiles;
    }

    @Override
    public boolean updateDatabase() {
        return false;
    }

    @Override
    public boolean fetchBookDetails() {
        return false;
    }
}
