package com.m7.imkfsdk.chat.model;

import java.util.List;

/**
 * @Description:
 * @Author: R-D
 * @Date: 2019-12-26
 */
public class OrderProgressBean {
    private String list_title;
    private String empty_message;
    private String message;
    private String list_num;
    private OrderInfoParams params;
    private List<OrderProgressInfoBean> list;

    public String getList_title() {
        return list_title;
    }

    public OrderProgressBean setList_title(String list_title) {
        this.list_title = list_title;
        return this;
    }

    public String getEmpty_message() {
        return empty_message;
    }

    public OrderProgressBean setEmpty_message(String empty_message) {
        this.empty_message = empty_message;
        return this;
    }

    public String getMessage() {
        return message;
    }

    public OrderProgressBean setMessage(String message) {
        this.message = message;
        return this;
    }

    public String getList_num() {
        return list_num;
    }

    public OrderProgressBean setList_num(String list_num) {
        this.list_num = list_num;
        return this;
    }

    public OrderInfoParams getParams() {
        return params;
    }

    public OrderProgressBean setParams(OrderInfoParams params) {
        this.params = params;
        return this;
    }

    public List<OrderProgressInfoBean> getList() {
        return list;
    }

    public OrderProgressBean setList(List<OrderProgressInfoBean> list) {
        this.list = list;
        return this;
    }
}
