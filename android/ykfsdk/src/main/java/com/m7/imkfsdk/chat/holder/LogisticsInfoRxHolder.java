package com.m7.imkfsdk.chat.holder;

import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.widget.ExpandableListView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.m7.imkfsdk.R;

/**
 * @FileName: LogisticsInfoRxHolder
 * @Description: 收到的物流信息holder
 * @Author:R-D
 * @CreatDate: 2019-12-02 15:58
 * @Reviser:
 * @Modification Time:2019-12-02 15:58
 */
public class LogisticsInfoRxHolder extends BaseHolder {

    public RecyclerView rv_logistics_rx;
    public RelativeLayout rl_logistics;
    public RelativeLayout rl_progress_top;
    public TextView kf_chat_rich_title;
    public TextView kf_chat_rich_content;
    public TextView tv_no_data;
    public TextView tv_logistics_progress_name;
    public TextView tv_logistics_progress_num;
    public LinearLayout ll_order_content;
    public View view_top;
    public View view_middle;

    public LogisticsInfoRxHolder(int type) {
        super(type);
    }


    public BaseHolder initBaseHolder(View baseView, boolean isReceive) {
        super.initBaseHolder(baseView);
        rv_logistics_rx = baseView.findViewById(R.id.rv_logistics_rx);
        rl_logistics = baseView.findViewById(R.id.rl_logistics);
        kf_chat_rich_title = baseView.findViewById(R.id.kf_chat_rich_title);
        kf_chat_rich_content = baseView.findViewById(R.id.kf_chat_rich_content);
        rl_progress_top = baseView.findViewById(R.id.rl_progress_top);
        tv_no_data = baseView.findViewById(R.id.tv_no_data);
        tv_logistics_progress_name = baseView.findViewById(R.id.tv_logistics_progress_name);
        tv_logistics_progress_num = baseView.findViewById(R.id.tv_logistics_progress_num);
        ll_order_content = baseView.findViewById(R.id.ll_order_content);
        view_top = baseView.findViewById(R.id.view_top);
        view_middle = baseView.findViewById(R.id.view_middle);
        return this;
    }

}