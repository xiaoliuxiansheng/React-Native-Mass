package com.m7.imkfsdk.chat.holder;

import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.widget.RelativeLayout;

import com.m7.imkfsdk.R;

/**
 * @FileName: LogisticsProgressRxHolder
 * @Description: 收到的物流进度holder
 * @Author:R-D
 * @CreatDate: 2019-12-02 15:58
 * @Reviser:
 * @Modification Time:2019-12-02 15:58
 */
public class LogisticsProgressRxHolder extends BaseHolder {

    public RelativeLayout rl_logistics;
    public RecyclerView rv_logistics_rx;

    public LogisticsProgressRxHolder(int type) {
        super(type);
    }


    public BaseHolder initBaseHolder(View baseView, boolean isReceive) {
        super.initBaseHolder(baseView);
        rl_logistics = (RelativeLayout) baseView.findViewById(R.id.rl_logistics);
        rv_logistics_rx = (RecyclerView) baseView.findViewById(R.id.rv_logistics_rx);
        return this;
    }

}