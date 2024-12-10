package com.bookplus.API.weather.vo;

public class APIweatherVO {

	private String type;
    private String baseDate; // 발표일자
    private String baseTime; // 발표시각
    private String category; // 자료구분코드
    private String obsrValue; // 실황 값
    private String fcstDate; // 예보일자
    private String fcstTime; // 예보시각
    private String fcstValue; // 예보 값
    private int nx; // 예보지점 X 좌표
    private int ny; // 예보지점 Y 좌표

    // Getter and Setter Methods

    public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

    public String getBaseDate() {
        return baseDate;
    }

	public void setBaseDate(String baseDate) {
        this.baseDate = baseDate;
    }

    public String getBaseTime() {
        return baseTime;
    }

    public void setBaseTime(String baseTime) {
        this.baseTime = baseTime;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getObsrValue() {
        return obsrValue;
    }

    public void setObsrValue(String obsrValue) {
        this.obsrValue = obsrValue;
    }

    public String getFcstDate() {
        return fcstDate;
    }

    public void setFcstDate(String fcstDate) {
        this.fcstDate = fcstDate;
    }

    public String getFcstTime() {
        return fcstTime;
    }

    public void setFcstTime(String fcstTime) {
        this.fcstTime = fcstTime;
    }

    public String getFcstValue() {
        return fcstValue;
    }

    public void setFcstValue(String fcstValue) {
        this.fcstValue = fcstValue;
    }

    public int getNx() {
        return nx;
    }

    public void setNx(int nx) {
        this.nx = nx;
    }

    public int getNy() {
        return ny;
    }

    public void setNy(int ny) {
        this.ny = ny;
    }

    @Override
    public String toString() {
        return "APIweatherVO{" +
        		"type='" + type + '\'' +
                ", baseDate='" + baseDate + '\'' +
                ", baseTime='" + baseTime + '\'' +
                ", category='" + category + '\'' +
                ", obsrValue='" + obsrValue + '\'' +
                ", fcstDate='" + fcstDate + '\'' +
                ", fcstTime='" + fcstTime + '\'' +
                ", fcstValue='" + fcstValue + '\'' +
                ", nx=" + nx +
                ", ny=" + ny +
                '}';
    }
}
