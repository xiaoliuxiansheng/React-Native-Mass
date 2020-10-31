package com.m7.imkfsdk.chat.model;

import java.util.ArrayList;
import java.util.List;

/**
 * @Description:
 * @Author: R-D
 * @Date: 2019-12-31
 */
public class OrderBaseDataBean {
    private String message;
    private String list_title;
    private String empty_message;
    private String list_num;
    private OrderInfoParams params;
    private List<OrderInfoBean> list;

    public String getList_title() {
        return list_title;
    }

    public OrderBaseDataBean setList_title(String list_title) {
        this.list_title = list_title;
        return this;
    }

    public String getEmpty_message() {
        return empty_message;
    }

    public OrderBaseDataBean setEmpty_message(String empty_message) {
        this.empty_message = empty_message;
        return this;
    }

    public String getList_num() {
        return list_num;
    }

    public OrderBaseDataBean setList_num(String list_num) {
        this.list_num = list_num;
        return this;
    }

    public OrderInfoParams getParams() {
        return params;
    }

    public OrderBaseDataBean setParams(OrderInfoParams params) {
        this.params = params;
        return this;
    }

    public String getMessage() {
        return message;
    }

    public OrderBaseDataBean setMessage(String message) {
        this.message = message;
        return this;
    }

    public List<OrderInfoBean> getList() {
        return list == null ? new ArrayList<OrderInfoBean>() : list;
    }

    public OrderBaseDataBean setList(List<OrderInfoBean> list) {
        this.list = list;
        return this;
    }
}
