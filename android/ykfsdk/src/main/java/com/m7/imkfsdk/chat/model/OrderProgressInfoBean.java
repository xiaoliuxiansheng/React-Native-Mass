package com.m7.imkfsdk.chat.model;

/**
 * @Description:
 * @Author: R-D
 * @Date: 2019-12-25
 */
public class OrderProgressInfoBean {

    private String title;
    private String is_current;
    private String desc;

    public String getTitle() {
        return title;
    }

    public OrderProgressInfoBean setTitle(String title) {
        this.title = title;
        return this;
    }

    public String getIs_current() {
        return is_current;
    }

    public OrderProgressInfoBean setIs_current(String is_current) {
        this.is_current = is_current;
        return this;
    }

    public String getDesc() {
        return desc;
    }

    public OrderProgressInfoBean setDesc(String desc) {
        this.desc = desc;
        return this;
    }
}
