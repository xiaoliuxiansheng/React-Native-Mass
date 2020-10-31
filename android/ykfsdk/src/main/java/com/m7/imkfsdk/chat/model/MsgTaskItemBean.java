package com.m7.imkfsdk.chat.model;

/**
 * @Description:
 * @Author: R-D
 * @Date: 2019-12-31
 */
public class MsgTaskItemBean {
    private String target;
    private String page;
    private OrderInfoParams params;

    public String getPage() {
        return page;
    }

    public MsgTaskItemBean setPage(String page) {
        this.page = page;
        return this;
    }

    public String getTarget() {
        return target;
    }

    public MsgTaskItemBean setTarget(String target) {
        this.target = target;
        return this;
    }

    public OrderInfoParams getParams() {
        return params;
    }

    public MsgTaskItemBean setParams(OrderInfoParams params) {
        this.params = params;
        return this;
    }
}
