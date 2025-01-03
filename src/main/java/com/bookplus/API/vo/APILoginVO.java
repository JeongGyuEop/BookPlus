package com.bookplus.API.vo;

public class APILoginVO {
    private String id;
    private String accountEmail;
    private String gender;
    private String birthday;
    private String birthyear;
    private String phoneNumber;
    private String socialProvider;

	// Getter와 Setter
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getAccountEmail() {
        return accountEmail;
    }

    public void setAccountEmail(String accountEmail) {
        this.accountEmail = accountEmail;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getBirthday() {
        return birthday;
    }

    public void setBirthday(String birthday) {
        this.birthday = birthday;
    }

    public String getBirthyear() {
        return birthyear;
    }

    public void setBirthyear(String birthyear) {
        this.birthyear = birthyear;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getSocialProvider() {
		return socialProvider;
	}

	public void setSocialProvider(String socialProvider) {
		this.socialProvider = socialProvider;
	}

}
