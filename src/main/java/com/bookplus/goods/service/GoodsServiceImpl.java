package com.bookplus.goods.service;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.lang.model.element.Element;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.w3c.dom.Document;
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

	//알라딘 API조회
	 @Override
	    public List<GoodsVO> fetchBookDetails() throws Exception {
	        List<GoodsVO> goodsList = new ArrayList<>();
	        int totalItems = 300; // 가져올 총 데이터 수
	        int currentStart = 1; // 시작점 초기값

	        try {
	            RestTemplate restTemplate = new RestTemplate();

	            while (currentStart <= totalItems) {
	                // 1. API URL 구성 (start 값 변경)
	                String requestUrl = String.format(
	                        "%s?ttbkey=%s&QueryType=Bestseller&MaxResults=%d&Start=%d&categoryId=351&Output=xml&Version=20131101",
	                        API_URL, API_KEY, MAX_RESULTS, currentStart);

	                // 2. API 호출 및 응답 처리
	                String response = restTemplate.getForObject(requestUrl, String.class);
	                DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
	                DocumentBuilder builder = factory.newDocumentBuilder();
	                Document doc = builder.parse(new java.io.ByteArrayInputStream(response.getBytes("UTF-8")));

	                NodeList itemList = doc.getElementsByTagName("item");

	                // 3. 각 item 태그의 정보를 VO에 저장
	                for (int i = 0; i < itemList.getLength(); i++) {
	                    Element item = (Element) itemList.item(i);

	                    GoodsVO goods = new GoodsVO();
	                    goods.setGoods_title(getTagValue("title", item));
	                    goods.setGoods_author(getTagValue("author", item));
	                    goods.setGoods_pubDate(java.sql.Date.valueOf(java.time.LocalDate.parse(getTagValue("pubDate", item), java.time.format.DateTimeFormatter.ISO_DATE)));
	                    goods.setGoods_isbn(getTagValue("isbn", item));
	                    goods.setGoods_priceStandard(parseToInt(getTagValue("priceStandard", item)));
	                    goods.setGoods_priceSales(parseToInt(getTagValue("priceSales", item)));
	                    goods.setGoods_cover(getTagValue("cover", item));
	                    goods.setGoods_categoryName(getTagValue("categoryName", item));
	                    goods.setGoods_publisher(getTagValue("publisher", item));

	                    goodsList.add(goods);
	                }

	                // 4. 다음 페이지로 이동
	                currentStart += MAX_RESULTS; // 다음 시작점 계산
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }

	        return goodsList;
	    }
	 
/*
	    // XML 태그값 추출 메서드
	    private String getTagValue(String tag, Element element) {
	        NodeList nodeList = ((Document) element).getElementsByTagName(tag);
	        if (nodeList.getLength() > 0) {
	            return nodeList.item(0).getTextContent();
	        }
	        return "";
	    }

	    // 문자열을 정수로 변환하는 메서드 (예외 처리 포함)
	    private int parseToInt(String value) {
	        try {
	            return Integer.parseInt(value);
	        } catch (NumberFormatException e) {
	            return 0; // 파싱 실패시 0으로 설정
	        }
	    }
*/


	@Override
	public boolean updateDatabase(List<GoodsVO> fetchBookDetails) throws Exception {
		 boolean result = false;
		    
		    try {
		        // fetchBookDetails에서 받은 VO 리스트를 DAO로 전달하여 데이터베이스에 저장
		        for (GoodsVO goodsVO : fetchBookDetails) {
		            // 각 상품 정보에 대해 DAO의 insert 메서드 호출
		            // 예를 들어, insertGoods()라는 메서드를 사용한다고 가정
		            int insertResult = goodsDAO.insertGoods(goodsVO); 
		            
		            // insert 결과가 1이면 성공적으로 저장됨
		            if (insertResult == 1) {
		                result = true;  // 성공적으로 저장된 경우
		            } else {
		                result = false;  // 실패한 경우
		                break;  // 실패 시 더 이상 진행하지 않고 종료
		            }
		        }
		    } catch (Exception e) {
		        e.printStackTrace();
		        result = false;  // 예외 발생 시 실패 처리
		    }

		    return result;  // true/false로 성공 여부 반환
		}
	}

