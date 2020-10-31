package com.m7.imkfsdk.chat.holder;

import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.m7.imkfsdk.R;

/**
 * @Description: 多类型RecyclerView 子布局holder
 * @Author: R-D
 * @Date: 2019-12-25
 */
public class OrderInfoHolder extends RecyclerView.ViewHolder {

    public final TextView tv_child_title;
    public final ImageView iv_child_img;
    public final TextView tv_child_price;
    public final TextView tv_child_;
    public final TextView tv_child_num;
    public final TextView tv_child_second;
    public final TextView tv_child_state;
    public final RelativeLayout rl_child_main;

    public OrderInfoHolder(View itemView) {
        super(itemView);
        this.tv_child_title = itemView.findViewById(R.id.tv_child_title);
        this.iv_child_img = itemView.findViewById(R.id.iv_child_img);
        this.tv_child_price = itemView.findViewById(R.id.tv_child_price);
        this.tv_child_ = itemView.findViewById(R.id.tv_child_);
        this.tv_child_num = itemView.findViewById(R.id.tv_child_num);
        this.tv_child_second = itemView.findViewById(R.id.tv_child_second);
        this.tv_child_state = itemView.findViewById(R.id.tv_child_state);
        this.rl_child_main = itemView.findViewById(R.id.rl_child_main);
    }

}
