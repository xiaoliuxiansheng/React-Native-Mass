package com.m7.imkfsdk.chat.model;

/**
 * @Description:
 * @Author: R-D
 * @Date: 2019-12-31
 */
public class MsgTaskBean {
    private String current;
    private MsgTaskItemBean item;

    public String getCurrent() {
        return current;
    }

    public MsgTaskBean setCurrent(String current) {
        this.current = current;
        return this;
    }

    public MsgTaskItemBean getItem() {
        return item;
    }

    public MsgTaskBean setItem(MsgTaskItemBean item) {
        this.item = item;
        return this;
    }
}
