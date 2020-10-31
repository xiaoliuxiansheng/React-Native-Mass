package com.m7.imkfsdk.chat.model;

import com.moor.imkf.model.entity.NewCardInfoAttrs;

/**
 * @Description:
 * @Author: R-D
 * @Date: 2019-12-25
 */
public class OrderInfoBean {
//    "img":"https://img.alicdn.com/imgextra/i2/2228361831/12228361831.jpg",
//            "item_type":"1",
//            "title":"店铺名称",
//            "target":"http://www.baidu.com",
//            "status":"交易成功"

    //     "img":"https://img.alicdn.com/imgextra/i2/2228361831/12228361831.jpg",
//             "sub_title":"副标题字段",
//             "item_type":"0",
//             "other_title_three":"附加信息3",
//             "title":"极品家装北欧风格落地灯",
//             "params":{
//        "orderNo":"1"
//    },
//            "target":"next",
//            "other_title_two":"附加信息2",
//            "attr_one":"X1",
//            "other_title_one":"附加信息1",
//            "attr_two":"已发货",
//            "price":"￥100"
    private String img;
    private String item_type;
    private String title;
    private String target;
    private String status;

    private String sub_title;
    private String other_title_three;
    private String other_title_one;
    private String other_title_two;
    private NewCardInfoAttrs attr_one;
    private NewCardInfoAttrs attr_two;
    private String price;
    private OrderInfoParams params;
    //以下字段物流进度需要
    private String is_current;
    private String desc;


    public String getIs_current() {
        return is_current;
    }

    public OrderInfoBean setIs_current(String is_current) {
        this.is_current = is_current;
        return this;
    }

    public String getDesc() {
        return desc;
    }

    public OrderInfoBean setDesc(String desc) {
        this.desc = desc;
        return this;
    }

    public OrderInfoBean(String item_type) {
        this.item_type = item_type;
    }


    public String getImg() {
        return img;
    }

    public OrderInfoBean setImg(String img) {
        this.img = img;
        return this;
    }

    public String getItem_type() {
        return item_type;
    }

    public OrderInfoBean setItem_type(String item_type) {
        this.item_type = item_type;
        return this;
    }

    public String getTitle() {
        return title;
    }

    public OrderInfoBean setTitle(String title) {
        this.title = title;
        return this;
    }

    public String getTarget() {
        return target;
    }

    public OrderInfoBean setTarget(String target) {
        this.target = target;
        return this;
    }

    public String getStatus() {
        return status;
    }

    public OrderInfoBean setStatus(String status) {
        this.status = status;
        return this;
    }

    public String getSub_title() {
        return sub_title;
    }

    public OrderInfoBean setSub_title(String sub_title) {
        this.sub_title = sub_title;
        return this;
    }

    public String getOther_title_three() {
        return other_title_three;
    }

    public OrderInfoBean setOther_title_three(String other_title_three) {
        this.other_title_three = other_title_three;
        return this;
    }

    public String getOther_title_one() {
        return other_title_one;
    }

    public OrderInfoBean setOther_title_one(String other_title_one) {
        this.other_title_one = other_title_one;
        return this;
    }

    public String getOther_title_two() {
        return other_title_two;
    }

    public OrderInfoBean setOther_title_two(String other_title_two) {
        this.other_title_two = other_title_two;
        return this;
    }

    public NewCardInfoAttrs getAttr_one() {
        return attr_one;
    }

    public OrderInfoBean setAttr_one(NewCardInfoAttrs attr_one) {
        this.attr_one = attr_one;
        return this;
    }

    public NewCardInfoAttrs getAttr_two() {
        return attr_two;
    }

    public OrderInfoBean setAttr_two(NewCardInfoAttrs attr_two) {
        this.attr_two = attr_two;
        return this;
    }

    public String getPrice() {
        return price;
    }

    public OrderInfoBean setPrice(String price) {
        this.price = price;
        return this;
    }

    public OrderInfoParams getParams() {
        return params;
    }

    public OrderInfoBean setParams(OrderInfoParams params) {
        this.params = params;
        return this;
    }
}
