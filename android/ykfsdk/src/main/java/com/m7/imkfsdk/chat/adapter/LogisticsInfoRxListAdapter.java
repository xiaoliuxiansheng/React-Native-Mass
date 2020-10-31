package com.m7.imkfsdk.chat.adapter;

import android.content.Context;
import android.graphics.Color;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.bumptech.glide.Glide;
import com.bumptech.glide.load.resource.bitmap.RoundedCorners;
import com.bumptech.glide.request.RequestOptions;
import com.m7.imkfsdk.R;
import com.m7.imkfsdk.chat.ChatActivity;
import com.m7.imkfsdk.chat.holder.ViewHolderTag;
import com.m7.imkfsdk.chat.model.OrderInfoBean;
import com.m7.imkfsdk.chat.holder.OrderInfoHolder;
import com.m7.imkfsdk.chat.holder.OrderShopHolder;
import com.m7.imkfsdk.utils.DensityUtil;
import com.moor.imkf.utils.NullUtil;

import java.util.List;

/**
 * @Description: 查看更多订单信息的adapter
 * @Author: R-D
 * @Date: 2019-12-25
 */
public class LogisticsInfoRxListAdapter extends RecyclerView.Adapter {
    List<OrderInfoBean> mData;
    /*
         父类型布局
          */
    private static final int SHOP_ITEM_LAYOUT = R.layout.item_shop_group;
    /*
    子类型布局
     */
    private static final int ORDER_ITEM_LAYOUT = R.layout.item_shop_child;
    private Context context;
    private String current;
    private String _id;
    //true：查看更多订单信息；false：会话中的订单信息
    private boolean isFromMoreLogistics;

    public LogisticsInfoRxListAdapter(List<OrderInfoBean> mData, String current, boolean isFromMoreLogistics, String _id) {
        this.mData = mData;
        this.current = current;
        this._id = _id;
        this.isFromMoreLogistics = isFromMoreLogistics;
    }

    @NonNull
    @Override
    public RecyclerView.ViewHolder onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        context = parent.getContext();
        if (viewType == 1) {
            View view = LayoutInflater.from(context).inflate(SHOP_ITEM_LAYOUT, parent, false);
            return new OrderShopHolder(view);
        } else {
            View view = LayoutInflater.from(context).inflate(ORDER_ITEM_LAYOUT, parent, false);
            return new OrderInfoHolder(view);
        }
    }

    @Override
    public void onBindViewHolder(@NonNull RecyclerView.ViewHolder holder, int position) {
        int viewType = holder.getItemViewType();
        OrderInfoBean orderInfoBean = mData.get(position);
        View.OnClickListener listener = ((ChatActivity) context).getChatAdapter().getOnClickListener();
        if (viewType == 1) {
            OrderShopHolder shopHolder = (OrderShopHolder) holder;
            shopHolder.tv_shop_group_name.setText(orderInfoBean.getTitle());
            shopHolder.tv_shop_group_state.setText(orderInfoBean.getStatus());
            Glide.with(context).load(orderInfoBean.getImg())
                    .apply(RequestOptions.bitmapTransform(new RoundedCorners(DensityUtil.dip2px(2f))).error(R.drawable.image_download_fail_icon))
                    .into(shopHolder.iv_shop_group_img);

            //店铺点击事件
            ViewHolderTag holderTag = ViewHolderTag.createTag(orderInfoBean.getTarget(), ViewHolderTag.TagType.TAG_CLICK_LOGISTICS_RX_SHOP);
            shopHolder.rl_shop_main.setTag(holderTag);
            shopHolder.rl_shop_main.setOnClickListener(listener);

        } else {
            OrderInfoHolder childHolder = (OrderInfoHolder) holder;
            if (NullUtil.checkNULL(orderInfoBean.getTitle())) {
                childHolder.tv_child_title.setText(orderInfoBean.getTitle());
            }
            if (NullUtil.checkNULL(orderInfoBean.getSub_title())) {
                childHolder.tv_child_.setText(orderInfoBean.getSub_title());
            }
            if (NullUtil.checkNULL(orderInfoBean.getAttr_one().getColor())) {
                String color = orderInfoBean.getAttr_one().getColor();
                if (color.contains("#")) {
                    try {
                        childHolder.tv_child_num.setTextColor(Color.parseColor(color));
                    } catch (Exception e) {

                    }
                }
            }
            if (NullUtil.checkNULL(orderInfoBean.getAttr_two().getColor())) {
                String color = orderInfoBean.getAttr_two().getColor();
                if (color.contains("#")) {
                    try {
                        childHolder.tv_child_state.setTextColor(Color.parseColor(color));
                    } catch (Exception e) {

                    }
                }
            }
            if (NullUtil.checkNULL(orderInfoBean.getAttr_one().getContent())) {
                childHolder.tv_child_num.setText(orderInfoBean.getAttr_one().getContent());
            }
            if (NullUtil.checkNULL(orderInfoBean.getAttr_two().getContent())) {
                childHolder.tv_child_state.setText(orderInfoBean.getAttr_two().getContent());
            }
            if (NullUtil.checkNULL(orderInfoBean.getPrice())) {
                childHolder.tv_child_price.setText(orderInfoBean.getPrice());
            }


            if (NullUtil.checkNULL(orderInfoBean.getOther_title_three())) {
                childHolder.tv_child_second.setText(orderInfoBean.getOther_title_three());
            }
            if (NullUtil.checkNULL(orderInfoBean.getOther_title_two())) {
                childHolder.tv_child_second.setText(orderInfoBean.getOther_title_two());
            }
            if (NullUtil.checkNULL(orderInfoBean.getOther_title_one())) {
                childHolder.tv_child_second.setText(orderInfoBean.getOther_title_one());
            }


            Glide.with(context).load(orderInfoBean.getImg())
                    .apply(RequestOptions.bitmapTransform(new RoundedCorners(DensityUtil.dip2px(2f))).error(R.drawable.image_download_fail_icon))
                    .into(childHolder.iv_child_img);
            //item点击事件
            if (orderInfoBean.getParams() != null) {
                if (NullUtil.checkNULL(orderInfoBean.getParams().getOrderNo())) {
//                    ViewHolderTag holderTag = ViewHolderTag.createObjectTag(orderInfoBean, ViewHolderTag.TagType.TAG_CLICK_LOGISTICS_RX_ITEM);
                    ViewHolderTag holderTag = ViewHolderTag.createTag(current, _id, orderInfoBean
                            , ViewHolderTag.TagType.TAG_CLICK_LOGISTICS_RX_ITEM);
                    childHolder.rl_child_main.setTag(holderTag);
                    childHolder.rl_child_main.setOnClickListener(listener);
                }
            }


        }
    }

    @Override
    public int getItemViewType(int position) {
        if (mData.get(position).getItem_type().equals("1")) {
            return 1;
        } else {
            return 0;
        }
    }

    @Override
    public int getItemCount() {
        if (mData != null) {
            if (isFromMoreLogistics) {
                return mData.size();
            } else {
                if (mData.size() > 5) {
                    return 5;
                } else if (mData.size() == 5 && mData.get(mData.size() - 1).getItem_type().equals("1")) {
                    return 4;
                } else {
                    return mData.size();
                }
            }

        } else {
            return 0;
        }
    }
}
