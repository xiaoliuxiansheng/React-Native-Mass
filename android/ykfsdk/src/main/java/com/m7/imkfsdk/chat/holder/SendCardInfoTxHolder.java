package com.m7.imkfsdk.chat.holder;

import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.m7.imkfsdk.R;

/**
*@Description 发出的卡片信息holder
*@author R-D
*@date 2019-12-24
*/
public class SendCardInfoTxHolder extends BaseHolder {

    public ImageView iv_child_img;
    public TextView tv_child_title;
    public TextView tv_child_;
    public TextView tv_child_num;
    public TextView tv_child_price;
    public TextView tv_child_state;
    public LinearLayout ll_other_title;

    public SendCardInfoTxHolder(int type) {
        super(type);
    }


    public BaseHolder initBaseHolder(View baseView, boolean isReceive) {
        super.initBaseHolder(baseView);
        iv_child_img = baseView.findViewById(R.id.iv_child_img);
        tv_child_title = baseView.findViewById(R.id.tv_child_title);
        tv_child_ = baseView.findViewById(R.id.tv_child_);
        tv_child_num = baseView.findViewById(R.id.tv_child_num);
        tv_child_price = baseView.findViewById(R.id.tv_child_price);
        tv_child_state = baseView.findViewById(R.id.tv_child_state);
        ll_other_title = baseView.findViewById(R.id.ll_other_title);
        progressBar =  baseView.findViewById(R.id.uploading_pb);
        return this;
    }
}