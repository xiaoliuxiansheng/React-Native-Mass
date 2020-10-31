package com.m7.imkfsdk.chat.holder;

import androidx.recyclerview.widget.RecyclerView;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.m7.imkfsdk.R;

/**
 * @Description: 多类型RecyclerView 父类型holder
 * @Author: R-D
 * @Date: 2019-12-25
 */
public class OrderShopHolder extends RecyclerView.ViewHolder {

    public final TextView tv_shop_group_name;
    public final ImageView iv_shop_group_img;
    public final TextView tv_shop_group_state;
    public final RelativeLayout rl_shop_main;
    public OrderShopHolder(View itemView) {
        super(itemView);
        this.rl_shop_main = itemView.findViewById(R.id.rl_shop_main);
        this.tv_shop_group_name = itemView.findViewById(R.id.tv_shop_group_name);
        this.iv_shop_group_img = itemView.findViewById(R.id.iv_shop_group_img);
        this.tv_shop_group_state = itemView.findViewById(R.id.tv_shop_group_state);
    }

}
