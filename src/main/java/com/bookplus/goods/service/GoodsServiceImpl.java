package com.bookplus.goods.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import com.bookplus.goods.dao.GoodsDAO;
import com.bookplus.goods.vo.GoodsVO;

@Service("goodsService")
@Transactional(propagation = Propagation.REQUIRED)
public class GoodsServiceImpl implements GoodsService {
	
	 private static final String API_URL = "http://www.aladin.co.kr/ttb/api/ItemList.aspx";
     private static final String API_KEY = "ttbsmilesna171505001"; // 알라딘 API 키 입력
	 private static final int MAX_RESULTS = 50; // 한 번에 가져올 수 있는 최대 결과 수


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
        List<GoodsVO> goodsList	 = new ArrayList<>();
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
        List<GoodsVO> goodsList = new ArrayList<>();
        String[] queryTypes = {"itemnewall", "bestseller", "blogbest"}; // API 타입
        int maxPages = 1; // 최대 페이지 수
        int maxResults = 50; // 페이지당 최대 결과 수

        try {
            RestTemplate restTemplate = new RestTemplate();
            for (int i = 0; i < queryTypes.length; i++) { // queryTypes 순회
                String queryType = queryTypes[i];

                for (int j = 1; j <= maxPages; j++) { // 페이지 순회
                    // API URL 동적 생성
                    String requestUrl = String.format(
                        "http://www.aladin.co.kr/ttb/api/ItemList.aspx?ttbkey=%s&querytype=%s&searchtarget=book&start=%d&maxresults=%d&cover=big&categoryid=351&output=xml&inputencoding=utf-8&version=20131101",
                        API_KEY, queryType, j, maxResults);
                    System.out.println(requestUrl);
                    // API 호출 및 응답 처리
                    String response = restTemplate.getForObject(requestUrl, String.class);
                    DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
                    DocumentBuilder builder = factory.newDocumentBuilder();
                    Document doc = builder.parse(new java.io.ByteArrayInputStream(response.getBytes("UTF-8")));

                    NodeList itemList = doc.getElementsByTagName("item");

                    // 파싱된 정보 확인
                    if (itemList.getLength() == 0) {
                        break; // 더 이상 데이터가 없으면 루프 종료
                    }

                    for (int k = 0; k < itemList.getLength(); k++) {
                        Element item = (Element) itemList.item(k);

                        GoodsVO goods = new GoodsVO();
                        goods.setGoods_title(getTagValue("title", item));
                        goods.setGoods_author(getTagValue("author", item));
                        goods.setGoods_pubDate(java.sql.Date.valueOf(java.time.LocalDate.parse(
                            getTagValue("pubDate", item),
                            java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd"))));
                        goods.setGoods_isbn(getTagValue("isbn", item));
                        goods.setGoods_priceStandard(parseToInt(getTagValue("priceStandard", item)));
                        goods.setGoods_priceSales(parseToInt(getTagValue("priceSales", item)));
                        goods.setGoods_cover(getTagValue("cover", item));
                        goods.setGoods_categoryName(getTagValue("categoryName", item));
                        goods.setGoods_publisher(getTagValue("publisher", item));

                        System.out.println(goods.toString());
                        goodsList.add(goods);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return goodsList;
    }


    @Override
    public boolean updateDatabase(List<GoodsVO> fetchBookDetails) throws Exception {
        boolean result = true;
        try {
            for (GoodsVO goods : fetchBookDetails) {
                // ISBN으로 기존 데이터 조회
                GoodsVO existingBook = goodsDAO.selectGoodsByISBN(goods.getGoods_isbn());
                if (existingBook != null) {
                    // 존재하면 업데이트
                    int updateResult = goodsDAO.updateGoods(goods);
                    if (updateResult != 1) {
                        System.err.println("Update 실패: " + goods.getGoods_isbn());
                        result = false; // 실패 처리
                    }
                } else {
                    // 존재하지 않으면 삽입
                    int insertResult = goodsDAO.insertGoods(goods);
                    if (insertResult != 1) {
                        System.err.println("Insert 실패: " + goods.getGoods_isbn());
                        result = false; // 실패 처리
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            result = false; // 예외 발생 시 실패
        }
        return result; // 최종 성공 여부 반환
    }

	
	private String getTagValue(String tag, Element element) {
	    NodeList nodeList = element.getElementsByTagName(tag);
	    if (nodeList != null && nodeList.getLength() > 0) {
	        Node node = nodeList.item(0);
	        if (node != null && node.getFirstChild() != null) {
	            return node.getFirstChild().getNodeValue();
	        }
	    }
	    return null;
	}
	
	private int parseToInt(String value) {
	    try {
	        return (value == null || value.isEmpty()) ? 0 : Integer.parseInt(value);
	    } catch (NumberFormatException e) {
	        return 0;
	    }
	}

}
