package com.m7.imkfsdk.chat.model;

/**
 * @Description:
 * @Author: R-D
 * @Date: 2019-12-31
 */
public class OrderBaseBean {
    private String resp_type;
    private String current;
    private OrderBaseDataBean data;

    public String getResp_type() {
        return resp_type;
    }

    public OrderBaseBean setResp_type(String resp_type) {
        this.resp_type = resp_type;
        return this;
    }

    public String getCurrent() {
        return current;
    }

    public OrderBaseBean setCurrent(String current) {
        this.current = current;
        return this;
    }

    public OrderBaseDataBean getData() {
        return data;
    }

    public OrderBaseBean setData(OrderBaseDataBean data) {
        this.data = data;
        return this;
    }
}
