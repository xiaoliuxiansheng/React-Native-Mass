package com.m7.imkfsdk.chat.holder;

import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.m7.imkfsdk.R;

/**
 * @Description: 发给坐席的卡片holder
 * @Author:R-D
 * @CreatDate: 2019-12-02 15:58
 */
public class NewCardInfoTxHolder extends BaseHolder {

    public LinearLayout ll_other_title;
    public ImageView iv_order_img;
    public TextView tv_order_title;
    public TextView tv_order_;
    public TextView tv_send_order;
    public LinearLayout ll_order_main;

    public NewCardInfoTxHolder(int type) {
        super(type);
    }


    public BaseHolder initBaseHolder(View baseView, boolean isReceive) {
        super.initBaseHolder(baseView);
        ll_other_title = (LinearLayout) baseView.findViewById(R.id.ll_other_title);
        iv_order_img = (ImageView) baseView.findViewById(R.id.iv_order_img);
        tv_order_title = (TextView) baseView.findViewById(R.id.tv_order_title);
        tv_order_ = (TextView) baseView.findViewById(R.id.tv_order_);
        tv_send_order = (TextView) baseView.findViewById(R.id.tv_send_order);
        ll_order_main = (LinearLayout) baseView.findViewById(R.id.ll_order_main);
        return this;
    }


}