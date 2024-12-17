package com.bookplus.main;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.stereotype.Controller;

import org.springframework.web.bind.annotation.GetMapping;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.bookplus.common.base.BaseController;
import com.bookplus.goods.service.GoodsService;
import com.bookplus.goods.vo.GoodsVO;
import com.bookplus.goods.vo.ImageFileVO;

//@Controller("mainController"): 해당 클래스를 컨트롤러로 지정하며, 빈의 이름을 "mainController"로 설정한다.
//@EnableAspectJAutoProxy: AOP를 사용하기 위한 어노테이션으로, 이를 설정하면 자동으로 AOP 프록시를 생성하여 적용한다.
@Controller("mainController")
@EnableAspectJAutoProxy
public class MainController extends BaseController {
	
	//GoodsServiceImpl.java파일에 작성 해 놓은 
	//public class GoodsServiceImpl implements GoodsService {} 의
	//<bean>을 자동 주입 합니다.
	@Autowired
	private GoodsService goodsService;

	

	// http://localhost:8090/bookShop01/main/main.do 입력하여 메인화면 요청시
	// 메인화면 중앙에 보여줄 베스트셀러, 신간, 스테디 셀러를 조회한후  Map에 저장하여  JSP로 전달합니다.
	@RequestMapping(value= "/main/main.do" ,method={RequestMethod.POST,RequestMethod.GET})
	public ModelAndView main(HttpServletRequest request, HttpServletResponse response) throws Exception{
		
		//세션영역에 side_menu속성값 user를 저장 해 놓으면
		//첫 메인 화면 main.jsp의 왼쪾사이드메뉴 모습은 비로그인된 상태로 접속한 사이드 왼쪾메뉴를 나타내기 위해 쓰입니다.
		//참고. 그밖에 세연영역에 저장되는 값 확인을 위해 common폴더에 만들어져 있는 side.jsp를 열어 확인 해보세요
		HttpSession session;
		session=request.getSession();
		session.setAttribute("side_menu", "user");
				
		ModelAndView mav=new ModelAndView();
		
		//ViewNameIntercetor클래스의 preHandle메소드 내부에서 request에 바인딩한 뷰 주소 /main/main 을!!!!!!!
		//request.getAttribute("viewName"); 으로 얻어 
		//views폴더/main폴더/main.jsp메인 페이지로 조회된 베스트셀러 , 신간, 스테디셀러 도서 정보를 보내기 위해  ModelAndView객체에 저장 (바인딩)
		String viewName=(String)request.getAttribute("viewName");
		mav.setViewName(viewName);
		
		//베스트 셀러, 신간, 스테디 셀러  도서정보를 조회 해 Map에 저장받기 위해  서비스의 메소드 호출!
		Map<String,List<GoodsVO>> goodsMap=goodsService.listGoods();
		mav.addObject("goodsMap", goodsMap); //ModelAndView에 main.jsp중앙화면에 보여줄 조회된 도서 정보가 저장된 Map을 저장 (바인딩)
		
		  System.out.println("-------------------------------------------------------------------");
	      System.out.println("-------------------------------------------------------------------");
	      System.out.println("흐름2.");
	      System.out.println("MainController컨트롤러 클래스 내부의 main메소드 호출되었으며");
	      System.out.println("main메소드 내부에서 ViewNameInterceptor클래스에서 request에 바인딩한 ");
	      System.out.println("뷰 주소 " + viewName + " 을 request.getAttribute('viewName'); 으로 얻음");
	      System.out.println("ModelAndView에 " + viewName + " 뷰 주소 저장 함.");
	      System.out.println(" 세션 메모리 영역에 session.setAttribute('side_menu',user); 로 저장 함.");
	      System.out.println(" 'side_menu'속성 값에 따라 화면 왼쪽에 표시되는 메뉴 항목을 다르게 하기 위해 저장 세션에 저장 하였음");
	      System.out.println(" Map<String,List<GoodsVO>> goodsMap=goodsService.listGoods(); 이코드에 의해 베스드셀러 신간, 스테디셀러 정보를 조회해 Map에 저장 후 반환 받습니다.");
	      System.out.println(" 마지막으로 ModelAndView에 추가로~ mav.addObject('goodsMap', goodsMap); 코드에 의해 조회된 Map을 저장시킵니다.");
	      System.out.println(" return mav; 구문에 의해 ViewNameInterceptor클래스의 postHandle 메소드가 호출됩니다.");
	      
	      
	      System.out.println("-------------------------------------------------------------------");
	      System.out.println("-------------------------------------------------------------------");
	      
	      System.out.println("흐름3. 그 후 tiles_main.xml 파일에 작성한 <definition name=/main/main ...> 태그의 name속성값 /main/main이 ModelAndView에 저장 했던 /main/main과 일치하면 해당 뷰템플릿을 메인화면으로 보여줍니다.");
	
		
		return mav;
		
	}
	
