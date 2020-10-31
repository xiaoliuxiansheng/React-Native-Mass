package com.m7.imkfsdk.chat.holder;

import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.m7.imkfsdk.R;

/**
*@Description 收到的卡片信息holder
*@author R-D
*@date 2019-12-24
*/
public class ReceiveCardInfoRxHolder extends BaseHolder {

    public ImageView iv_logistics_tx_img;
    public TextView tv_logistics_tx_title;
    public TextView tv_logistics_tx_price;
    public TextView tv_logistics_tx_num;
    public TextView tv_logistics_tx_second;
    public TextView tv_logistics_tx_state;
    public LinearLayout kf_chat_rich_lin;
    public LinearLayout ll_received_new_order_info;

    public ReceiveCardInfoRxHolder(int type) {
        super(type);
    }


    public BaseHolder initBaseHolder(View baseView, boolean isReceive) {
        super.initBaseHolder(baseView);
        iv_logistics_tx_img = baseView.findViewById(R.id.iv_logistics_tx_img);
        tv_logistics_tx_title = baseView.findViewById(R.id.tv_logistics_tx_title);
        tv_logistics_tx_price = baseView.findViewById(R.id.tv_logistics_tx_price);
        tv_logistics_tx_num = baseView.findViewById(R.id.tv_logistics_tx_num);
        tv_logistics_tx_second = baseView.findViewById(R.id.tv_logistics_tx_second);
        tv_logistics_tx_state = baseView.findViewById(R.id.tv_logistics_tx_state);
        kf_chat_rich_lin = baseView.findViewById(R.id.kf_chat_rich_lin);
        ll_received_new_order_info = baseView.findViewById(R.id.ll_received_new_order_info);
        return this;
    }
}