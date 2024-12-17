package com.bookplus.goods.vo;

import java.sql.Date;

public class GoodsVO {
	/*
	 * title = goods_title (제목) author = goods_author (저자) pubDate = goods_pubDate
	 * (출판일) isbn13 = goods_isbn (isbn) priceStandard = goods_priceStandard (정가)
	 * priceSales = goods_priceSales (할인율) (내부 결정 사항, API 정보가 아님!) cover =
	 * goods_cover (썸네일) categoryName = goods_categoryName (카테고리 분류) publisher =
	 * goods_publisher (출판사)
	 */
	String goods_title;
	String goods_author;
	Date goods_pubDate;
	String goods_isbn;
	int goods_priceStandard;
	int goods_priceSales;
	String goods_cover;
	String goods_categoryName;
	String goods_publisher;

	public String getGoods_title() {
		return goods_title;
	}

	public void setGoods_title(String goods_title) {
		this.goods_title = goods_title;
	}

	public String getGoods_author() {
		return goods_author;
	}

	public void setGoods_author(String goods_author) {
		this.goods_author = goods_author;
	}

	public Date getGoods_pubDate() {
		return goods_pubDate;
	}

	public void setGoods_pubDate(Date goods_pubDate) {
		this.goods_pubDate = goods_pubDate;
	}

	public String getGoods_isbn() {
		return goods_isbn;
	}

	public void setGoods_isbn(String goods_isbn) {
		this.goods_isbn = goods_isbn;
	}

	public int getGoods_priceStandard() {
		return goods_priceStandard;
	}

	public void setGoods_priceStandard(int goods_priceStandard) {
		this.goods_priceStandard = goods_priceStandard;
	}

	public int getGoods_priceSales() {
		return goods_priceSales;
	}

	public void setGoods_priceSales(int goods_priceSales) {
		this.goods_priceSales = goods_priceSales;
	}

	public String getGoods_cover() {
		return goods_cover;
	}

	public void setGoods_cover(String goods_cover) {
		this.goods_cover = goods_cover;
	}

	public String getGoods_categoryName() {
		return goods_categoryName;
	}

	public void setGoods_categoryName(String goods_categoryName) {
		this.goods_categoryName = goods_categoryName;
	}

	public String getGoods_publisher() {
		return goods_publisher;
	}

	public void setGoods_publisher(String goods_publisher) {
		this.goods_publisher = goods_publisher;
	}

	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return super.toString();
	}

}