	@RequestMapping(value = "/map/directions.do" , method = RequestMethod.GET)
	public String showDirections(HttpServletRequest request, HttpServletResponse response) throws Exception {
		
		String viewName=(String)request.getAttribute("viewName");
		
		return viewName;
	}
	
	@GetMapping("/fetchAndSave")
    @ResponseBody
    public String fetchAndSaveGoods() {

        String apiUrl = "https://www.aladin.co.kr/ttb/api/ItemSearch.aspx?ttbkey=ttbsmilesna171505001&Query=IT&SearchTarget=Book&Output=js";

        try {
            // 1. API 호출
            String jsonResponse = fetchApiData(apiUrl);

            // 2. JSON 데이터 파싱
            List<GoodsVO> goodsList = parseJsonData(jsonResponse);
            JSONArray items = new JSONObject(jsonResponse).getJSONArray("item");
            
         // 3. 데이터 저장
            for (int i = 0; i < goodsList.size(); i++) {
            	  GoodsVO goodsVO = goodsList.get(i);
            	
            	// 상품 저장
                goodsService.saveGoods(goodsVO);  // 상품 저장 후, goods_id가 자동 생성됨
                
                String goodsId = goodsVO.getGoods_id();  // 자동 생성된 goods_id
                
                // 확인: 상품 저장 후, goods_id가 정상적으로 설정되었는지 확인
                if (goodsId == null) {
                    throw new Exception("상품 저장 실패: goods_id가 생성되지 않았습니다.");
                }
                
                // 4. 이미지 파일 URL DB에 저장
//                String fileName = items.getJSONObject(i).getString("cover"); // JSON에서 커버 이미지 추출
//                List<ImageFileVO> imageFiles = createImageFiles(fileName); // 이미지 URL 리스트 생성

                // 5. 이미지 파일 DB에 저장
//                goodsService.saveImageFiles(imageFiles, goodsId);
            }
            
            return "데이터 저장 성공";
        } catch (Exception e) {
            e.printStackTrace();
            return "데이터 저장 실패: " + e.getMessage();
        }
    }

  
	// API 호출
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

    // JSON 데이터 파싱
    private List<GoodsVO> parseJsonData(String jsonData) {
        List<GoodsVO> goodsList = new ArrayList<>();
        JSONObject jsonObject = new JSONObject(jsonData);
        JSONArray items = jsonObject.getJSONArray("item");

        for (int i = 0; i < items.length(); i++) {
            JSONObject item = items.getJSONObject(i);
            GoodsVO goodsVO = new GoodsVO();

            goodsVO.setGoods_sort(item.getString("categoryName"));  //JSON 필드: categoryName
            goodsVO.setGoods_title(item.getString("title")); // JSON 필드: title
            goodsVO.setGoods_writer(item.getString("author")); // JSON 필드: author
            goodsVO.setGoods_publisher(item.getString("publisher")); // JSON 필드: publisher
            goodsVO.setGoods_price(item.optInt("priceStandard", 0)); // JSON 필드: priceStandard
            goodsVO.setGoods_sales_price(item.getInt("priceSales"));  // JSON 필드: priceSales
            goodsVO.setGoods_published_date(java.sql.Date.valueOf(item.getString("pubDate"))); // JSON 필드: pubDate
            goodsVO.setGoods_isbn(item.getString("isbn13")); // JSON 필드: isbn13
            goodsVO.setGoods_delivery_price(item.getInt("mileage"));   // JSON 필드: mileage         

            goodsList.add(goodsVO);
        }

        return goodsList;
    }
    
    private List<ImageFileVO> createImageFiles(String fileName) {
   	 List<ImageFileVO> imageFiles = new ArrayList<>();
   	    
   	 // 이미지 파일 정보를 ImageFileVO로 매핑
   	    ImageFileVO imageFileVO = new ImageFileVO();
   	    imageFileVO.setFileName(fileName);  // API에서 가져온 커버 URL을 fileName으로 설정
   	    imageFileVO.setReg_id("admin");  // 예: 관리자 아이디
   	    imageFileVO.setFileType("main");  // 예: 메인 이미지 타입
   	    
   	    imageFiles.add(imageFileVO);

   	    return imageFiles;
   	}


}
