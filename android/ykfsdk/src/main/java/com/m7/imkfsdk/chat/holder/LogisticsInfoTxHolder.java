package com.m7.imkfsdk.chat.holder;

import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.m7.imkfsdk.R;

/**
 * @FileName: LogisticsInfoTxHolder
 * @Description: 发送的物流信息holder
 * @Author:R-D
 * @CreatDate: 2019-12-02 15:58
 * @Reviser:
 * @Modification Time:2019-12-02 15:58
 */
public class LogisticsInfoTxHolder extends BaseHolder {

    public ImageView iv_logistics_tx_img;
    public TextView tv_logistics_tx_title;
    public TextView tv_logistics_tx_price;
    public TextView tv_logistics_tx_;
    public TextView tv_logistics_tx_num;
    public TextView tv_logistics_tx_second;
    public TextView tv_logistics_tx_state;
    public LinearLayout kf_chat_rich_lin;

    public LogisticsInfoTxHolder(int type) {
        super(type);
    }


    public BaseHolder initBaseHolder(View baseView, boolean isReceive) {
        super.initBaseHolder(baseView);
        iv_logistics_tx_img = baseView.findViewById(R.id.iv_logistics_tx_img);
        tv_logistics_tx_title = baseView.findViewById(R.id.tv_logistics_tx_title);
        tv_logistics_tx_price = baseView.findViewById(R.id.tv_logistics_tx_price);
        tv_logistics_tx_ = baseView.findViewById(R.id.tv_logistics_tx_);
        tv_logistics_tx_num = baseView.findViewById(R.id.tv_logistics_tx_num);
        tv_logistics_tx_second = baseView.findViewById(R.id.tv_logistics_tx_second);
        tv_logistics_tx_state = baseView.findViewById(R.id.tv_logistics_tx_state);
        progressBar =  baseView.findViewById(R.id.uploading_pb);
        kf_chat_rich_lin =  baseView.findViewById(R.id.kf_chat_rich_lin);
        return this;
    }
}